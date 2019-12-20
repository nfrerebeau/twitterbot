# Référentiel des domaines HAL
.hal_domain <- read.table("./data-raw/hal_ref_domaine.csv",
                          header = TRUE, sep = ",")
usethis::use_data(.hal_domain, internal = TRUE, overwrite = FALSE)
