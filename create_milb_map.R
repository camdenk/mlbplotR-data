library(tidyverse)
library(baseballr)
library(mlbplotR)


teams <- load_mlb_teams() |>
  filter(!is.na(team_id_num))

milb_teams <- map(teams$team_id_num, \(x) mlb_team_affiliates(x, season = 2024)) |>
  bind_rows()


# milb_teams |> View()


team_map <- milb_teams |>
  filter(sport_name %in% c("Major League Baseball", "Triple-A", "Double-A", "High-A", "Single-A", "Rookie")) |>
  select(team_full_name, team_location = short_name, team_mascot = club_name, team_abbr = team_abbreviation, team_code, team_id_num = team_id, level = sport_name, league_name,
         parent_org_name, parent_org_id) |>
  select(team_name = team_full_name, everything()) |>
  mutate(team_location = case_when(team_name == "Northwest Arkansas Naturals" ~ "Northwest Arkansas",
                                   team_name == "Scranton/Wilkes-Barre RailRiders" ~ "Scranton/Wilkes-Barre",
                                   TRUE ~ team_location),
         level = case_when(level == "Major League Baseball" ~ "MLB",
                           level == "Triple-A" ~ "AAA",
                           level == "Double-A" ~ "AA",
                           level == "High-A" ~ "A+",
                           level == "Single-A" ~ "A",
                           level == "Rookie" ~ "Rookie"),
         parent_org_name = if_else(is.na(parent_org_name), team_name, parent_org_name),
         parent_org_id = if_else(is.na(parent_org_id), team_id_num, parent_org_id),
         team_logo = paste0("https://www.mlbstatic.com/team-logos/", team_id_num, ".svg"),
         team_cap_logo_on_light = paste0("https://www.mlbstatic.com/team-logos/team-cap-on-light/", team_id_num, ".svg"),
         team_dot_logo = paste0("https://midfield.mlbstatic.com/v1/team/", team_id_num, "/spots/500")
  ) |>
  arrange(parent_org_name, desc(level))


team_map |> write_csv("milb_map.csv")
