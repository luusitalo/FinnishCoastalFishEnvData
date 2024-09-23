# FinnishCoastalFishEnvData
Compilation of Finnish coastal environmental and fish catch data into one data set. THe originaldata are not upliaded here.

FishEnvBaltic metadata
Laura Uusitalo 20.9.2024
laura.uusitalo@luke.fi, laura.uusitalo@iki.fi

This data set has been compiled from data from three sources:
1. Fish catch data originates from Natural Resources Institute Finland (Luke, luke.fi). It consists of the total catches per statistical rectangle and month. The original data also specifies catches per gear type. In this data set, catches from all gear types have been summed. The source data are part of the official statistics. They are freely available on a year-rectrangle level from luke.fi website, but the monthly level is not openly available.

2. Environmental observation data originate from merihavainnot.fi data portal that includes the environmental observations data of Finnish Environment Institute (Syke, syke.fi) and Finnish Meteorological Institute (FMI, fmi.fi). These data include timestamp and coordinates. The observations have been assigned to the statistical rectangles based on  their coordinates. If there are multiple observation in one rectangle-month combination, the mean value is used here.

3. Geographical data are based on Hildén M, Kuikka S, Roto M, Lehtonen H. 1988. Differences in fish community structure along the Finnish coast in the Baltic Sea. ICES Symposium 1988, BAL/no. 15. They are the same data as used in Uusitalo, L., Kuikka, S., Kauppila, P., Söderkultalahti, P. and Bäck, S., 2012. Assessing the roles of environmental factors in coastal fish production in the northern Baltic Sea: A Bayesian network application. Integrated environmental assessment and management, 8(3), pp.445-455. They are assumed to be static, i.e. they do not change in time.

Brief explanation of variables:

"year", "month" = year and month of the observation. 

"rectangle" = geographic grid cell code; see the pdf attached to the email (also, lat & lon info is included)

"herring", "sprat", "cod", "flounder", "whitefish", "salmon", "trout", "smelt", "bream", "ide", "roach", "pike", "perch", "sander", "burbot", "vendace" = Fish catches of these species, in kilograms. 

"Total phosphorous", "Colour number", "Total nitrogen", "Turbidity", "Salinity", "Chlorophyll a", "Suspended solids" = water quality variables       

"IceM" = ide thickness, in meters

"SecchiM" = Secchi depth, i.e. "how deep you can see"
                
"surfaceTempC" = surface temperature

"Area" = total area of the rectangle, probably not relevant here though...

"CoastLineKm" = length of coastline in the grid cell, km

"OpenWaterKm2" = area of open water in the cell, km2

"WaterAreaKm2" = total water area in the grid cell, km2 (we may want to explore whether it makes sense to dicide the catches per water area, and/or present the open/coastal water area as %)

"CoastalZoneWaterAreaKm2" = water area of coastal zone, km2 (i.e. shallow / sheltered areas)

"lon_min", "lon_max", "lat_min", "lat_max" = the bounding limits of the grid cell

"lon", "lat" = the centerpoint coordinates of thegrid cell 


