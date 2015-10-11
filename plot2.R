## plot2.R - starting over from scratch 2015-10-10
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
## install.packages("lubridate")
library(lubridate)
path <- getwd()
histfilename <- paste0(path,"History","_",format(Sys.time(), "%Y-%m-%d_%H-%M-%S"),".R")
savehistory(histfilename)

zip.file <- "exdata-data-household_power_consumption.zip"
csv.file <- "household_power_consumption.txt"
png.file <- "plot2.png"
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

cols1 = c("Date","chr","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

## read file into table


housepw <- read.table(file=csv.file,header=TRUE,sep=";",stringsAsFactors = FALSE,na.strings="NA" )

good <- complete.cases(housepw)

housepw1 <- housepw[good,]

NewDate <- strptime(housepw1$Date,"%e/%m/%Y")
day <- as.character(wday(NewDate,label=TRUE))

housepw1$Day <- day


##housepw1a <-  cbind(Date = NewDate,housepw1[,3:9],stringsAsFactors = FALSE)

##housepw1a$Day <- as.character(wday(housepw1a$Date,label=TRUE))


## set time range of data we want to use
date.start <- strptime("2/1/2007","%e/%m/%Y")
date.end <- strptime("2/2/2007","%e/%m/%Y")
## Setup query for reducing data set
query <- paste0("Select * from housepw1a WHERE Day in ('Thu','Fri')")

## Reduce number of rows to only those in our range.
housepw2 <- sqldf(query,stringsAsFactors=FALSE)

## Free up memory by deleting old unneeded objects
rm(housepw)


## build the TIMESTAMP data in STRING format
## datetime <- paste(housepw2[,1],' ',housepw2[,2])

## (dont need this ) housepw$TimeStamp <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

## datetime <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

## only keep the DATE of each sample ... leave off the time
datetime <- strptime(housepw2[,1],"%d/%m/%Y")

## get the days of the week for each sample
dayofWeek <- as.character(wday(datetime,label=TRUE))

days.thufri <- dayofWeek==c("Thu","Fri")


## Build new table with timestamps
TShousepw <- cbind(TimeStamp = dayofWeek,housepw2[,3:9],stringsAsFactors = FALSE)

## delete old table from memory
rm(housepw2)

## Define what to make a histogram of...
x <- TShousepw[,1]
y <- as.numeric(TShousepw[,2])

## Open PNG file for plotting
png(file="plot1.png")


## Create histogram to the screen, or in the PNG file if it is open.
hist(this,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")

## Close out the file
dev.off()

##End






