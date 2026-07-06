# Description: Replication script for Figure 3.7
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
library(haven)
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 3/'

prize.df <- read_dta(paste0(data_path, 'pat_prize_sciam_cit.dta'))

#========= Create plot data frame =========
fig.3.7.df <-
    prize.df %>%
    
    # identify prize winning exhibits on the scientific american
    group_by(year, t2X) %>%
    summarise(patents = mean(ps),
              .groups = 'drop') %>%
    
    # bind with average patents from prize-winning exhibits from crystal palace 
    rbind(.,
          prize.df %>%
              filter(t1AX == 1) %>%
              group_by(year) %>%
              summarise(patents = mean(ps),
                        t2X = 2, # holder for 3rd category for plotting
                        .groups = 'drop')) %>%
    mutate(t2X = factor(t2X, levels= c('2', '1', '0')))


fig.3.7.df %>%
    ggplot(., aes(x = year, y = patents, 
                  linetype = t2X)) +
    geom_line(linewidth = .6) +
    #geom_point() +
    scale_y_continuous(breaks = seq(0, 2, by = 0.1)) +
    scale_x_continuous(breaks = seq(1840, 1870, by = 3)) +
    theme_bw(base_size = 13) +
    theme(legend.position = 'bottom',
          legend.text = element_text(size = 12),
          panel.grid = element_blank()) +
    scale_linetype_manual(values = c('solid', 'dashed', 'dotted'),
                          labels = c('Prize-Winning Exhibits',
                                     'Pub. in Scientific American',
                                     'Other Exhibits')) +
    scale_shape_manual(values = c(23, 19, 2),
                       labels = c('Prize-Winning Exhibits',
                                  'Pub. in Scientific American',
                                  'Other exhibits')) +
    geom_vline(xintercept = 1851, linetype = 'dashed') +
    annotate('text', x = 1848, y = 1.2, 
             label = 'Crystal Palace',
             size = 4) +
    labs(x = '',
         y = 'U.S. Patents per Field and Year',
         linetype = '',
         shape = '') 

ggsave(paste0(output_path, 'Figure_3.7.png'), width = 7, height = 6)

# =========== pre-1851 and post-1851 Mean ==============
prize.df %>%
    filter(year < 1851) %>%
    summarise(patents = mean(ps),
              .groups = 'drop')

prize.df %>%
    filter(year >= 1851) %>%
    summarise(patents = mean(ps),
              .groups = 'drop')


