## code to prepare `severe` dataset goes here
severe<-read.csv("Data Upload 1 - Severe.csv", sep=",", header=T, encoding = "UTF-8-ROM")

usethis::use_data(severe, overwrite = TRUE)
