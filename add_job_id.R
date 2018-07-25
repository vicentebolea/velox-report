df <- read.csv("stdin")

df$experiment <- sapply(df$task_name, sub, pattern='task_(\\d+_\\d+)\\_[r|m]_\\d+', replacement='\\1', perl=TRUE)

write.csv(df, stdout(), quote=FALSE, row.names=FALSE)
