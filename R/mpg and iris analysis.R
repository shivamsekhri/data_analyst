#installing ggplot2 and sqldf
install.packages("ggplot2")
library(ggplot2)# package for creating visualizations
library(sqldf) # package to write SQL queries in R

# data already provided in R Studio
#manually checking data
mpg

# 1
# comparing the fuel efficiency for all manufacturers on highway(hwy)
# Grouping data by manufacturer and taking average for highway mileage
p=sqldf("select manufacturer,  round(avg(hwy),1) as mileage_hwy from mpg group by manufacturer order by cty")
p=data.frame(p)
p
ggplot(data=p, aes(x=manufacturer, y=mileage_hwy, fill =manufacturer))+ 
  geom_bar(stat = "identity") + xlab("Manufacturers") + ylab("Average_Highway_Mileage") + 
  ggtitle(label = "Bar Chart", subtitle = "mtcars data in R")+ theme(axis.text.x = element_text(angle = 45, hjust = 1))



#2
# Analysing the impact of a bigger engine area on highway mileage
A=sqldf("select manufacturer, displ as Engine_Displacement_Area,round(avg(hwy),1) as mileage_hwy from mpg group by manufacturer order by hwy")
A=data.frame(A)
ggplot(data = A, aes(x =mileage_hwy ,y = Engine_Displacement_Area))  + geom_point(size = 2.5) + geom_line()+ 
  labs(title = "Engine Area vs Highway Mileage") + xlab("Highway Mileage") + ylab("Engine Area")+ 
  theme(plot.title = element_text(color = "forest green",size = 17),plot.background = element_rect("yellow")) 



# 3
##Customized Bar Plot
#Creating Stacked Bar Chart to analyse 
mpg
C=sqldf("select avg(displ) as Engine_Displacement_Area, class as Car_type, drv as Drive_Type from mpg group by class, drv")
C <-ggplot(data=C, aes(x=Car_type, y=Engine_Displacement_Area, fill=Drive_Type))
C + geom_bar(stat = "identity") +xlab("Car Type") + ylab("Average Engine Area")



#4
# Analysing iris dataset provided in R Studio
# comparing the sepal and petal length for different flowers accoring to thier spices
# we can see that species Setosa has the most width but the least length on average
iris
ggplot(iris,aes(x = Sepal.Length,y = Sepal.Width,color =Species)) + geom_point() + ggtitle(label = "Scatter
plot")+ labs(title = "Setosa vs Versicolor vs Virginica") + xlab("Sepal Length") + ylab("Sepal Width")+ 
  theme(plot.title = element_text(color = "brown",size = 17),plot.background = element_rect("green"))

# Box Plot comparing the Petal Length distribution within the three species
iris$Species = factor(iris$Species)
ggplot(iris, aes(x=Species, y=Petal.Length)) + geom_boxplot()+ labs(title = "Petal Length Distribution for all Species") + xlab("Species") + ylab("Petal Length")+ 
  theme(plot.title = element_text(color = "blue",size = 17),plot.background = element_rect("pink"))

