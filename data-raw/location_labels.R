## code to prepare `location_labels` dataset goes here
library(tibble)

location_labels <- tribble(
  ~LocationID, ~LocationName, ~LocationFilename,
  1,           "TCD Øst",     "oest",
  2,           "TCD Vest",    "vest"
)

usethis::use_data(location_labels)
