require(ggplot2)
require(scales)
require(dplyr)
require(cowplot)
theme_set(theme_cowplot(font_size=5))
source('velox-stats-lib.R')

df <- read.csv("stdin")
df <- normalize_time(df) 

#p1 <- tasks_plot(df,"hdfs_1_nos")
#p2 <- tasks_plot(df,"hdfs_3_nos")
p3 <- tasks_plot(df ,"hdfs_3_s")
p4 <- tasks_plot(df ,"velox_nos")
#p5 <- tasks_plot(df, "velox_s")


p <- plot_grid(p3, p4,labels='auto') + theme(plot.margin = unit(c(2,2,2,2), "cm"))  

ggsave(file='out.png', plot=p, width=35, height=25)
#
