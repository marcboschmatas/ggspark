library(ggplot2)

ggplot(airquality, aes(Day, Wind, group = Month)) + 
  stat_interquartilerange(geom = "ribbon",
                          show.legend = FALSE) +
  geom_line() + 
  scale_y_continuous(limits = c(0, 25)) + 
  facet_grid(Month~.) +
  ggtitle("Daily wind intensity by month in NYC") +
  theme_minimal()