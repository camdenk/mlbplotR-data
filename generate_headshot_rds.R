
headshots <- readr::read_csv("./Player-IDs.csv") |>
  tibble::as_tibble()

saveRDS(headshots, "./Player-IDs.rds")

