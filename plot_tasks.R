require(ggplot2)
require(scales)

## Variables to be set
FONT_SIZE_X=12
FONT_SIZE_Y=5

## Source code
args = commandArgs(trailingOnly=TRUE)

df = read.csv("stdin")

df$start = as.POSIXct(df$start_time, format="%H:%M:%S")
df$end = as.POSIXct(df$end_time, format="%H:%M:%S")

df$diff = difftime(df$end, df$start, units = "secs")

summary(as.numeric(df$diff))

p <- ggplot() + 
  geom_rect(data=df, aes(ymin=task_name, ymax=task_name, xmin=start, xmax=end),color = "red",size = 1) +
  scale_x_datetime(date_breaks= "20 sec", date_minor_breaks = "1 sec", date_labels = "%M:%S") +
  theme(text=  element_text(size=FONT_SIZE_Y)) + 
  theme(axis.text.x = element_text(size=FONT_SIZE_X)) 
  

ggsave(file=args[1], plot=p, width=15, height=15)
