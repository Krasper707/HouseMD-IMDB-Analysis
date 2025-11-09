
library(tidyverse)
library(lubridate) 
raw_episodes <- read_csv("data/house_md_all_episodes_raw.csv")
raw_cast <- read_csv("data/house_md_all_cast_raw.csv")



message("Cleaning the episodes data...")

episodes_clean <- raw_episodes %>%
  # --- Column Type Conversion and Cleaning ---
  
  mutate(rating = as.numeric(rating),
         
         # b) Clean 'votes'. Remove parentheses, 'K' for thousands, and convert to number.
         votes = str_replace(votes, "\\(", ""), # Remove opening parenthesis
         votes = str_replace(votes, "\\)", ""), # Remove closing parenthesis
         votes_numeric = parse_number(votes), # Extracts the number (e.g., 7.9)
         votes = if_else(str_detect(votes, "K"), # If 'K' is present...
                         votes_numeric * 1000,   # ...multiply by 1000
                         votes_numeric),         # ...otherwise, use the number as is

         title_full = title, # Keep the original for reference
         episode_num_full = str_extract(title, "S[0-9]+\\.E[0-9]+"),
         title = str_remove(title, "S[0-9]+\\.E[0-9]+ âˆ™ "), # Remove the episode part and the bad symbol
         title = str_trim(title), # Remove any leading/trailing whitespace
         
         episode_num = parse_number(str_extract(episode_num_full, "E[0-9]+"))
         
  ) %>%
  
  select(
    season,
    episode_num,
    title,
    rating,
    votes,
    link,
    summary 
  )

message("Finished cleaning episodes data.")
message("Cleaning the cast data...")

cast_clean <- raw_cast %>%
  mutate(
    episode_num_full = str_extract(episode_title, "S[0-9]+\\.E[0-9]+"),
    episode_title_text = str_remove(episode_title, "S[0-9]+\\.E[0-9]+ âˆ™ "),
    episode_title_text = str_trim(episode_title_text)
  ) %>%
  select(
    season,
    episode_num_full,
    episode_title = episode_title_text, # Rename for clarity
    actor
  )

message("Finished cleaning cast data.")


write_csv(episodes_clean, "data/house_md_episodes_clean.csv")
write_csv(cast_clean, "data/house_md_cast_clean.csv")

message("Successfully saved clean data files.")

# DIAGNOSTIC VIEW 
View(episodes_clean)
View(cast_clean)