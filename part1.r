
## Intro

The general topic that I have chosen revolves around sports. I am an avid fan of sports and play a lot of sports in my free time. One of those sports is basketball, which is the sport that I will be focusing on for this project.

## The Data

The dataset that I have chosen to work with for the first deliverable contains information about different basketball teams for each year ranging from 1937 to 2011

### Dataset Initialization

Here I am going to load in the dataset into the variable named basketball.


library(tidyverse)basketball <- read.csv("basketball_teams.csv")

To show that the dataset meets the required size/variables, the next few segments will parse that information out.

Total Observations:
nrow(basketball)## [1] 1536


Total Number of Variables (descriptions of these variables will be provided further down):
ncol(basketball)## [1] 60



### The Source

The dataset that I have chosen comes from the website Kaggle. In the description it is said to have been taken from Open Source Sports, but the website provided does not work and there isn't a lot of information of them online. The Open Source Sports organization on Kaggle doesn't pull up anything. One thing mentioned in the description is that the database is copyrighted by Sean Lahman. He is a reporter for the USA Today Network and has focused his work around sports statistics and creating historical databases. One limitation is that because there is no true source that I could find, the data cannot be validated based on other work. While reading through the dataset, the limited documentation on teh column names makes it hard to figure out what they mean. This is discussed more in the continuous variables section.

### Variables

There are a lot of variables contained in this dataset with the majority of them being statistical data. Because some statistics didn't exist or weren't kept track of, some values will be blank or will take on the value '0'. This will primarily take place in the early years, moslty prior to 1979. Below, I have produced all of the different variables.
colnames(basketball)##  [1] "year"        "lgID"        "tmID"        "franchID"    "confID"      "divID"       "rank"       
##  [8] "confRank"    "playoff"     "name"        "o_fgm"       "o_fga"       "o_ftm"       "o_fta"      
## [15] "o_3pm"       "o_3pa"       "o_oreb"      "o_dreb"      "o_reb"       "o_asts"      "o_pf"       
## [22] "o_stl"       "o_to"        "o_blk"       "o_pts"       "d_fgm"       "d_fga"       "d_ftm"      
## [29] "d_fta"       "d_3pm"       "d_3pa"       "d_oreb"      "d_dreb"      "d_reb"       "d_asts"     
## [36] "d_pf"        "d_stl"       "d_to"        "d_blk"       "d_pts"       "o_tmRebound" "d_tmRebound"
## [43] "homeWon"     "homeLost"    "awayWon"     "awayLost"    "neutWon"     "neutLoss"    "confWon"    
## [50] "confLoss"    "divWon"      "divLoss"     "pace"        "won"         "lost"        "games"      
## [57] "min"         "arena"       "attendance"  "bbtmID"


At first glance, the extensive list may seem daunting, but once you dive in, it isn't too bad to understand.

#### Categorical Variables
The categorical variables that this dataset contains are:
- year
- lgID (League)  
- confID (Conference)  
- divID (Division)  
- rank (Division Rank)  
- confRank (Conference Rank)  
- Playoff (Round Reached in Playoffs)  

#### Continuous Variables

The Continuous Variables are all of the rest of them which includes 51 variables. With limited documentation I am assuming that the variables starting with 'o_' refer to offensive statistics whereas variables starting with 'd_' refer to defensive statistics. Because this can be confusing I am most likely just going to use the statistics starting with 'o_'.

### Data Cleaning

To start off the cleaning process I am going to rename some of the columns to help with understanding.
colnames(basketball)[colnames(basketball)=="lgID"] <- "league"colnames(basketball)[colnames(basketball)=="tmID"] <- "team_abbrev"colnames(basketball)[colnames(basketball)=="franchID"] <- "franchise_abbrev"colnames(basketball)[colnames(basketball)=="confID"] <- "conference"colnames(basketball)[colnames(basketball)=="divID"] <- "division"colnames(basketball)[colnames(basketball)=="rank"] <- "division_rank"colnames(basketball)[colnames(basketball)=="confRank"] <- "conference_rank"colnames(basketball)[colnames(basketball)=="playoff"] <- "playoff_finish"colnames(basketball)[colnames(basketball)=="name"] <- "team_name"


Once I have renamed the columns to something workable, I am going to create another couple of tables with all of the variables (columns) that I need. This will make the data easier to read and will take out unecessary data. The first table that I am going to create is a rankings table. This table will contain the year, team name/abbrev, league, conference, division, division rank, conference, conference rank, and playoff finish. The goal of this table is to separate out the team and their ranking from the on-court statistics.  

ranking <- tibble(year=basketball$year,team_abbrev=basketball$team_abbrev,
                  team_name=basketball$team_name,league=basketball$league,
                  division=basketball$division,division_rank=basketball$division_rank,
                  conference=basketball$conference,conference_rank=basketball$conference_rank,
                  playoff_finish=basketball$playoff_finish)

The next table that I will make is a statistics table. This table will contain the year, team_abbrev, and all offensive statistics. This will allow me to pair stats with a specific team while also separating that team's ranking from the on-court data. While creating this table, I am also going to change some of the variable names to make them more understandable.  
statistics <- tibble(year=basketball$year,team_abbrev=basketball$team_abbrev,
                     made_field_goal=basketball$o_fgm,attempt_field_goal=basketball$o_fga,
                     made_free_throw=basketball$o_ftm,attempt_free_throw=basketball$o_fta,
                     made_3_pointer=basketball$o_3pm,attempt_3_pointer=basketball$o_3pa,
                     rebounds=basketball$o_reb,assists=basketball$o_asts,
                     fouls=basketball$o_pf,points_scored=basketball$o_pts)

The next part of data cleaning is to make sure that all of the categorical variables are represented as factors, variables with a set number of options.  
The first step is to set them as factors.  
ranking$year <- as.factor(ranking$year)statistics$year <- as.factor(statistics$year)ranking$league <- as.factor(ranking$league)ranking$division <- as.factor(ranking$division)ranking$division_rank <- as.factor(ranking$division_rank)ranking$conference <- as.factor(ranking$conference)ranking$conference_rank <- as.factor(ranking$conference_rank)ranking$playoff_finish <- as.factor(ranking$playoff_finish)

Once they are factors, I will check all of the differenct levels, options, that the variable can take on.  
levels(ranking$year)##  [1] "1937" "1938" "1939" "1940" "1941" "1942" "1943" "1944" "1945" "1946" "1947" "1948" "1949" "1950"
## [15] "1951" "1952" "1953" "1954" "1955" "1956" "1957" "1958" "1959" "1960" "1961" "1962" "1963" "1964"
## [29] "1965" "1966" "1967" "1968" "1969" "1970" "1971" "1972" "1973" "1974" "1975" "1976" "1977" "1978"
## [43] "1979" "1980" "1981" "1982" "1983" "1984" "1985" "1986" "1987" "1988" "1989" "1990" "1991" "1992"
## [57] "1993" "1994" "1995" "1996" "1997" "1998" "1999" "2000" "2001" "2002" "2003" "2004" "2005" "2006"
## [71] "2007" "2008" "2009" "2010" "2011"
levels(ranking$league)## [1] "ABA"  "ABL1" "NBA"  "NBL"  "NPBL" "PBLA"
levels(ranking$division)##  [1] ""   "AT" "CD" "EA" "ED" "MW" "NO" "NW" "PC" "SE" "SO" "SW" "WD" "WE"
levels(ranking$division_rank)##  [1] "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
levels(ranking$conference)## [1] ""   "EC" "WC"
levels(ranking$conference_rank)##  [1] "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12" "13" "14" "15"
levels(ranking$playoff_finish)##  [1] ""   "AC" "C1" "CF" "CS" "D1" "DF" "DR" "DS" "DT" "F"  "LC" "NC" "R1" "SF" "WC"


After scanning through the different options for each variable, I am now going to change the value of the levels containing "" to "NA". The blank values represent times when a team wasn't in a division or conference, or didn't make the playoffs.  
levels(ranking$division)[levels(ranking$division)==""] <- "NA"levels(ranking$conference)[levels(ranking$conference)==""] <- "NA"levels(ranking$playoff_finish)[levels(ranking$playoff_finish)==""] <- "NA"

### Visualizations

For this first graph, I am going to show the variation in number of fouls per year. This will combine all teams from each year. This graph contains some outliers, where the stat may not have been recorded, but is able to show how the overall fouls being committed changes through the years.   
ggplot(statistics, aes(x=year,y=fouls)) + geom_boxplot() + theme(axis.text.x = element_text(angle=70,size=7))figure/unnamed-chunk-21-1.pdf

The same logic can be used when looking at points scored.  

ggplot(statistics, aes(x=year,y=points_scored)) + geom_boxplot() + theme(axis.text.x = element_text(angle=70,size=7))figure/unnamed-chunk-22-1.pdf


### Research questions

Are some statistics more influential in determining a team's playoff finish?  
What is the correlation between conference rank and playoff finish/different on-court statistics?  
What statistical trends seem to carry over from year to year?  
