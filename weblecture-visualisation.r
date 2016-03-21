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
require(readxl) # For reading XLS files.
require(stringr) # For easy string manipulation.
library(lubridate) # For finding date within range.
library(ggplot2) # For plotting.
require(scales) # For making plotting of different date ranges easier.

# First Plot: Line Plot showing total views per lecture per week.
## Loading and cleaning data
data <- read_excel("data/WSR-weblectures-nodiff.xlsx", sheet = "Viewing Sessions")

### Reducing variables to only neccessary ones.

data <- data[,c("Presentation Title","Username","Opened", "Last Active", "Time Watched (h:mm:ss)", "Coverage (h:mm:ss)")]

### Converting time/date veriables to date objects for later calculations
### Check origin date when importing. Can be different depending on software eg. EXCEL or CALC and OS!!
origin_time <- dmy_hms("30-12-1899 00:00:00")
data$Opened <- origin_time + ddays(data$Opened)
data$`Last Active` <- origin_time + ddays(data$`Last Active`)

### Creating variable with date of Video
#### extracting date pattern
date_of_lecture <- str_match(pattern = "[:digit:]{1,2}-[:digit:]{1,2}-[:digit:]{4}", string =data[,1])
#### Converting to date format
date_of_lecture <- dmy(date_of_lecture)
data <- cbind(date_of_lecture,data)

### Preparing the data for plotting in ggplot2

plotdf <- data.frame(date_of_lecture = date_of_lecture, date_opened = round_date(data[,"Opened"], "day"),username=data["Username"])
## Creating a table of frequencies and filtering out all zero occurences. 
plotdf <- as.data.frame(table(plotdf))
plotdf <- plotdf[plotdf["Freq"] != 0,]
## By making another frequency table of the remaining lectures and views, we get unique views per lecture. 
## If a student has watched a lecture twice on one day, this is counted as one view. 
plotdf <- as.data.frame(table(plotdf[c("date_of_lecture","date_opened")]))
plotdf$date_opened <- ymd(plotdf$date_opened)

### Plot of frequenties views of each lecture by date. 
base <- ggplot(plotdf, aes(date_opened,Freq)) + geom_line() + 
  scale_x_datetime(breaks=date_breaks("3 day"),minor_breaks = date_breaks("1 day")) +
  facet_grid(date_of_lecture ~ .) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), strip.text.y = element_text(size=6, angle= 0))
base
 
