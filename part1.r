## ----deliverable1-a, message=FALSE--------------------------------------------
library(tidyverse)
basketball <- read.csv("basketball_teams.csv")


## -----------------------------------------------------------------------------
nrow(basketball)


## -----------------------------------------------------------------------------
ncol(basketball)


## -----------------------------------------------------------------------------
colnames(basketball)


## -----------------------------------------------------------------------------

colnames(basketball)[colnames(basketball)=="lgID"] <- "league"
colnames(basketball)[colnames(basketball)=="tmID"] <- "team_abbrev"
colnames(basketball)[colnames(basketball)=="franchID"] <- "franchise_abbrev"
colnames(basketball)[colnames(basketball)=="confID"] <- "conference"
colnames(basketball)[colnames(basketball)=="divID"] <- "division"
colnames(basketball)[colnames(basketball)=="rank"] <- "division_rank"
colnames(basketball)[colnames(basketball)=="confRank"] <- "conference_rank"
colnames(basketball)[colnames(basketball)=="playoff"] <- "playoff_finish"
colnames(basketball)[colnames(basketball)=="name"] <- "team_name"


## -----------------------------------------------------------------------------
ranking <- tibble(year=basketball$year,team_abbrev=basketball$team_abbrev,
                  team_name=basketball$team_name,league=basketball$league,
                  division=basketball$division,division_rank=basketball$division_rank,
                  conference=basketball$conference,conference_rank=basketball$conference_rank,
                  playoff_finish=basketball$playoff_finish)


## -----------------------------------------------------------------------------
statistics <- tibble(year=basketball$year,team_abbrev=basketball$team_abbrev,
                     made_field_goal=basketball$o_fgm,attempt_field_goal=basketball$o_fga,
                     made_free_throw=basketball$o_ftm,attempt_free_throw=basketball$o_fta,
                     made_3_pointer=basketball$o_3pm,attempt_3_pointer=basketball$o_3pa,
                     rebounds=basketball$o_reb,assists=basketball$o_asts,
                     fouls=basketball$o_pf,points_scored=basketball$o_pts)


## -----------------------------------------------------------------------------
ranking$year <- as.factor(ranking$year)
statistics$year <- as.factor(statistics$year)
ranking$league <- as.factor(ranking$league)
ranking$division <- as.factor(ranking$division)
ranking$division_rank <- as.factor(ranking$division_rank)
ranking$conference <- as.factor(ranking$conference)
ranking$conference_rank <- as.factor(ranking$conference_rank)
ranking$playoff_finish <- as.factor(ranking$playoff_finish)


## -----------------------------------------------------------------------------
levels(ranking$year)
levels(ranking$league)
levels(ranking$division)
levels(ranking$division_rank)
levels(ranking$conference)
levels(ranking$conference_rank)
levels(ranking$playoff_finish)


## -----------------------------------------------------------------------------
levels(ranking$division)[levels(ranking$division)==""] <- "NA"
levels(ranking$conference)[levels(ranking$conference)==""] <- "NA"
levels(ranking$playoff_finish)[levels(ranking$playoff_finish)==""] <- "NA"


## -----------------------------------------------------------------------------
ggplot(statistics, aes(x=year,y=fouls)) + geom_boxplot() + theme(axis.text.x = element_text(angle=70,size=7))


## -----------------------------------------------------------------------------
ggplot(statistics, aes(x=year,y=points_scored)) + geom_boxplot() + theme(axis.text.x = element_text(angle=70,size=7))

