require(ggplot2)
require(scales)

normalize_time <- function(df, exps=unique(df$experiment)) {
  df$start_time <- as.POSIXlt(df$start_time, format="%H:%M:%S")
  df$end_time   <- as.POSIXlt(df$end_time, format="%H:%M:%S")

  df$tmp_start <- 0
  df$tmp_end <- 0
  lapply(exps, function(exp) {
    # Group by name
    df[which(df$experiment == exp),]$tmp_start <<- difftime(df[which(df$experiment == exp),]$start_time, min(df[which(df$experiment == exp),]$start_time), units='sec')
    df[which(df$experiment == exp),]$tmp_end <<- difftime(df[which(df$experiment == exp),]$end_time, min(df[which(df$experiment == exp),]$start_time), units='sec')
    df <<- df
  })

  df$start_time <- df$tmp_start
  df$end_time   <- df$tmp_end
  df$diff <- df$end_time - df$start_time

  df$tmp_start <- NULL
  df$tmp_end   <- NULL

  df <<- df
}

cluster_waves <- function(df, waves=3, iterations=10000) {
  exps=unique(df$experiment)

  df$mean_time <- (df$start_time + df$end_time)/2
  df$wave <- 0
  lapply(exps, function(exp) {
    df[which(df$experiment == exp),]$wave = kmeans(df[which(df$experiment == exp),]$start_time, centers=waves, iter=iterations)$cluster
    df <<- df
  })


  df[which(df$dfs == 'velox'),]$wave = 1
  df <<- df
}

remove_reduces <- function(df) {
  df <- df[which(df$type == 'MAP'),]
  df <<- df
}

cluster_set <- function(df) {
  exps=unique(df$experiment)

   waves_df <- data.frame()

  lapply(exps, function(exp) {
    waves=unique(df[which(df$experiment == exp),]$wave)
    print(waves)

    lapply(waves, function(wave) {
      mi <- min(df[which(df$experiment == exp & df$wave == wave),]$start_time)
      ma <- max(df[which(df$experiment == exp & df$wave == wave),]$end_time)

      waves_df <- rbind(waves_df, data.frame(wave=wave, job=exp, min_time=mi, max_time=ma))
      waves_df <<- waves_df
    })
    waves_df <<- waves_df
  })

  waves_df <<- waves_df
}

waves_plot <- function(df) {
  FONT_SIZE_X=12
  FONT_SIZE_Y=4

  p <- ggplot() + 
    geom_rect(data=df, aes(ymin=as.numeric(row.names(df)) - 0.5, ymax=as.numeric(row.names(df)), xmin=min_time, xmax=max_time, fill=job),color = "red",size = 0) +
    scale_x_discrete(name="seconds", limits=seq(0,max(df$max_time),10)) +
    theme(axis.text.x = element_text(size=8)) +
		theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) 

  return(p)
}

tasks_plot <- function(df, exp) {
  df <- df[which(df$experiment == exp),]
  print(summary(df$diff))
  FONT_SIZE_X=12
  FONT_SIZE_Y=4
  p <- ggplot() + 
    geom_rect(data=df, aes(ymin=task_name, ymax=task_name, xmin=start_time, xmax=end_time),color = "red",size = 1) +
    geom_vline(xintercept=max(df$end_time), size=2, color=4) +
    scale_x_discrete(name="seconds", limits=seq(1,max(df$end_time),5)) +

    theme_gray() +
    theme(text=  element_text(size=FONT_SIZE_Y)) + 
    theme(axis.text.x = element_text(size=FONT_SIZE_X)) +
    theme(plot.title = element_text(size=28)) +
    ggtitle(exp)

  return(p)
}


