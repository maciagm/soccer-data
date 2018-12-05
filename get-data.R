library(DBI)
library(RSQLite)
library(dplyr)

soccer_con <- dbConnect(RSQLite::SQLite(), dbname = "soccer.sqlite")
dbListTables(soccer_con)
dbGetQuery(soccer_con, "select * from Country")
dbGetQuery(soccer_con, "select * from League limit 5")
season_dat <- dbGetQuery(soccer_con, "select * from Match where league_id is 1729") %>% 
  filter(season %in% c("2014/2015", "2015/2016")) %>% 
  select(season, stage, date, home_team_api_id, away_team_api_id, home_team_goal, away_team_goal)

teams <- dbGetQuery(soccer_con, "select team_api_id, team_long_name from Team")

PL_dat <- inner_join(season_dat, teams, by = c("home_team_api_id" = "team_api_id")) %>% 
  rename(home_team = team_long_name) %>% 
  inner_join(teams, by = c("away_team_api_id" = "team_api_id")) %>% 
  rename(away_team = team_long_name) %>% 
  select(-home_team_api_id, -away_team_api_id)

write.csv2(PL_dat, file = "PL_dat.csv", row.names = FALSE)
