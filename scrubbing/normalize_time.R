source('velox-stats-lib.R')

df <- read.csv("stdin")
df <- normalize_time_simple(df) 

write.csv(df, stdout(), quote=FALSE, row.names=FALSE)

