

#?why do i use dplyr
#Great for data exploration and transformation
#Intuitive to write and easy to read, especially when using the "chaining"
#syntax(covered below)
#fast on data frames


##dplyr functionality
#five basic verbs :filter, select, arrange, mutate, summarise(plus group_by)
#can work with data stored in databasess and datatables
#joins:inner join , left join, semi_join ,anti join ,(not covered below)
#window functions for calculation ranking, offsets, and more
#Better than plyr if you are only working with dataframes (though it does not duplicate)


#To install dplyr
install.packages("dplyr")
installed.packages()
library(dplyr)
install.packages("magrittr")
library(magrittr)


#Data:mammals sleep
install.packages("downloader")
library(downloader)

msleep <- read.csv("https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv")
head(msleep)



#important dplyr verbs to remember

#dplyr verbs description
#select()  select columns 
#filter() filter rows
#arrange() re-order or arrange rows
#mutate() create new columns
#summarise() summarise values
#group_by()allows for group operations in the "split-apply-combine"concept

#The two most basic functions are select() and filter() which selects column and filter respectively

#select a set of column:the name and the sleep_total columns.
msleep
sleepData <- select(msleep, name, sleep_total)
head(sleepData)

#To select all columns except a specific column, use the"-"
#(subtraction) operator  (also known  as negative indexing)

head(select(msleep, -name,-genus))

#To select all the columns except a specific  column, use the "-" (colon) operator

head(select(msleep, name:sleep_cycle))

#To select all columns that starts with the character string  "sl", use the function start

head(select(msleep, starts_with("sl")))
head(msleep, 15)

#some additional options to select columns based on a specific criteria include

#ends_with() =select columns that end with a character string
#contains() = select columns that contain a character string
#matches() = select columns that match a regular expression
#one_of() = select columns names that are from a group of names

#selecting rows using filter()

#Filter the rows for mammals that sleep a total of more than 16 hours.

filter(msleep, sleep_total >=16)

#filter the rows for mammals that sleep a total of more than 16 hours and have a 
#body weight of greater than 1 kilogram.

filter(msleep, sleep_total >=16, bodywt >=1)

#Filter the rows for mammals in the perissodactyla and primates taxonomic order

filter(msleep, order %in% c("Perissodactyla", "Primates"))

#you can the use the boolean operators (e.g. >,<,>=,<=, !=, %in%) to create the logical
#%in% operator is used for preeciding the value or logic .

#Pipe operator : %>%
#Before we go any further , let's introduce the pipe operator: %>%
#dplyr imports this operator from another package(magritter).
#This operator allows you to pipe the output from one function to other
#The input of another function,Instead of nesting function.
#(reading from the inside to the outside),the idea of piping is to
#read the function from left to right.

head(select(msleep, name, sleep_total))


#Now in this case, we will pipe the msleep data frame to the function.
#that will select two columns (name and sleep_total) and then pipe the
#new data frame to the function head() which will return the head of the  new data frame


msleep %>%
   select(name, sleep_total)%>%
   head
   
   
   
#Arrange or reorder rows using arrange()

#To arrange (or re-order) rows by a particular column such as taxonomic order,
#list the name of the column you want to arrange the rows by


msleep %>% arrange(order)%>% select(name, order,sleep_total)%>% head(10)

#Now , we will select three columns from sleep, arrange the rows
#by the taxonomic order and then arrange the rows by sleep_total.
#Finally show the head of the final data frame


msleep %>%
  select(name,order, sleep_total)%>%
  arrange(order, sleep_total)%>%
  head
  
  
#same as above , except here we filter the rows for mammals that sleep 16 or more hours
#instead of showing the head of the final data frame


msleep %>%
  select(name, order, sleep_total)%>%
  arrange(order , sleep_total)%>%
  filter(sleep_total >=16)
  
  
#Something slightly more complicated: same as above,except arrange the rows in
#the sleep_total column in a descending order. For this, function desc()


msleep %>% 
  select(name, order, sleep_total) %>%
  arrange(order, desc(sleep_total)) %>% 
  filter(sleep_total >= 16)
  
  
#create new columns using mutate()
#the  mutate() function will add new columns to the data frame.
#create a new column called rem_properties which is the ratio of rem sleep to total animals.

msleep %>%
  mutate(rem_properties = sleep_rem/sleep_total)%>%
  head
  
#you can  many new columns using mutate (seperated by commas.)
#Here we add a second column called bodywt_grams which is the bodywt column in grams.

msleep %>% 
  mutate(rem_proportion = sleep_rem / sleep_total, 
         bodywt_grams = bodywt * 1000) %>%
  head
   
msleep_updated = msleep%>%
  mutate(rem_proportion = sleep_rem / sleep_total, 
         bodywt_grams = bodywt * 1000)

#create summaries of the data frame using summarise()
#The summarise()function will create summary statistics for a given column in the 
##data frame such as finding the meaan, for example, to compute the average number
##of hours of sleep , apply the mean() function to the column sleep_total and call
#of hours sleep , apply the mean() apply the function to the column sleep_total and call
# the summary  value  avg_sleep.

msleep %>%
    summarise(avg_sleep = mean(sleep_total))
  

#There are many other summary statistics you could consider such sd(),
#min(), max(), median(), sum(), n() (returns the length of vector,) first()
#(returns first value in the vector,), last() (returns the length value in vector)
#and n_district() (number of distinct values in vector).

msleep %>% 
  summarise(avg_sleep = mean(sleep_total), 
            min_sleep = min(sleep_total),
            max_sleep = max(sleep_total),
            sum_sleep = sum(sleep_total),
            median_sleep = median(sleep_total),
            sd_sleep = sd(sleep_total),
            total = n())


##Group operations using group_by()


#The group_by verb  is an important function in dplyr.
#As we mentioned before its related to concept of "split-apply-combine".
#we literally want to split the dataframe by some variable (e.g.taxonomic order),
#apply a funtion to the individual data frames and then combine the output.

#Lets do that:split the msleep data frame by the taxonomic order,
#then ask for the same summary statistics as above.we accept a set of summary
#statistics for each taxonoic order.

msleep %>%
  group_by(order)%>%
  summarise(avg_sleep = mean(sleep_total),
            min_sleep = min(sleep_total),
            max_sleep = max(sleep_total),
            sum_sleep = sum(sleep_total),
            median_sleep = median(sleep_total),
            sd_sleep = sd(sleep_total),            
            total =n())


#msleep1 <- read.csv("https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv")

#msleep1[is.na(msleep1)]=0


