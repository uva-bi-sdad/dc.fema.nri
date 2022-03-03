# FEMA National Risk Index

states <- c("Virginia", "Maryland", "DistrictofColumbia")
ncr_fips <- c("^24021|^24031|^24033|^24017|^11001|^51107|^51059|^51153|^51013|^51510|^51683|^51600|^51610|^51685")
va_fips <- c("^51")

# download data
for(state in states){
  file <- paste0("fema_nri_", state, ".zip")
  url <- paste0("https://hazards.fema.gov/nri/Content/StaticDocuments/DataDownload//NRI_Table_CensusTracts/NRI_Table_CensusTracts_", state, ".zip")
  GET(url, write_disk(file, overwrite = TRUE))
}

files <- paste0("fema_nri_", states, ".zip")

for(file in files){
  unzip(file)
  file.remove("NRI_metadata_November2021.xml")
  file.remove("NRI_metadata_November2021.docx")
  file.remove("NRI_HazardInfo.csv")
  file.remove("NRIDataDictionary.csv")
}

dc <- read_csv("NRI_Table_CensusTracts_DistrictofColumbia.csv")
md <- read_csv("NRI_Table_CensusTracts_Maryland.csv")
va <- read_csv("NRI_Table_CensusTracts_Virginia.csv")

ncr_fema_nri <- rbind(dc, md) %>% rbind(va) %>% mutate(geoid = str_extract(NRI_ID, "(\\d+)"), year = 2021, region_type = "tract") %>% dplyr::filter(str_detect(geoid, ncr_fips))
va_fema_nri <- va %>% mutate(geoid = str_extract(NRI_ID, "(\\d+)"), year = 2021, region_type = "tract") %>% dplyr::filter(str_detect(geoid, va_fips))
write.csv(ncr_fema_nri, "ncr_tr_fema_2021_nri.csv")
write.csv(va_fema_nri, "va_tr_fema_2021_nri.csv")

