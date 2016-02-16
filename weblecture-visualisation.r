#############################################################################################################################################################
# Author: Adam Sasiadek                                                                                                                                     #
# Description of the project: At the UvA students have to attend either to lectures, or in case the circumstances do not allow it, have to watch            #
# weblectures instead. Right now, we do not know a lot about the viewing behaviour of students and the impact of viewing weblectures on their grade.        #
# The hosting company of the web-lectures allows for a in-depth analysis of viewing time, log-ins and time of viewing and many other variables.             #
# To gain new insights about viewing behaviour we aim to make two plots: First, a line-plot of the total views of each web-lecture of one course per week.  #
# Second, a heat-map, showing wethereach individual student has watched a lecture in a given week.                                                          #
#                                                                                                                                                           #
#############################################################################################################################################################

# Libraries:
require(readxl) # for reading XLS files
require(chron)
require(stringr)
#library("lubridate")  #install.packages("lubridate") # For finding date within range

# First Plot: Line Plot showing total views per lecture per week.
## Loading and cleaning data
data <- read_excel("data/WSR-weblectures-nodiff.xlsx", sheet = 7)

### Reducing variables to only neccessary ones.

data <- data[,c(1,2,4:7)]

### Converting time/date veriables to chron objects for later calculations
### Check origin when importing. Can be different depending on software eg. EXCEL or CALC and OS!!

data$Opened <- chron(data$Opened,format = c("d-m-yy", "h:m:s"), origin = c(month = 12, day = 30, year = 1899))
data$`Last Active` <- chron(data$`Last Active`,format = c("d-m-y", "h:m:s"), origin = c(month = 12, day = 30, year = 1899))

is(data$`Time Watched (h:mm:ss)`)
### Creating variable with date of Video
date_of_lecture <- sapply(data[,1], function(x) strsplit(x,split = "- ")[[1]][4])
cbind(data,test)
