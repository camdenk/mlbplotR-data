
headshots <- readr::read_csv("https://github.com/camdenk/mlbplotR-data/raw/main/Player-IDs.csv")

saveRDS(headshots, "./Player-IDs.rds")

