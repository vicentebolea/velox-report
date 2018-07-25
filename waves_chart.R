source("velox-stats-lib.R")
require('dplyr')

tasks <- read.csv("stdin")

zeroIOexp = c( "1531724764897_0001", "1531731242068_0004", 
               "1531731242068_0001", "1531651500048_0004", 
               "1531731242068_0002", "1531731242068_0003",
               "1531816780049_0001")

zeroIOtasks <- tasks[tasks$experiment %in% zeroIOexp,]

jobs <- read.csv('jobs.csv')

waves <- compute_waves(merge(zeroIOtasks, jobs, by.x="experiment", by.y="jobs"))


jobs <- merge(waves, jobs, by="jobs")
print(jobs)

jobs <- jobs[order(jobs$block_size),]

print(jobs)
p <- waves_plot(jobs)




ggsave(file='out.png', plot=p) #, width=35, height=25)
