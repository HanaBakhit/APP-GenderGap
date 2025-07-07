# GRAPH 

library(tidyverse)
library(dplyr)
library(sf) # the primary spatial package for today
library(tigris) # to call Census boundary files
library(RColorBrewer)
library(scales)
library(readxl)
library(showtext)


# CodeVA colors
codeva_darkblue <- "#0A2945"
codeva_lightblue <- "#7FC6E6"
codeva_orange <- "#F58220"
codeva_green <- "#7CB342"

#font
font_add(family = "Times New Roman", regular = "Times New Roman.ttf")
showtext_auto()

district_data <- read_excel("~/Library/Mobile Documents/com~apple~CloudDocs/MPP/Spring semester 2025/APP_2025/Data Analysis/districts_data2.xlsx")
 
#...................
#data analysis 

district_data %>%
  filter(Year == "2023-2024") %>%
  arrange(desc(pct_female)) %>%
  select(Division, pct_female) %>%
  slice(c(1, n()))


Petersburg City Public Schools

district_data %>%
  filter(Year == "2023-2024", number_enrolled >= 100) %>%
  arrange(desc(pct_female)) %>%
  select(Division, number_enrolled, female, pct_female) %>%
  slice_head(n = 10)

district_data %>%
  filter(Year == "2023-2024", number_enrolled >= 100) %>%
  arrange(pct_female) %>%
  select(Division, number_enrolled, female, pct_female) %>%
  slice_head(n = 5)

plot_data <- district_data %>%
  filter(Year == "2023-2024", number_enrolled >= 100) %>%
  arrange(pct_female) %>%
  slice(c(1:5, (n() - 4):n())) %>%
  mutate(group = if_else(row_number() <= 5, "Lowest", "Highest"))

#Plot1: percentage of states offering CS 

state_data <- read_excel("~/Library/Mobile Documents/com~apple~CloudDocs/MPP/Spring semester 2025/APP_2025/Data Analysis/Percentage of High Schools Offering Foundational CS by State (2023).xlsx")

state_data <- state_data %>%
  mutate(
    bar_color = if_else(State == "Virginia", "#F58220", "#7FC6E6"),
    State = fct_reorder(State, `% Schools Offering CS`)  # 🔥 tightly packs bars
  )


ggplot(
  state_data %>%
    mutate(bar_color = if_else(State == "Virginia", "#F58220", "#0A2945"))  # Orange for VA, light blue for others
) +
  geom_col(aes(x = reorder(State, `% Schools Offering CS`), 
               y = `% Schools Offering CS`, fill = bar_color), width = 0.7) +
  geom_text(aes(x = State, y = `% Schools Offering CS`, 
                label = scales::percent(`% Schools Offering CS`, accuracy = 1)),
            vjust = -0.5, size = 3.5, color = "#0A2945", family = "Times New Roman", fontface = "bold") +
  scale_fill_identity() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0, 1.1)) +
  labs(
    title = "Share of Schools Offering CS by State",
    subtitle = "Virginia highlighted for comparison",
    x = NULL,
    y = "% of Schools Offering CS"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold", color = "#0A2945"),
    plot.subtitle = element_text(hjust = 0.5, color = "#0A2945"),
    axis.text.x = element_text(color = "#0A2945", face = "bold"),
    axis.text.y = element_text(color = "#0A2945"),
    axis.title = element_text(color = "#0A2945"),
    panel.grid.minor = element_blank()
  )                          



# Plot2: Linegraph traditonal CS Enrollment by Gender

school_data2 <- read_excel("~/Library/Mobile Documents/com~apple~CloudDocs/MPP/Spring semester 2025/APP_2025/Data Analysis/school_data2.xlsx")

gender_trend$Year <- as.character(gender_trend$Year)

gender_trend <- school_data2 %>%
  group_by(Year) %>%
  summarise(
    Female = sum(female, na.rm = TRUE),
    Male = sum(male, na.rm = TRUE),
    Total = sum(number_enrolled, na.rm = TRUE)
  )

    
gender_trend_long <- gender_trend %>%
  pivot_longer(cols = c(Female, Male, Total),
               names_to = "Group",
               values_to = "Enrollment")
#Linegraph
ggplot(gender_trend_long, aes(x = Year, y = Enrollment, color = Group, group = Group)) +
  geom_line(size = 1.5) +
  geom_point(size = 2) +
  scale_color_manual(values = c(
    "Female" = codeva_green,
    "Male" = codeva_orange,
    "Total" = codeva_darkblue
  )) +
  labs(
    title = "Traditional CS Enrollment by Gender",
    x = NULL,
    y = "Enrollment Count",
    color = NULL
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", color = codeva_darkblue),
    axis.text = element_text(color = codeva_darkblue),
    axis.title = element_text(color = codeva_darkblue),
    legend.position = "bottom",
    legend.text = element_text(color = codeva_darkblue)
  )

#.....................................
#Plot3: race trends 

race_trend <- school_data2 %>%
  group_by(Year) %>%
  summarise(
    White = sum(white, na.rm = TRUE),
    Asian = sum(asian, na.rm = TRUE),
    Black = sum(black, na.rm = TRUE),
    Hispanic = sum(hispanic, na.rm = TRUE)
  )

#pivot to long

race_trend_long <- race_trend %>%
  pivot_longer(cols = c(White, Asian, Black, Hispanic),
               names_to = "Race",
               values_to = "Enrollment")
  


ggplot(race_trend_long, aes(x = Year, y = Enrollment, fill = Race)) +
  geom_col(position = "dodge", width = 0.7) +
  scale_fill_manual(values = c(
    "White" = "#174A73",     # dark blue
    "Asian" = "#F58220",     # orange
    "Black" = "#2E7D32",     # green
    "Hispanic" = "#29B6F6"   # light blue
  )) +
  labs(
    title = "Traditional CS Enrollment by Race",
    x = NULL,
    y = "Enrollment Count",
    fill = NULL
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", color = "#0A2945"),
    axis.text = element_text(color = "#0A2945"),
    axis.title = element_text(color = "#0A2945"),
    legend.text = element_text(color = "#0A2945"),
    legend.position = "bottom"
  )


plot_data <- district_data %>%
  filter(Year == "2023-2024", number_enrolled >= 100, Division != "Maggie L. Walker Governor's School") %>%
  arrange(pct_female) %>%
  slice(c(1:5, (n() - 4):n())) %>%
  mutate(group = if_else(row_number() <= 5, "Lowest", "Highest"))


# Plot: Districts with highest and lowest % of female CS students 
ggplot(plot_data, aes(x = reorder(Division, pct_female), y = pct_female, fill = group)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(round(pct_female, 1), "%")), 
            hjust = -0.1, size = 3.5, color = "#0A2945", fontface = "bold") +
  coord_flip(clip = "off") +
  scale_fill_manual(values = c("Highest" = "#F58220", "Lowest" = "#0A2945")) +  # CodeVA orange & light blue
  labs(
    title = "Districts with Highest and Lowest % of Female CS Students (2023–2024)",
    subtitle = "Among districts with at least 100 students enrolled",
    x = NULL,
    y = "% Female in CS",
    fill = NULL
  ) +
  ylim(0, max(plot_data$pct_female, na.rm = TRUE) + 5) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", color = "#0A2945"),
    plot.subtitle = element_text(hjust = 0.5, color = "#0A2945"),
    axis.text.y = element_text(size = 9, face = "bold", color = "#0A2945"),
    axis.text.x = element_text(color = "#0A2945"),
    panel.grid.major.y = element_blank(),
    legend.position = "bottom"
  )



#................
                           
#heat map of divisons 


division <- st_read("~/Library/Mobile Documents/com~apple~CloudDocs/MPP/Spring semester 2025/APP_2025/School_District_Boundaries_-_Current")
#filter for only Virginia 
division <- division %>%
  filter(STATEFP == "51")  # 51 = Virginia
#change var name to match 

division <- division %>%
  rename(Division = NAME)


# Join data (update "NAME" to match shapefile's district name column)
district_data <- division %>%
  full_join(district_data, by = "Division")

#Map graph 

ggplot(
  district_data %>%
    filter(Year == "2023-2024")
) +
  geom_sf(aes(fill = pct_female), color = "white", size = 0.1) +
  scale_fill_gradient(
    low = "#fee8c8", high = "#F58220",
    na.value = "gray90", name = "% Female"
  ) +
  labs(
    title = "Percent of Female Students in Traditional CS (2023–2024)",
    subtitle = "By Virginia School Division",
    caption = "Source: CodeVA and VDOE"
  ) +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", color = "#0A2945"),  # CodeVA dark blue
    plot.subtitle = element_text(hjust = 0.5, color = "#0A2945"),
    legend.title = element_text(color = "#0A2945"),
    legend.text = element_text(color = "#0A2945"),
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )




#...........................






