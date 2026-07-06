# Description: Replication script for Figure 11.3
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)

'%nin%' <- Negate('%in%')

# load packages
library(tidyverse)
library(openxlsx)
library(cowplot)
library(ggrepel)

# data paths and data 
data_path <- '../Data/operas/'
output_path <- '../Chapter 11/'

composers.df <- read.xlsx(paste0(data_path, 'Fig 5.xlsx'))

# Count the years an opera was played for
composers.df %>%
    group_by(Date) %>%
    summarise(n = n()) %>%
    ggplot(., aes(x = Date, y = n)) +
    geom_line() +
    theme_bw(base_size = 12) +
    theme(panel.grid = element_blank()) +
    geom_vline(xintercept = 1801, linetype = 'dashed') +
    annotate('text', 
             x = 1796.5, y = 7, 
             label = '1801 Copyright Law',
             vjust = 1, size = 4, color = 'black') +
    labs(x = '', y = 'Number of Composers') +
    scale_y_continuous(limits = c(0, 8))
    
ggsave(paste0(output_path, 'Figure_11.3.png'), width = 8, height = 6)

