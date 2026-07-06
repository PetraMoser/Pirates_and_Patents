# Description: Replication script for Figure 11.10
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
library(haven)
library(ggplot2)
library(maps)
library(cowplot)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 11/'

library.df <- haven::read_dta(paste0(data_path, 'libraries_books.dta'))

# Format table to recreate BRP vs Swiss Books
schools <- c('Crear Library, Chicago', 'Ohio State U', 'UC Berkeley', 'Duke', 'NY Public Library', 'Yale',
             'U Muchigan', 'U Penn', 'U Virginia', 'U North Carolina', 'U Chicago', 'U Illinois',
             'U Cincinnati', 'Oregon State', 'U Tennessee', 'U Oregon', 'Case Western', 'Columbia', 'Bryn Mawr',
             'Res. Lib. Chicago', 'Harvard', 'U Brown', 'US Nat. Agricultural Lib.', 'US Nat. Bureau of Standards',
             'U Wisconsin, Madison', 'Case Western', 'Cornell')

fig11.10.df <-
    library.df %>%
    
    # keep only universities we're plotting
    filter(university %in% schools) %>%
    
    # Sum number of books per university
    group_by(university) %>%
    summarise(tot_brp = sum(tot_brp),
              tot_swiss = sum(tot_swiss),
              .groups = 'drop')
    
# Plot bar chart
panelA <-
    fig11.10.df %>%
    ggplot(., aes(x = reorder(university, -tot_brp), y = tot_brp)) +
    geom_bar(stat = 'identity') +
    theme_bw(base_size = 14) +
    theme(axis.text.x = element_text(angle = 45,  hjust = 1),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5),
          panel.grid = element_blank()) +
    labs(x = '',
         y = 'Number of Books',
         subtitle = 'BRP Books') 


panelB <-
    fig11.10.df %>%
    ggplot(., aes(x = reorder(university, -tot_swiss), y = tot_swiss)) +
    geom_bar(stat = 'identity') +
    theme_bw(base_size = 14) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5),
          panel.grid = element_blank()) +
    labs(x = '',
         y = 'Number of Books',
         subtitle = 'Swiss Books')
    
plot_grid(panelA, panelB, ncol = 1)

ggsave(paste0(output_path, 'Figure_11.10.png'), width = 6, height = 8)
