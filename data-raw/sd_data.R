## code to prepare `sd_data` dataset goes here
sd_data<-read.csv("SD_data.csv", sep=",", header=T, encoding = "UTF-8-ROM")

usethis::use_data(sd_data, overwrite = TRUE)
