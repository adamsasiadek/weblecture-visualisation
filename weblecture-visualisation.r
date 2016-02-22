#############################################################################################################################################################
# Author: Adam Sasiadek                                                                                                                                     #
# Description of the project: At the UvA students have to attend either to lectures, or in case the circumstances do not allow it, have to watch            #
# weblectures instead. Right now, we do not know a lot about the viewing behaviour of students and the impact of viewing weblectures on their grade.        #
# The hosting company of the web-lectures allows for a in-depth analysis of viewing time, log-ins and time of viewing and many other variables.             #
# To gain new insights about viewing behaviour we aim to make two plots: First, a line-plot of the total views of each web-lecture of one course per week.  #
# Second, a heat-map, showing wethereach individual student has watched a lecture in a given week.                                                          #
#                                                                                                                                                           #
#############################################################################################################################################################

# Empty memory
rm(list=ls())

# Libraries:
require(readxl) # for reading XLS files
require(stringr)
library("lubridate")  #install.packages("lubridate") # For finding date within range
library(ggplot2)
require(scales) # For making plotting of different date ranges easier

# First Plot: Line Plot showing total views per lecture per week.
## Loading and cleaning data
data <- read_excel("data/WSR-weblectures-nodiff.xlsx", sheet = 7)

### Reducing variables to only neccessary ones.

data <- data[,c(1,2,4:7)]

### Converting time/date veriables to chron objects for later calculations
### Check origin date when importing. Can be different depending on software eg. EXCEL or CALC and OS!!
origin_time <- dmy_hms("30-12-1899 00:00:00")
data$Opened <- origin_time + ddays(data$Opened)
data$`Last Active` <- origin_time + ddays(data$`Last Active`)

### Creating variable with date of Video
#### extracting date pattern
date_of_lecture <- str_match(pattern = "....[:digit:]-[:digit:][:digit:][:digit:][:digit:]", string =data[,1])
#### cleaning up white space
date_of_lecture <- str_trim(str_replace(date_of_lecture, pattern = "^-",replacement = ""))
#### Converting to date format
date_of_lecture <- dmy(date_of_lecture)
data <- cbind(date_of_lecture,data)

### Preparing the data for plotting in ggplot2

plotdf <- data.frame(date_of_lecture = date_of_lecture, date_opened = round_date(data[,4], "day"))
plotdf <- as.data.frame(table(plotdf))
plotdf$date_opened <- ymd(plotdf$date_opened)
#date_for_plotting <- min(testdf[,2]) + c(-5:(max(testdf[,2]) - min(testdf[,2])+5)) * days(1)

### Plot of frequenties views of each lecture by date. 
base <- ggplot(plotdf, aes(date_opened,Freq)) + geom_line() + scale_x_datetime(breaks=date_breaks("3 day"),minor_breaks = date_breaks("1 day")) + facet_grid(date_of_lecture ~ .) + theme(axis.text.x = element_text(angle = 90, hjust = 1), strip.text.y = element_text(size=6, angle= 0))
base
 
