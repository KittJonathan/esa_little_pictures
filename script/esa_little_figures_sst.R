## ESA Climate data visualisation competition
## Last update 2023-09-13

## Load packages ----

library(tidyverse)

## Read the datasets ----

sst_m <- read_csv("https://raw.githubusercontent.com/littlepictures/datasets/main/sst/monthly_global_sst_mean.csv")
sst_y <- read_csv("https://raw.githubusercontent.com/littlepictures/datasets/main/sst/yearly_global_sst_mean.csv")

# Clean the data ----

sst <- sst_m |> 
  rename(sst = `Sea Surface Temperature`) |>
  separate(col = month,
           into = c("month", "year")) |> 
  summarise(sst_min = min(sst),
            sst_max = max(sst),
            .by = year) |> 
  mutate(year = as.numeric(year)) |> 
  left_join(sst_y) |> 
  rename(sst_mean = `Sea Surface Temperature`)

## Create plot ---

p <- ggplot(data = sst) +
  geom_ribbon(aes(x = year, ymin = 13.05, ymax = sst_max),
              fill = "#cfdaee") +
  geom_ribbon(aes(x = year, ymin = 13.05, ymax = sst_min),
              fill = "#0d2039") +
  geom_line(aes(x = year, y = sst_mean),
            colour = "#6d9ec7", linewidth = 2) +
  # ylim(13, 14.3) +
  theme_void() +
  theme(panel.background = element_rect(fill = "#0d2039"))

## Export plot ----

ggsave("figs/esa_little_pictures_sst.png", p, dpi = 320, width = 12, height = 6)
 