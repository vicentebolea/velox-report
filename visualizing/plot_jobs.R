#!/usr/bin/env Rscript

all_jobs <- read.csv('jobs.csv')
tasks    <- read.csv('tasks.csv')

# Get partial IO jobs
partial_io_jobs <- all_jobs[which(all_jobs$io_usage == 0.3),]

# Get max time of each jobs' tasks 
job_exec_time <- aggregate(end_time ~ experiment, tasks, max)

# Join
jobs <- merge(partial_io_jobs, job_exec_time, by.x='job_id', by.y='experiment')

velox_jobs <- jobs[-which(jobs$dfs == "hdfs"),]
hdfs_jobs  <- jobs[which(jobs$dfs == "hdfs"),]

velox_jobs <- aggregate(end_time ~ alpha, velox_jobs, mean)
hdfs_jobs  <- mean(hdfs_jobs$end_time)

# Plotting our data
attach(velox_jobs)

# pch: triangle
plot(alpha, end_time, ylim=c(min(hdfs_jobs), max(end_time)),   # Plot parameters (Data and scale)
     type="b", pch=24, col="black",                            # Plot style
     main="IO ~33% Worcount job exec time",                    # Plot labels
     xlab="IO sensitivity", 
     ylab="Seconds")
abline(h=c(min(end_time), min(hdfs_jobs)), col=c("black", "red"), lty=3) # Plot minimuns
legend('topright', legend = c("VELOX", "HDFS"), col = c("black", "red"), pch = 24)

detach(velox_jobs)
