
using("tinysnapshot")
library(ggplot2)


p <- ggplot(airquality, aes(Day, Wind, group = Month)) + 
  stat_interquartilerange(geom = "ribbon",
                          show.legend = FALSE) +
  geom_line() + 
  stat_sparklabels(geom = "label", label_fun = \(x) round(x, 0),
                   show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 25)) + 
  facet_grid(Month~.) +
  ggtitle("Daily wind intensity by month in NYC") + 
  theme_minimal()


expect_equal(p$layers[[1]]$aes_params$fill, "gray90")


expect_equal(p$layers[[3]]$stat$required_aes, c("x", "y"))
