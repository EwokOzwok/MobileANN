## code to prepare `moderate` dataset goes here
moderate<-read.csv("Data Upload 1 - Moderate.csv", sep=",", header=T, encoding = "UTF-8-ROM")

usethis::use_data(moderate, overwrite = TRUE)
