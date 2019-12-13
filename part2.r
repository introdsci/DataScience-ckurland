## ----message=FALSE, error=FALSE, warning=FALSE, results='hide'----------------
include <- function(library_name){
  if( !(library_name %in% installed.packages()) )
    install.packages(library_name) 
  library(library_name, character.only=TRUE)
}
include("tidyverse")
include("rvest")
include("lubridate")
include("caret")
include("knitr")
include("BBmisc")
purl("deliverable1.Rmd", output = "part1.r")
source("part1.r")


## ----message=FALSE, error=FALSE, warning=FALSE,results='hide'-----------------
monthList <- c("october", "november", "december", "january", 
               "february","march", "april", "may", "june")
yearList <- c(1990:2011)
tib <- data.frame()
boxUrls <- data.frame()
for(year in yearList) {
  for(month in monthList) {
    url <- paste0("https://www.basketball-reference.com/leagues/NBA_",year,"_games-",month,".html")
    page <- try(read_html(url),TRUE)
    if( !("try-error" %in% class(page))){
    colNames <- page %>%
      html_nodes("table#schedule > thead > tr > th") %>%
      html_attr("data-stat")
    if(length(colNames) != 0){
    dates <- page %>%
      html_nodes("table#schedule >tbody >tr >th") %>%
      html_text()
    
    boxLink <- page %>%
      html_nodes("table#schedule >tbody >tr >td.center > a") %>%
      html_attr("href")
    dates <- dates[dates != "Playoffs"]
    
    scrapedData <- page %>%
      html_nodes("table#schedule > tbody > tr > td") %>%
      html_text() %>%
    matrix(ncol = length(colNames)-1,byrow=TRUE)
    
    month_tib <- as.data.frame(cbind(dates,scrapedData),stringAsFactors=FALSE)
    names(month_tib) <- colNames
    tib <- bind_rows(tib,month_tib)
    
    box_tib <- as.data.frame(boxLink,stringAsFactors=FALSE)
    boxUrls <- bind_rows(boxUrls,box_tib)
    
    }
    }
  }
}


## -----------------------------------------------------------------------------
  tib$home_pts <- as.numeric(tib$home_pts)
  tib$visitor_pts <- as.numeric(tib$visitor_pts)
  tib$attendance  <- as.numeric(gsub(",", "",
                                     tib$attendance))
  tib$date_game <- mdy(tib$date_game)


## -----------------------------------------------------------------------------
schedule <- tibble(date=tib$date_game,
                   home_team=tib$home_team_name,
                   home_score=tib$home_pts,
                   away_team=tib$visitor_team_name,
                   away_score=tib$visitor_pts,
                   overtimes=tib$overtimes,
                   attendance=tib$attendance,
                   start_time=tib$game_start_time)
schedule


## ----warning=FALSE------------------------------------------------------------
ranking <- arrange(ranking,year)
abbrevs <- tibble(abbrev=ranking$team_abbrev,home_team=ranking$team_name,num = 1:nrow(ranking))
abbrevs$home_team<- as.factor(abbrevs$home_team)
name_levels <- levels(abbrevs$home_team)
levels(abbrevs$home_team)[abbrevs$home_team=="Seattle Supersonics"] <- "Seattle SuperSonics"

name_levels <- levels(abbrevs$home_team)

for(t in name_levels){
  first_occur <- max(abbrevs$num[abbrevs$home_team==t])
  abbrevs <- abbrevs %>% filter(!(home_team==t & num !=first_occur))
}

home_abbrev <- tibble(home_abbrev=abbrevs$abbrev,home_team=abbrevs$home_team)
away_abbrev <- tibble(away_abbrev=abbrevs$abbrev,away_team=abbrevs$home_team)


new_schedule <- schedule %>% 
                    left_join(home_abbrev, by="home_team")
new_schedule <- new_schedule %>% 
                    left_join(away_abbrev, by="away_team")
new_schedule


## -----------------------------------------------------------------------------

ind_game <- tibble(year=year(new_schedule$date),
                   home_abbrev=new_schedule$home_abbrev,
                   home_team=new_schedule$home_team,
                   home_score=new_schedule$home_score,
                   away_abbrev=new_schedule$away_abbrev,
                   away_team=new_schedule$away_team,
                   away_score=new_schedule$away_score
                   )
ind_game


## -----------------------------------------------------------------------------
ind_game$year <- as.factor(ind_game$year)
new_game <- ind_game %>% 
                    left_join(statistics, by=c("home_abbrev"="team_abbrev","year"))
new_game
colnames(new_game)[colnames(new_game)=="made_field_goal"] <- "home_yearly_made_field_goal"
colnames(new_game)[colnames(new_game)=="attempt_field_goal"] <- "home_yearly_attempt_field_goal"
colnames(new_game)[colnames(new_game)=="made_free_throw"] <- "home_yearly_made_free_throw"
colnames(new_game)[colnames(new_game)=="attempt_free_throw"] <- "home_yearly_attempt_free_throw"
colnames(new_game)[colnames(new_game)=="made_3_pointer"] <- "home_yearly_made_3_pointer"
colnames(new_game)[colnames(new_game)=="attempt_3_pointer"] <- "home_yearly_attempt_3_pointer"
colnames(new_game)[colnames(new_game)=="rebounds"] <- "home_yearly_rebounds"
colnames(new_game)[colnames(new_game)=="assists"] <- "home_yearly_assists"
colnames(new_game)[colnames(new_game)=="fouls"] <- "home_yearly_fouls"
colnames(new_game)[colnames(new_game)=="points_scored"] <- "home_yearly_points_scored"



## -----------------------------------------------------------------------------
new_game <- drop_na(new_game)

new_game


## -----------------------------------------------------------------------------

simple_model <- lm(new_game, formula= home_score ~
                     home_yearly_made_field_goal+ 
                     home_yearly_attempt_field_goal+
                     home_yearly_made_free_throw+
                     home_yearly_attempt_free_throw+
                     home_yearly_rebounds+
                     home_yearly_assists+home_yearly_fouls+
                     home_yearly_points_scored+
                     home_yearly_made_3_pointer+
                     home_yearly_attempt_3_pointer)
summary(simple_model)



## -----------------------------------------------------------------------------
ggplot(new_game, aes(x=home_yearly_made_field_goal,y=home_score)) + geom_smooth(method=lm)
ggplot(new_game, aes(x=home_yearly_made_field_goal,y=home_yearly_assists)) + geom_point()


