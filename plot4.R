## plot3.R - starting over from scratch 2015-10-10
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
png.file <- "plot4.png"
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

# Find the Good rows
good <- complete.cases(housepw)

## Remove incomplete rows
housepw1 <- housepw[good,]

## Free up memory by deleting old unneeded objects
rm(housepw)

## build the TIMESTAMP data in STRING format
datetime <- paste(housepw1$Date,' ',housepw1$Time)

datetime <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

## Set up the Day and DayChr columns in the table.
housepw1$Day <- wday(datetime,label=TRUE)
housepw1$DayChr <- as.character(wday(datetime,label=TRUE))


## set time range of data we want to use
date.start <- "1/2/2007"
date.end <- "2/2/2007"

## Setup query for reducing data set
query <- paste0("Select * from housepw1 WHERE DayChr in ('Thurs','Fri') and Date in ('1/2/2007','2/2/2007')")


## Reduce number of rows to only those in our range.
housepw2 <- sqldf(query,stringsAsFactors=FALSE)


## Free up memory by deleting old unneeded objects
rm(housepw1)


## build the TIMESTAMP data in STRING format
datetime <- paste(housepw2[,1],' ',housepw2[,2])

datetime2 <- strptime(datetime,"%d/%m/%Y %H:%M:%S")

housepw2$DateTime <- datetime2


## Define what to make a histogram of...
x <- housepw2$DateTime
y <- as.numeric(housepw2$Global_active_power)

## Open PNG file for plotting
png(file=png.file)


## Setup for 2 by 2 graphs
par(mfrow=c(2,2),mar=c(4,4,2,1),oma=c(0,0,2,0))

Voltage <- as.numeric(housepw2$Voltage)
Global_reactive_power <- as.numeric(housepw2$Global_reactive_power)

## Create Line Chart to the screen, or in the PNG file if it is open.
with(housepw2, {
        ## Create Line Chart to the screen, or in the PNG file if it is open.
        plot(DateTime,as.numeric(Global_active_power),type="l",ann=FALSE)
        title(ylab="Global Active Power")
        
        plot(DateTime,Voltage,type="l")
        
        
        
        plot(DateTime,as.numeric(Sub_metering_1),type="l",ann=FALSE)
        points(DateTime,as.numeric(Sub_metering_2),type="l",col="red")
        points(DateTime,as.numeric(Sub_metering_3),type="l",col="blue")
        legend("topright",pch=150,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")
        title(ylab="Energy sub metering")

        plot(DateTime,Global_reactive_power,type="l")
        
  
})

## Close out the file
dev.off()

##End

## Cleanup 
rm(housepw2)
sqldf()





