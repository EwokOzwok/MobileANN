## code to prepare `mild` dataset goes here
mild<-read.csv("Data Upload 1 - Mild.csv", sep=",", header=T, encoding = "UTF-8-ROM")

usethis::use_data(mild, overwrite = TRUE)
