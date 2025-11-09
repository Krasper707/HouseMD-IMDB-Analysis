install.packages("tidyverse")
install.packages("rvest") 


library(tidyverse)
library(rvest)

# Define the base URLs and the seasons we want to scrape
IMDB_BASE_URL <- "https://www.imdb.com"
SHOW_BASE_URL <- "https://www.imdb.com/title/tt0412142/episodes?season="
SEASONS_TO_SCRAPE <- 1:8 # Scrape seasons 1 through 8

# Create empty lists to store the results from all seasons as we loop
all_episodes_list <- list()
all_cast_list <- list()

message("Starting the scraping process for House M.D.")



for (season_num in SEASONS_TO_SCRAPE) {
  
  season_url <- paste0(SHOW_BASE_URL, season_num)
  message(paste0("\n--- Scraping Season ", season_num, " episode list from: ", season_url, " ---"))
  
  page <- read_html(season_url)
  
  titles <- page %>% html_nodes(".ipc-title__text") %>% html_text()
  ratings <- page %>% html_nodes(".ipc-rating-star--rating") %>% html_text()
  votes <- page %>% html_nodes(".ipc-rating-star--voteCount") %>% html_text()
  summaries <- page %>% html_nodes(".ipc-html-content-inner-div") %>% html_text()
  
  episode_links_raw <- page %>% 
    html_nodes(".ipc-title-link-wrapper") %>% 
    html_attr('href')
  
  episode_links_raw <- unique(na.omit(episode_links_raw))
  full_episode_links <- paste0(IMDB_BASE_URL, episode_links_raw)
  
  episode_titles <- titles[str_starts(titles, "S")] # Filter out the main series title
  num_episodes <- length(ratings)                   # The number of ratings is a reliable count of episodes
  
  season_episodes_tibble <- tibble(
    season = season_num, # Add the season number for future analysis
    title = episode_titles[1:num_episodes],
    rating = ratings[1:num_episodes],
    votes = votes[1:num_episodes],
    summary = summaries[1:num_episodes],
    link = full_episode_links[1:num_episodes]
  )
  
  all_episodes_list[[season_num]] <- season_episodes_tibble
  
  message(paste0("-> Found and processed ", num_episodes, " episodes for Season ", season_num, "."))
  
  Sys.sleep(1)
  
  

  message(paste0("--> Now scraping cast for each episode in Season ", season_num, "..."))
  
  season_cast_list <- list()
  
  for (i in 1:nrow(season_episodes_tibble)) {
    
    episode_url <- season_episodes_tibble$link[i]
    episode_title <- season_episodes_tibble$title[i]
    
    episode_page <- read_html(episode_url)
    
    cast_names <- episode_page %>%
      html_nodes("[data-testid='title-cast-item__actor']") %>%
      html_text()
    
    # Create a small tibble for this single episode's cast
    episode_cast_tibble <- tibble(
      season = season_num, # Add season number for context
      episode_title = episode_title,
      actor = cast_names
    )
    
    # Add this episode's cast tibble to the temporary season list
    season_cast_list[[i]] <- episode_cast_tibble
    
    Sys.sleep(1)
  }
  
  all_cast_list[[season_num]] <- bind_rows(season_cast_list)
  
  message(paste0("--> Finished scraping cast for Season ", season_num, ". Moving to next season."))
}



message("\n--- All scraping complete! Combining data into final data frames... ---")

house_md_episodes <- bind_rows(all_episodes_list)
house_md_cast <- bind_rows(all_cast_list)

dir.create("data", showWarnings = FALSE)

write_csv(house_md_episodes, "data/house_md_all_episodes_raw.csv")
write_csv(house_md_cast, "data/house_md_all_cast_raw.csv")

message("\nSUCCESS: All raw data has been saved to the 'data' folder.")
print("You should now have two files: 'house_md_all_episodes_raw.csv' and 'house_md_all_cast_raw.csv'")
