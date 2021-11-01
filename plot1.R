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
png(file="plot1.png", width=480, height=480)  
## creates histogram, colored red, labels x-axis and specifies main title
with(dft, hist(Global_active_power, col="Red", 
                xlab="Global Active Power (kilowatts)", 
                main="Global Active Power"))
dev.off( )  ## closes file device and saves png plot to working directory