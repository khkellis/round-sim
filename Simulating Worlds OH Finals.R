#Load libaries and define datasets
library(RMySQL)
library(data.table)
library(readxl)
top <- read_excel("~/Documents/Cube Stuff/WorldsOHTop80.xlsx",col_names = FALSE)
WCA <- dbConnect(MySQL(), user='root', password='password', dbname='WCA', host='localhost')

#Define variables
event <- "'333oh'"
sim_count <- 1000000

#get times for every person in top80
counter1 <- 0
for(i in 1:nrow(top)){
  assign(paste("rank_", i, sep = ""), dbGetQuery(WCA, paste("CALL get_person_times(", "'",top[i,1],"'", ",", event ,");", sep = "")))
  print(i)
  setnames(eval(parse(text=paste("rank_",i,sep=""))), old = "V", new = paste(top[i,1]))
  counter1 <- counter1 +1
  while(dbMoreResults(WCA) == TRUE) {
    dbNextResult(WCA)
  }
}

###generate avg5 for each person and order them

averages <- matrix(c(1:sim_count*nrow(top)), nrow = sim_count, ncol = nrow(top))
colnames(averages) <- t(top)
counter2 <- 0

for(i in 1:sim_count){
  for(j in 1:nrow(top)){
    temp_sample <- sample(t(eval(parse(text = paste("rank_",j,sep="")))),5, replace = TRUE)
    averages[i,j] <- 1/3*(sum(temp_sample)-max(temp_sample)-min(temp_sample))*1/100#divide by 100 to get seconds
    counter2 <- counter2+1
  }
}

#create the rounds
for(i in 1:sim_count){
  assign(paste("round_",i,sep=""),averages[i:i,])
}
#generate cutoffs
cutoffs <- vector()
for(i in 1:sim_count){
  sorted <- sort(t(eval(parse(text = paste("round_",i,sep="")))))
  cutoff <- sorted[16]
  cutoffs <- append(cutoffs, cutoff)
}
hist(cutoffs,breaks = 50, main = "Simulated Worlds 2019 OH Final Cutoff Distribution", freq = FALSE)
mean(cutoffs)

#generate counters
for(i in 1:nrow(top)){
  assign(paste("count_",i,sep=""),0)
}

#fill counters
for(i in 1:sim_count){
  for(j in 1:nrow(top)){
    if (averages[i,j]<cutoffs[i]){
      assign(paste("count_",j,sep=""),1+eval(parse(text = paste("count_",j,sep=""))))
    }
  }
}