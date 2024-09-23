#####################################################
## Coastal data wrangling                          ##
## Laura Uusitalo 20.9.2024                        ##   
## laura.uusitalo@luke.fi, laura.uusitalo@iki.fi   ##
#####################################################


# The aim of this script is to put together coastal environmental data 
# and fish yield data. 
#
# The fish yields are Finnish professional fishers catches, obtained from 
# Natural Resourcesinstitute Finland on request. Yearly sesolution is available 
# from the web site freely, the monthly resolution can be ontained by request 
# (subject to consideration).
#
#The environmental data are downloaded from merihavainnot.fi data base, which 
# includes data from The Finnish Environment Institute and  Finnish 
# Meteorological Institute.

#packages
library(dplyr)
library(lubridate)
library(purrr)
library(tidyr)


######################
# Add a table that includes the coordinates for the rectangles
#lat & lon denote the midpoint of the rectangle
coord <- read.csv("C:/Users/03054642/omat/data/ICES_rectangles_FInland.csv", 
                  header = TRUE)
coord$rectangle <- as.character(coord$rectangle)

###############
# Catch data wrangling

# Read in catch data
catches <- read.csv("C:/Users/03054642/omat/data/Catch1980_2023MonthlyLuke/Catches_1980_2023.csv",
          header=TRUE)

# remove some species and the gear type and ices columns
catches <- subset(catches, 
                  select = -c(ices, gear, gear.code, turbot, rainbow.trout, eel, other))

#sum over all gear types within rectangle-month-year combination
catches <- catches %>%
  group_by(year, month, rectangle) %>%
  summarise(across(where(is.numeric), ~sum(.x, na.rm = TRUE)))

# percentages of zeros
colSums(catches==0)/ nrow(catches)

catches$rectangle <- as.character(catches$rectangle)

# Catch data ready


#######################
# Environmental data wrangling

###
#surface temperature, all in Celcius
temp <- read.csv2("C:/Users/03054642/omat/data/2024_merihavainnotfi_downloads/Surface_temperature.csv", 
                  header =TRUE, dec=".")
#No missing coordinates:
sum(is.na(temp$siteLatitudeWGS84))
sum(is.na(temp$siteLongitudeWGS84))

# chop time field into year, month, day
temp <- temp %>%
  mutate(
    year = year(ymd_hms(time)),
    month = month(ymd_hms(time)),
    day = day(ymd_hms(time))
  )

#select necessary columns
temp <- subset(temp, 
               select = c(year, month, day, value, siteLatitudeWGS84, siteLongitudeWGS84))
colnames(temp) <- c("year", "month", "day", "surfaceTempC", "lat", "lon")

#Add rectangle number for each row based on coordinates
temp <- temp %>%
  mutate(rectangle = map2_chr(lat, lon, function(lat, lon) {
    matching_row <- which(lat >= coord$lat_min & lat < coord$lat_max &
                            lon >= coord$lon_min & lon < coord$lon_max)
    
    if (length(matching_row) > 0) {
      return(coord$rectangle[matching_row])
    } else {
      return(NA_character_)  # Return NA if no match found
    }
  }))

#remove lat & lon columns
temp <- subset(temp, 
                 select = c(year, month, day, surfaceTempC, rectangle))

#take average of samples within the same month, remove day column
temp <- temp %>%
  group_by(year, month, rectangle) %>%
  summarise(surfaceTempC = mean(surfaceTempC, na.rm = TRUE)) %>%
  ungroup()  

# temperature data ready

###
# Secchi depth
secchi <- read.csv2("C:/Users/03054642/omat/data/2024_merihavainnotfi_downloads/Secchi.csv", 
                  header =TRUE, dec=".")
#No missing coordinates:
sum(is.na(secchi$siteLatitudeWGS84))
sum(is.na(secchi$siteLongitudeWGS84))

# chop time field into year, month, day
secchi <- secchi %>%
  mutate(
    year = year(ymd_hms(time)),
    month = month(ymd_hms(time)),
    day = day(ymd_hms(time))
  )

#select necessary columns
secchi <- subset(secchi, 
               select = c(year, month, day, value, siteLatitudeWGS84, siteLongitudeWGS84))
colnames(secchi) <- c("year", "month", "day", "SecchiM", "lat", "lon")

#Add rectrangle number for each row based on coordinates
secchi <- secchi %>%
  mutate(rectangle = map2_chr(lat, lon, function(lat, lon) {
    matching_row <- which(lat >= coord$lat_min & lat < coord$lat_max &
                            lon >= coord$lon_min & lon < coord$lon_max)
    
    if (length(matching_row) > 0) {
      return(coord$rectangle[matching_row])
    } else {
      return(NA_character_)  # Return NA if no match found
    }
  }))

#remove lat & lon columns
secchi <- subset(secchi, 
                 select = c(year, month, day, SecchiM, rectangle))

#take average of samples within the same month, remove day column
secchi <- secchi %>%
  group_by(year, month, rectangle) %>%
  summarise(SecchiM = mean(SecchiM, na.rm = TRUE)) %>%
  ungroup()  

#secchi data ready

###
# 
#ice thnickness (meters)
ice <- read.csv2("C:/Users/03054642/omat/data/2024_merihavainnotfi_downloads/IceThickness.csv", 
                    header =TRUE, dec=".")
#No missing coordinates:
sum(is.na(ice$siteLatitudeWGS84))
sum(is.na(ice$siteLongitudeWGS84))

# chop time field into year, month, day
ice <- ice %>%
  mutate(
    year = year(ymd_hms(time)),
    month = month(ymd_hms(time)),
    day = day(ymd_hms(time))
  )

#select necessary columns
ice <- subset(ice, 
                 select = c(year, month, day, value, siteLatitudeWGS84, siteLongitudeWGS84))
colnames(ice) <- c("year", "month", "day", "IceM", "lat", "lon")

#Add rectrangle number for each row based on coordinates
ice <- ice %>%
  mutate(rectangle = map2_chr(lat, lon, function(lat, lon) {
    matching_row <- which(lat >= coord$lat_min & lat < coord$lat_max &
                            lon >= coord$lon_min & lon < coord$lon_max)
    
    if (length(matching_row) > 0) {
      return(coord$rectangle[matching_row])
    } else {
      return(NA_character_)  # Return NA if no match found
    }
  }))

#remove lat & lon columns
ice <- subset(ice, 
                 select = c(year, month, day, IceM, rectangle))

#take average of samples within the same month, remove day column
ice <- ice %>%
  group_by(year, month, rectangle) %>%
  summarise(IceM = mean(IceM, na.rm = TRUE)) %>%
  ungroup()  


#ice thickness data ready

###
# Water quality data

wq <- read.csv2("C:/Users/03054642/omat/data/2024_merihavainnotfi_downloads/WaterQuality.csv", 
                 header =TRUE, dec=".")
#No missing coordinates:
sum(is.na(wq$siteLatitudeWGS84))
sum(is.na(wq$siteLongitudeWGS84))

# chop time field into year, month, day
wq <- wq %>%
  mutate(
    year = year(ymd_hms(time)),
    month = month(ymd_hms(time)),
    day = day(ymd_hms(time))
  )

#select necessary columns
wq <- subset(wq, 
              select = c(year, month, day, analyteName, value, unit, siteLatitudeWGS84, siteLongitudeWGS84))
colnames(wq) <- c("year", "month", "day", "var", "value", "unit", "lat", "lon")

#Add rectrangle number for each row based on coordinates
wq <- wq %>%
  mutate(rectangle = map2_chr(lat, lon, function(lat, lon) {
    matching_row <- which(lat >= coord$lat_min & lat < coord$lat_max &
                            lon >= coord$lon_min & lon < coord$lon_max)
    
    if (length(matching_row) > 0) {
      return(coord$rectangle[matching_row])
    } else {
      return(NA_character_)  # Return NA if no match found
    }
  }))

#remove lat & lon columns
wq <- subset(wq, 
              select = -c(lat, lon))

#take average of samples within the same month, remove day column
wq <- wq %>%
  group_by(year, month, rectangle, var, unit) %>%
  summarise(value = mean(value, na.rm = TRUE)) %>%
  ungroup()  

#remove unit column to simplify next steps
wq <- subset(wq, 
             select = -unit)

#from long to wide format
wq <- wq %>%
  pivot_wider(names_from = var, values_from = c(value))

# percentages of NAs
colSums(is.na(wq)) / nrow(wq) * 100

#water quality data ready

##############
# Read in geography data 
geo <- read.csv("C:/Users/03054642/omat/data/Finnish_coastal_rectangles_geography.csv")
geo$rectangle <- as.character(geo$rectangle)

###############
# Combine the tables

Fish_Env_Baltic <- catches %>%
  full_join(wq, by = c("year", "month", "rectangle")) %>%
  full_join(ice, by = c("year", "month", "rectangle")) %>%
  full_join(secchi, by = c("year", "month", "rectangle")) %>%
  full_join(temp, by = c("year", "month", "rectangle"))

Fish_Env_Baltic <- Fish_Env_Baltic %>%
  full_join(geo, by = "rectangle")

Fish_Env_Baltic <- Fish_Env_Baltic %>%
  full_join(coord, by = "rectangle")

#add the lat & lon of the midpoint of the rectangle


write.csv(Fish_Env_Baltic, "C:/Users/03054642/omat/data/FishEnvBaltic.csv")
