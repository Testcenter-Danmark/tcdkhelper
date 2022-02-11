library(tibble)

rtimestamp_levels <- tribble(
  ~Level,             ~Label,                               ~Hex,
  "RTimestampBKi7",   "Hamilton til Biomek",                "#0C6383",
  "RTimestampPCR",    "Biomek til PCR",                     "#B6D0DA",
  "RTimestampPCRVV",  "PCR til visuel validering",          "#EEC6B9",
  "RTimestampPCRDV",  "Visuel validering til release page", "#C64017",
  "RTimestampPCRRes", "Release page til svarafgivelse",     "#ED974C",
)

usethis::use_data(rtimestamp_levels)
