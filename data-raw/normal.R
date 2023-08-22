## code to prepare `normal` dataset goes here
normal<-read.csv("Data Upload 1 - Normal.csv", sep=",", header=T, encoding = "UTF-8-ROM")
usethis::use_data(normal, overwrite = TRUE)
