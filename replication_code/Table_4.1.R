# Description: Replication script for Table 4.1
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)

'%nin%' <- negate('%in%')

# load packages
library(tidyverse)
library(readxl)
library(gt) # format table

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 4/'

britain.df <- read_excel(paste0(data_path, 'Britain1851.xls'))
us.df <- read_excel(paste0(data_path, 'usa1851_census.xls'))

# obtaining Britain Patent Fees
britain_pfee <-
    read_excel(paste0(data_path, 'rpat100513.xls'), skip = 1) %>%
    filter(year == 1851, country == 'Britain') %>% 
    summarise(patent_fee = sum(pfee))

# replicating table
table.df <-
    britain.df %>%
    # assign patent values (if patented == 1)
    mutate(reference_to_patent = ifelse(reference_to_patent >= 1, 1, 0),
           award = ifelse(award >= 1, 1, 0)) %>%
    summarise(country = 'Britain',
              total_exhibits = n(),
              total_patented = sum(reference_to_patent, na.rm = T),
              patent_share = round(total_patented/ total_exhibits,4),
              awards = sum(award, na.rm = T),
              share_awards = round(awards / total_exhibits,4),
              patent_fees = britain_pfee$patent_fee) %>%
    # bind with the US data set
    rbind(.,
          test <- us.df %>%
              # assign patent values (if patented == 1)
              mutate(reference_to_patent = ifelse(Patents >= 1, 1, 0),
                     award = ifelse(Award >= 1, 1, 0)) %>%
              summarise(country = 'United States',
                        total_exhibits = n(),
                        total_patented = sum(reference_to_patent, na.rm = T),
                        patent_share = round(total_patented/ total_exhibits, 4),
                        awards = sum(award, na.rm = T),
                        share_awards = round(awards / total_exhibits,4),
                        patent_fees = 618)) %>% # as established by Lerner (2000, Table 3)
    # Format table to make it publication-ready
    gt(groupname_col = 'year') %>%
    tab_spanner(label = 'Patenting Rates for British and U.S. Exhibits in 1851',
        columns = c(total_exhibits,
                    total_patented,
                    patent_share,
                    awards,
                    share_awards,
                    patent_fees)) %>%
    cols_align(align = 'center',
               columns = c(total_exhibits,
                           total_patented,
                           patent_share,
                           awards,
                           share_awards,
                           patent_fees)) %>%
    tab_options(table.margin.left = 10,
                table.margin.right = 10) %>% 
    cols_label(
        total_exhibits = 'Exhibits',
        total_patented = 'Patented Exhibits',
        patent_share = 'Share Patented',
        awards = 'Awards',
        share_awards = 'Share Awards',
        patent_fees = 'Patente fees'
        ) %>%
    fmt_percent(columns = c(patent_share, share_awards), decimals = 2) %>%
    fmt_number(columns = c(total_exhibits, total_patented, awards, patent_fees),
               decimals = 0, use_seps = TRUE) %>%
    opt_table_font(font = list(google_font(name = "Times New Roman")))

gtsave(table.df, paste0(output_path, 'Table_4.1.png'))
