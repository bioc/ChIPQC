ChIPQCsample = function(reads, peaks, annotation=NULL, chromosomes=NULL, 
                        mapQCth=15, blacklist, profileWin=400,fragmentLength=125,shifts=1:300,runCrossCor=FALSE,verboseT=TRUE) {
  
  if(missing(peaks)) peaks=NULL
  if(!missing(peaks)){
    if(!is.null(peaks)){
      if(length(peaks) == 1) {
        if(is.na(peaks)[1]) peaks=NULL
      }
    }
  }
  if(missing(blacklist)) blacklist=NULL
  if(!missing(blacklist)){
    if(!is.null(blacklist)){
      if(is.na(blacklist)[1]) blacklist=NULL
    }
  }
  res = sampleQC(bamFile=reads, bedFile=peaks, GeneAnnotation=annotation,blklist=blacklist,ChrOfInterest=chromosomes,
                 Window=profileWin,FragmentLength=fragmentLength,
                 shiftWindowStart=min(shifts),shiftWindowEnd=max(shifts),runCrossCor=runCrossCor,verboseT=verboseT)
  
  return(res)
}

ChIPQC = function(experiment, annotation, chromosomes, samples, 
                  consensus=FALSE, bCount=FALSE, mapQCth=15, blacklist=NULL, 
                  profileWin=400,fragmentLength=125,shifts=1:300,...) {
  
  if(sum(class(experiment)=="character") || sum(class(experiment)=="data.frame")) {
    experiment = DiffBind::dba(sampleSheet=experiment,peakCaller="bed")
  } 
  
  if(!sum(class(experiment)=="DBA")) {
    stop("experiment must be either a samplesheet filename or a DBA (DiffBind) object.")
  }
  
  experiment$config$mapQCth = mapQCth
  
  meta = data.frame(t(experiment$class))
  
  if(length(unique(meta$bamRead)) != nrow(meta)) {
    stop('Unable to process. Each bam file must be associated with at most one peakset.')
  }
  
  if(!missing(samples)) {
    for(i in 1:length(experiment$peaks)) {
      if(nrow(experiment$peaks[[i]])==0) {
        experiment = addMatchingSample(experiment,i,meta,samples)
      }
    }
    experiment = DiffBind::dba(experiment)
  }
  
  if(missing(chromosomes)) {
    chromosomes=1
  }
  if(is.numeric(chromosomes) && missing(samples)) {
    chrmap = experiment$chrmap
    if(length(chrmap)==0) {
      warning('No chromosomes specified in peaks, using all.')
      chromosomes = NULL
    } else {
      if(max(chromosomes)>length(chrmap)) {
        warning('Specified chromosome number exceeds chromosomes seen in peaks.')
        chromosomes = chromosomes[chromosomes<=length(chrmap)]
      } 
      chromosomes = chrmap[chromosomes]
      message("Checking chromosomes:")
      print(chromosomes)
    }
  }
  
  if(!missing(annotation)) {
    if(!is.null(annotation) && missing(samples)) {
      if(!sum(class(annotation)=="list")) {
        message('Compiling annotation...')
        annotation = getAnnotation(annotation,AllChr=chromosomes)
      }
      if(annotation$version=="hg19" && missing(blacklist)) {
        blacklist = read.table(file.path(system.file("extdata", package="ChIPQC"),
                                         "blacklist_hg19.bed"),header=TRUE)[,1:4]
        blacklist = makeGRangesFromDataFrame(blacklist,ignore.strand=TRUE)
        message("Using default blacklist for hg19...")
      }
    } else if(sum(class(annotation)=="character")) {
      annotation = list(version=annotation)
    } else {
      annotation = list(version="none")
    }
  } else {
    annotation = list(version="none")
  }
  
  
  samplelist = NULL
  controlist = NULL
  for(i in 1:nrow(meta)) {
    newrec = NULL
    newrec$peaks = experiment$peaks[[i]]
    if(nrow(newrec$peaks)==0) {
      newrec$peaks = NULL
    }
    newrec$bam   = as.character(meta$bamRead[i])
    samplelist   = listadd(samplelist,newrec)
    if(!is.null(meta$bamControl[i])) {
      if(!is.na(meta$bamControl[i])) {
        if(meta$bamControl[i]!="") {
          savenames = names(controlist) 
          controlist = listadd(controlist,as.character(meta$bamControl[i]))
          names(controlist) = c(savenames,as.character(meta$Control[i]))
        }
      }
    }
  }
  controlist = controlist[!duplicated(controlist)]
  controls = 0
  for(cfile in controlist) {
    if (!(cfile %in% as.character(meta$bamRead))) {
      newrec = NULL
      newrec$bam = cfile
      newrec$peaks=NULL
      samplelist = listadd(samplelist,newrec)
      controls = controls+1
    }
  }
  
  names(samplelist) = unique(c(rownames(meta),names(controlist)))
  
  addconsensus = FALSE
  addcontrols  = FALSE
  setNull <- TRUE   
  peaks <- NA
  
  if(sum(class(consensus) == "GRanges")) {
    useConsensus <- TRUE
  } else {
    if(sum(class(consensus) == "logical")){
      if(consensus == TRUE) {
        useConsensus <- TRUE
      } else {
        useConsensus <- FALSE
      }
    } else {
      stop("consensus must be either a logical or a GRanges.")
    }
  }
  
  if(useConsensus == TRUE) {
    addcontrols  <- TRUE
    addconsensus <- TRUE
    if(sum(class(consensus) == "GRanges")) {
      peaks <- consensus
      setNull <- FALSE   
    } else {
      setNull <- TRUE      
      peaks <- DiffBind::dba.peakset(experiment,bRetrieve=T,numCols=3,
                                     DataType=DBA_DATA_FRAME)
    }
  } else if(bCount) {
    addcontrols <- TRUE
    if(consensus==FALSE) {
      setNull <- TRUE
      peaks <- DiffBind::dba.peakset(experiment,bRetrieve=TRUE,
                                     DataType=DBA_DATA_FRAME)[,1:4]      
    }
  } 
  
  if(addcontrols && controls) {
    message("Adding controls...")
    startpos = length(samplelist) - controls
    for(i in 1:controls) {
      metadata   = getMeta(meta,names(samplelist)[[startpos+i]])
      experiment = DiffBind::dba.peakset(experiment,peaks=peaks,
                                         sampID    = names(samplelist)[[startpos+i]],
                                         factor    = "Control",
                                         tissue    = metadata$tissue,
                                         condition = metadata$condition,
                                         treatment = metadata$treatment,
                                         replicate = sprintf("c%s",i),
                                         bamReads=samplelist[[startpos+i]]$bam)
    }
    meta = data.frame(t(experiment$class))
  }
  
  if(is.na(peaks)[1] || setNull==TRUE) {
    peaks = NULL
  }
  
  if(bCount) {
    message('Counting reads in consensus peakset...')
    if(!is.null(peaks)) {
      if(!is.na(match("summits",names(list(...))))) {
        experiment = DiffBind::dba.count(experiment,peaks=peaks,
                                         mapQCth=mapQCth,...) 
      } else {
        experiment = DiffBind::dba.count(experiment,peaks=peaks,
                                         summits=FALSE,mapQCth=mapQCth,...) 
      }
      meta = data.frame(t(experiment$class))
    } else {
      if(!is.na(match("summits",names(list(...))))) {
        experiment = DiffBind::dba.count(experiment,mapQCth=mapQCth,...) 
      } else {
        experiment = DiffBind::dba.count(experiment,summits=FALSE,mapQCth=mapQCth,...) 
      }
      meta = data.frame(t(experiment$class))
    }
    if(nrow(meta) != length(samplelist)) {
      warning('Samples and peaksets out of sync')
    }
  }
  if(nrow(experiment$merged)>0) {
    peaks = DiffBind::dba.peakset(experiment,bRetrieve=TRUE)
  } else peaks = NULL
  
  if(addcontrols && addconsensus) {
    for(i in 1:length(samplelist)) samplelist[[i]]$peaks = peaks
  } else if (addcontrols) {
    for(i in 1:length(samplelist)) {
      if(is.null(samplelist[[i]]$peaks)) {
        samplelist[[i]]$peaks = peaks  
      } 
    }     
  }
  
  if(missing(samples)) {
    
    message(sprintf("Computing metrics for %d samples...",length(samplelist)))
    
    if (!requireNamespace("BiocParallel",quietly=TRUE)) {
      stop("package BiocParallel must be installed to use this function.")
    } else {
      params <- BiocParallel::bpparam()
      if(is.null(params)) {
        BiocParallel::register(BiocParallel::SerialParam(), default=TRUE)
      } 
      if(is(params,"SerialParam")) {
        message("Executing serially")
        runparallel <- FALSE
      } else {
        runparallel <- TRUE   
        if(is(params,"MulticoreParam")) {
          message("Executing in parallel - max ",multicoreWorkers()," cores.")
        } else {
          if(is(params,"SnowParam")) {
            message("Executing in parallel - max ",snowWorkers()," SNOW workers.")
          }
        }
      }
    }
    
    if(runparallel) {
      samples <- suppressMessages(
        BiocParallel::bplapply(samplelist,doChIPQCsample,experiment,
                               chromosomes, annotation, mapQCth, 
                               blacklist, profileWin,
                               fragmentLength,shifts)
      )   
    } else {
      samples <- BiocParallel::bplapply(samplelist,doChIPQCsample,experiment,
                                        chromosomes, annotation, mapQCth, 
                                        blacklist, profileWin,
                                        fragmentLength,shifts)
    }
    names(samples) = names(samplelist)
    errors = FALSE
    for(i in 1:length(samples)) {
      sample = samples[[i]]
      if(!sum(class(sample) == "ChIPQCsample")) {
        message("Error in sample ",names(samples)[i],": ",sample[1])
        errors = TRUE
      }
    }
    if(errors) {
      stop("Errors in generating sample data.")
    }
  } else {
    if(length(samples) < length(samplelist)) {
      stop('Not enough samples!')
    } else if (length(samples) > length(samplelist)) {
      warning("Ignoring some samples without metadata.")
    }
    newsamps = NULL
    for(sampname in names(samplelist)) {
      whichsamp = which(names(samples) %in% sampname) 
      if(length(whichsamp)==0) {
        stop(sprintf("Sample %d missing from sample list",sampname))
      } else if(length(whichsamp)>1) {
        stop(sprintf("Sample %d appears more than once in sample list",sampname))
      }
      newsamps = listadd(newsamps,samples[[whichsamp]])
      names(newsamps)[length(newsamps)]=sampname
    }
    samples = newsamps
  }
  
  res = new("ChIPQCexperiment",Samples=samples,DBA=experiment,annotation=annotation)
  config = as.list(res@DBA$config)
  config$fragmentSize = fragmentlength(res)
  config$mapQCth = mapQCth
  res@DBA$config = config
  
  return(res)
}

doChIPQCsample = function(sample,DBA,chromosomes, annotation, 
                          mapQCth, blacklist, profileWin,
                          fragmentLength,shifts) {
  message(sample$bam)
  res = ChIPQCsample(reads   = sample$bam,
                     peaks   = sample$peaks,
                     chromosomes=chromosomes,annotation=annotation,
                     mapQCth=mapQCth,blacklist=blacklist,profileWin=profileWin,
                     fragmentLength=fragmentLength,shifts=shifts)
  return(res)
}


getMeta = function(meta,control) {
  meta = meta[meta$Control %in% control,]
  tissue    = getMetaFor(meta$Tissue)
  condition = getMetaFor(meta$Condition)
  treatment = getMetaFor(meta$Treatment)
  replicate = getMetaFor(meta$Replicate)
  return(list(tissue=tissue,condition=condition,treatment=treatment,replicate=replicate))
}

getMetaFor = function(values) {
  if(is.null(values)) {
    return("")
  }
  values = as.character(unique(values))
  if(length(values)==1) {
    return(values)
  }
  return(paste(values,collapse=":"))
}

addMatchingSample = function(DBA,sampnum, meta,samples) {
  meta = meta[sampnum,]
  sample = which(names(samples) %in% meta$ID)
  if(length(sample)==0) {
    return(NULL)
  }
  if(length(sample)>1) {
    warning("Ambigious sample name: ",meta$ID)
    return(NULL)
  }
  
  res = as.data.frame(peaks(samples[[sample]]))
  if(ncol(res)>=6) {
    res = res[,c(1:3,6)]
    res[,4] = res[,4]/max(res[,4])
  } else {
    res = res[,1:3]
    if(nrow(res)>0) {
      res = cbind(res,0)
    } else {
      res = matrix(0,0,4)
    }
  }
  colnames(res) = c("CHR","START","END","SCORE")
  if(nrow(res)>0) {
    DBA$chrmap  = unique(c(DBA$chrmap,as.character(res[,1])))
    res[,1] = factor(res[,1],DBA$chrmap) 
  }
  DBA$peaks[[sampnum]] = res
  return(DBA)
}
