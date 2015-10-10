source_data_filename <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
tempfn1 <- tempfile()
download.file(source_data_filename, tempfn1, method="curl")
internalfns <- unzip(tempfn1, list=TRUE)
con <- unz(tempfn1, internalfns[[1]])
data <- read.delim(con, header=TRUE, sep=";", quote="\"", dec=".",
                   fill=FALSE, comment.char="", na.strings="?",
                   colClasses=c(rep("character", 2), rep("numeric", 7)),
                   stringsAsFactors=FALSE)
unlink(tempfn1)
# Example line:
#    Date;Time;Global_active_power;Global_reactive_power;Voltage;Global_intensity;Sub_metering_1;Sub_metering_2;Sub_metering_3
#    16/12/2006;17:24:00;4.216;0.418;234.840;18.400;0.000;1.000;17.000

# Type coerce Date and add a POSIXlt datetime
data <- transform(data,
                  datetime = as.POSIXlt(paste(Date, Time, sep=":"), format="%d/%m/%Y:%H:%M:%S"),
                  Date = as.Date(Date, format="%d/%m/%Y"))

# Subset down the data to 2007-02-01 and 2007-02-02 (YYYY-MM-DD) as requested in the
# course project instructions.  This could have been done earlier to speed things up,
# but I don't trust the file format to stay the same over time.
desired_dates <- c(as.Date("2007-02-01", format="%Y-%m-%d"),
                   as.Date("2007-02-02", format="%Y-%m-%d"))
data <- subset(data, (Date %in% desired_dates))

# Generate plot 2
png(filename="plot2.png", width=480, height=480, units="px")
plot(data$datetime, data$Global_active_power, type="l",
     xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
