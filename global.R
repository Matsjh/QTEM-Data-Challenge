# Shiny app global 

library("stm")
library("dplyr")
library("tm")
library("Rfacebook")
library("zoo")
#setwd("/Users/Mathilda/Documents/Mats/R/QTEM")

#Access token
rm(list = ls())
#load("fb_oauth")

fb.page.id <- data.frame(page=c("Budweiser","Stella Artois", "Hoegaarden"),id= c("52880441687","203468776336103","1224916710936160"), stringsAsFactors = F)

