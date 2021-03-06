library(dplyr)
library(ggplot2)
library(eurostat)

lp <- get_eurostat_geospatial(output_class = "df", resolution = "60", nuts_level = "all")

s1 <- search_eurostat("employment", type = "table")

t1 <- get_eurostat(s1[2, "code"])

names_df <- filter(lp, CNTR_CODE == "FR", LEVL_CODE == 2, long > -30, long < 8.5, lat > 20) %>%
  group_by(NUTS_NAME) %>% 
  summarise(long = mean(long),
            lat = mean(lat))

left_join(lp, t1, by = c("geo" = "geo")) %>% 
  filter(CNTR_CODE == "FR", long > -30, long < 8.5, lat > 20, time == '2007-01-01' | time == '2017-01-01') %>% 
  na.omit %>% 
  ggplot(aes(x = long, y = lat, group = group, fill = values)) + 
  geom_polygon(color = "black") +
  geom_text(data = names_df, aes(x = long, y = lat, label = NUTS_NAME), inherit.aes = FALSE) +
  facet_wrap(~time) +
  ggtitle("Unemployment in France") +
  coord_map()
