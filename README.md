# House M.D. - IMDb Data Analysis

<img width="315" height="160" alt="image" align='center' src="https://github.com/user-attachments/assets/fd38ae00-3bed-4975-85b4-7a64c1022960" />

This project is an end-to-end data analysis of the TV show *House M.D.* using R. It scrapes episode and cast data from IMDb, cleans and processes the raw data, and creates a series of visualizations to uncover trends in audience ratings over the show's 8-season run.

---

## Key Findings & Visualizations

Here are some of the main insights from the analysis:

### 1. The show's popularity peaked in Season 4 and then steadily declined.
*This chart shows the average IMDb rating for each season, clearly illustrating the rise, peak, and fall of the series in the eyes of the viewers.*

<img width="933" height="604" alt="Screenshot 2025-11-09 212637" src="https://github.com/user-attachments/assets/0a6a496d-d3a8-4ccf-9dff-b28bce152b8f" />

### 2. "House's Head" is the highest-rated episode of the series.
*The best-rated episodes are almost all season finales or major character arcs. The lowest-rated episodes are concentrated in the later seasons, confirming the trend of viewer fatigue.*

<img width="1013" height="616" alt="Screenshot 2025-11-09 212653" src="https://github.com/user-attachments/assets/efeebf0c-b0b3-4262-a86a-5031384c0269" />


### 3. The overall series trendline confirms the "rise and fall" narrative.
*Plotting every single episode's rating shows high consistency in the middle seasons and more volatility towards the end of the show's run.*

<img width="901" height="607" alt="Screenshot 2025-11-09 212704" src="https://github.com/user-attachments/assets/0285783b-6742-4278-a886-53b045c22637" />


---

## How to Run This Project

This project was built using R and RStudio.

1.  **Prerequisites:** You need to have R and RStudio installed.
2.  **Clone the repository:** `git clone https://github.com/Krasper707/HouseMD-IMDB-Analysis.git`
3.  **Install packages:** Open the `.Rproj` file in RStudio. The following packages are required. You can install them by running this command in the console:
    ```r
    install.packages(c("tidyverse", "rvest"))
    ```
4.  **Run the scripts in order:**
    *   `01_scrape_all_seasons.R`: This script will scrape all the raw data from IMDb. **(Note: This will take several minutes to run)**.
    *   `02_clean_and_process_data.R`: This cleans the raw data and creates the analysis-ready files.
    *   `03_analysis_and_visualization.Rmd`: Open this file and click "Knit" to generate the final HTML report with all plots.

---

## Data

The final, cleaned datasets are available in the `/data` directory:
*   `house_md_episodes_clean.csv`: Contains data on all 177 episodes (season, episode number, title, rating, votes).
*   `house_md_cast_clean.csv`: Contains a record for each actor in each episode.
