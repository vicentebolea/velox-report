require(ggplot2)
require(scales)

normalize_time_simple <- function(df) {
  df$start_time <- as.POSIXlt(df$start_time, format="%H:%M:%S")
  df$end_time   <- as.POSIXlt(df$end_time, format="%H:%M:%S")

  first_time <- min(df$start_time)

  df$start_time <- difftime(df$start_time, first_time, units='sec')
  df$end_time <- difftime(df$end_time, first_time, units='sec')

  df$diff <- df$end_time - df$start_time

  df <<- df
}

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

remove_reduces <- function(df) {
  df <- df[which(df$type == 'm'),]
  df <<- df
}

compute_waves <- function(df, waves=3, iterations=10000) {
  df <- df[which(df$type == 'm'),]
  print(head(df))
  attach(df)
  df$wave <- 1

  df[which(df$dfs == 'hdfs'),]$wave <- kmeans(df[which(df$dfs == 'hdfs'),]$start_time, centers=3, iter=1000000)$cluster


  print(df[which(df$dfs == 'hdfs'),]$wave)

  #print(aggregate(start_time ~ experiment, data=df[which(df$dfs == 'hdfs'),], FUN=function(start_time) {
  #              return(kmeans(start_time, centers=3, iter=100000))
  #}))

  col_min <- aggregate(start_time, by=list(experiment,df$wave), min)
  col_max <- aggregate(end_time, by=list(experiment,df$wave), max)
  col_waves <- aggregate(df$wave, by=list(experiment,df$wave), mean)

  waves_df <- data.frame(jobs=col_min$Group.1, waves=col_waves$x, min_time=col_min$x, max_time=col_max$x)
  waves_df <- waves_df[order(waves_df$min_time),]

  detach(df)
  waves_df <<- waves_df
}

waves_plot <- function(waves) {
  FONT_SIZE_X=12
  FONT_SIZE_Y=4

  l=c('4mb', '8mb','16mb', '32mb', '64mb', '128mb', '128mb', '128mb', '128mb')

  idx=sort(as.numeric(row.names(waves)))

  earliest=min(waves$max_time)

  p <- ggplot() +
    geom_rect(data=waves, aes(ymin=idx - 0.2, ymax=idx+ 0.2, xmin=min_time, xmax=max_time, fill=dfs),color = "black") +
    geom_label(data=waves, aes(x = (max_time +min_time)/2, y = idx, label=l), fill="transparent", color="white") +
    #geom_vline(xintercept=max(earliest), size=1) +
    scale_x_discrete(name="Seconds", limits=seq(0,max(waves$max_time),10)) +
    ggtitle("Waves execution time") +
    guides(fill=guide_legend(title="FileSystem")) +                                                                          # Leyend title
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +                                          # Remove Grid
    theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +                         # Remove y axis
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_fill_grey()                                                                                                        # Grey bins

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
