
# import the data.
data = read.csv("../data/FishEnvBaltic.csv.bz2", row.names = 1)

# encode all numeric variables.
for (var in names(data))
  if (is.integer(data[, var]))
    data[, var] = as.numeric(data[, var])

# "rectangle" is a code, encode as a factor.
data$rectangle = factor(data$rectangle, levels = unique(sort(data$rectangle)))

# "year" and "month" should not be treated as numeric variables, either.
data$year = factor(data$year, levels = unique(sort(data$year)))
data$month = factor(data$month, levels = unique(sort(data$month)))

# remove the measurement units at the end of the variable names.
names(data) = gsub("(Km|Km2|TempC|M)$", "", names(data))
names(data) = gsub("^Total\\.", "", names(data))

# make variable names more homogeneous.
names(data) = gsub("_", ".", names(data))
names(data) = tolower(names(data))

# recode a few more variable names.
names(data)[names(data) == "phosphorous"] = "phosphorus"
names(data)[names(data) == "surface"] = "temperature"
names(data)[names(data) == "openwater"] = "open.water"
names(data)[names(data) == "waterarea"] = "water.area"
names(data)[names(data) == "coastalzonewaterarea"] = "coastal.zone"

# save the data for further processing.
saveRDS(data, file = "../data/prepd.rds")
