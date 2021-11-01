## Downloaded exdata_data_household_power_consumption compressed zipped file
## and uncompressed to access the dataset named household_power_consumption.
## This dataset is saved to a working directory.
## Read from working directory that is set using setwd("directory filepath") 
## and confirmed using getwd().

local_data <- "household_power_consumption.txt"  
ld <- file(local_data) ## opens connection to raw data file
library(sqldf) ## loads sqldf package since we will be using SQL to clean data

## Uses SQL to read in select rows of data where the Data column is either 
## 01/02/2007 or 02/02/2007. Have to do this, since over 2 million rows of raw 
## data. Do this rather than reading in the entire dataset and subsetting to 
## those dates. Note the file.format argument for specifying a header and a 
## semi-colon separated file. The result is a data frame named df with data for 
## only specific dates. 

df <- sqldf("SELECT * FROM ld WHERE Date == '1/2/2007' OR Date == '2/2/2007'", 
            file.format = list(header = TRUE, sep = ";"))

close(ld)  ## closes connection to raw data file

table(df$Date)  ## confirms 1440 rows for each data value

names(df) ## confirmed 9 columns of data

## confirmed again 2880 observations and there is a data frame loaded into R. 
## Also both Date and Time variables are showing up as character class. They 
## need to be merged for plotting purposes.  

str(df) 
library(dplyr) ## load dplyr package
dft <- tbl_df(df)  ## converts df from a data frame to a data table
library(lubridate)  ## using lubridate package to merge Date and Time
dft$date_time <- with(dft, dmy(Date) + hms(Time))
## confirmed creation of date_time variable that combines date and time and is 
## in the class of POSIXct
str(dft)
names(dft) ## confirm again newly created variable of date_time
## opens png file device and specifies dimensions
png(file="plot4.png", width=480, height=480)
par(mfrow=c(2,2))  ## specifies plot layout of 2 x 2
## creates scatterplot, labels y-axis, type argument connects points
with(dft, plot(date_time, Global_active_power, type="l", 
               ylab="Global Active Power", xlab=""))
## another scatterplot, x and y axes labeled, points connected
with(dft, plot(date_time, Voltage, type="l", xlab="datetime", ylab="Voltage"))
## creates scatterplot, labels y-axis, type argument connects points
with(dft, plot(date_time, Sub_metering_1, type="l", xlab="", 
               ylab="Energy sub metering"))
## annotations that adds points to existing plot, points connected, 
## colored lines 
with(dft, points(date_time, Sub_metering_2, type="l", col="Red"))
with(dft, points(date_time, Sub_metering_3, type="l", col="Blue"))
## legend added in upper right-hand corner, lty adds lines for the symbol
## bty argument removes border on legend, legend argument adds
## description
legend("topright", lty=1, col=c("black", "red", "blue"), bty="n", 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## adds another scatterplot, type argument joints points, axes labeled
with(dft, plot(date_time, Global_reactive_power, type="l", xlab="datetime", 
               ylab="Global_reactive_power"))
dev.off( )  ## closes file device and saves png plot to working directory