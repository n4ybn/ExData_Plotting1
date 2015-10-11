## plot1.R - starting over from scratch 2015-10-10
## by David DuPre

## Plot data from:  UC Irvine Machine Learning Repository, a repository for machine learning datasets.
##  Title: "Individual household electric power consumption Data Set"
##  using data from the dates 2007-02-01 and 2007-02-02.
## File format:
## The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
##         
## 1. Date: Date in format dd/mm/yyyy
## 2. Time: time in format hh:mm:ss
## (Both of above replaced by TimeStamp column in my result set.)
## 1. TimeStamp  (All other columns below are reduced by 1.)
## 3. Global_active_power: household global minute-averaged active power (in kilowatt)
## 4. Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
## 5. Voltage: minute-averaged voltage (in volt)
## 6. Global_intensity: household global minute-averaged current intensity (in ampere)
## 7. Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
## 8. Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
## 9. Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

rc <- setwd("C:/downloads/Coursera/Exploratory_Data_Analysis/Exp_Data_Project1/ExData_Plotting1")
library(data.table)
library("sqldf")
library("utils")
path <- getwd()
histfilename <- paste0(path,"History","_",format(Sys.time(), "%Y-%m-%d_%H-%M-%S"),".R")
savehistory(histfilename)

zip.file <- "exdata-data-household_power_consumption.zip"
csv.file <- "household_power_consumption.txt"
png.file <- "plot1.png"
data.dir <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Check for CSV file if not found then download ZIP and unzip
if (!file.exists(file.path(data.dir, csv.file))) {
        download.file(fileurl,
                      destfile = file.path(data.dir, zip.file),
                      method = "wininet",
                      mode="wb")
        dateDownloaded <- date()
        unzip(file.path(data.dir, zip.file), exdir=".")
}

colClasses = c("chr","chr","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

## read file into table

housepw <- read.table(file=csv.file,header=TRUE,sep=";",stringsAsFactors = FALSE)


## set time range of data we want to use
date.start <- "2/1/2007"
date.end <- "2/2/2007"
## Setup query for reducing data set
query <- paste0("Select * from housepw WHERE Date = '",date.start,"' or Date = '",date.end,"'")
## Reduce number of rows to only those in our range.
housepw2 <- sqldf(query)

## Free up memory by deleting old unneeded objects
rm(housepw)

## build the TIMESTAMP data in STRING format
datetime <- paste(housepw2[,1],' ',housepw2[,2])

## (dont need this ) housepw$TimeStamp <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

datetime <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

## Build new table with timestamps
TShousepw <- cbind(TimeStamp = datetime,housepw2[,3:9])

## delete old table from memory
rm(housepw2)

## Define what to make a histogram of...
this <- as.numeric(TShousepw[,2])

## Open PNG file for plotting
png(file="plot1.png")


## Create histogram to the screen, or in the PNG file if it is open.
hist(this,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")

## Close out the file
dev.off()

##End






