# Pirates and Patents Replication File

This repository contains historical data on innovations (including exhibits at world fairs and patents), as well as replication codes for tables and figures in my book *"PIRATES AND PATENTS: THE ROLE OF INTELLECTUAL PROPERTY IN THE INDUSTRALIZATION OF THE WESTERN WORLD"*

**Please cite the corresponding publication if you use any of the data.**

---
## 📁 Repository Structure
We have the following project layout:

```text
/
├── data/                  # Raw data files (e.g., .csv, .xlsx, .dta)
├── replication_code/      # Analysis scripts (e.g., .R, .py)
├── figures/               # Output from analysis scripts
├── primary_sources/       # PDFs of primary sources (e.g. Italian Laws and letters)
└── README.md              # Project documentation
```

## Data Files for Figures and Tables 

| **Data Description** | **Data File** | **Publication** |
|----------------------|---------------|------------------|
| 150 years of patents obtained through API | `patents_per_year.csv` | 150 years of Patent Protection by Josh Lerner|
| Manually collected yearly data on patent applications and sealed patents in Great Britain between 1617 and 1938. | `Brit_patents_app_sealed1617-1938.xlsx` | Mitchell, Brian R. *British Historical Statistics*. Cambridge University Press, 1988. |
| Country–year dataset for international exhibitions (1851 Crystal Palace and 1876 Centennial Exhibition) including number of exhibits by industry class, medal counts (Council, Prize, Honor), patent length, patent fees, population, and GDP. | `rpat100513.xls` | Moser, Petra. “How Do Patent Laws Influence Innovation? Evidence from Nineteenth-Century World Fairs.” *American Economic Review* 95, no. 4 (2005): 1214–1236. |
| Patent-level data identifying prize-winning inventions at the 1851 Crystal Palace Exhibition and inventions publicized in *Scientific American*, including USPTO class and patent status indicators. | `pat_prize_sciam_cit.dta` | Moser, Petra, and Tom Nicholas. “Prizes, Publicity, and Patents: Non-Monetary Awards as a Mechanism to Encourage Innovation.” *Journal of Industrial Economics* 61 (2013): 763–788. |
| Country-level counts of innovations exhibited at the 1851 Crystal Palace Exhibition and the 1876 Centennial Exhibition, with information on patent length, population, and GDP. | `rpat509rep.xls` | Moser, Petra. “Innovation without Patents: Evidence from World’s Fairs.” *Journal of Law and Economics* 55, no. 1 (2012): 43–74. |
| Exhibit-level dataset for U.S. exhibitors at the 1851 Crystal Palace Exhibition including city, state, population, exhibit description, patent references, industry classification, and awards. | `usa1851_JO90724.xls` | Moser, Petra. “How Do Patent Laws Influence Innovation? Evidence from Nineteenth-Century World Fairs.” *American Economic Review* 95, no. 4 (2005): 1214–1236. |
| Exhibit-level dataset for British exhibitors at the 1851 Crystal Palace Exhibition including exhibitor name, address, city, population, country within Britain, industry class, description, patent references, and awards. Cities without population values are treated as rural in location-based analyses. | `Britain1851.xls` | Moser, Petra. “Innovation without Patents: Evidence from World’s Fairs.” *Journal of Law and Economics* 55, no. 1 (2012): 43–74. |
| Crosswalk between detailed exhibition industry classes and broader industry categories used in the exhibition datasets. | `industry.dta` | Moser, Petra. “How Do Patent Laws Influence Innovation? Evidence from Nineteenth-Century World Fairs.” *American Economic Review* 95, no. 4 (2005): 1214–1236. |
| Yearly counts of British and U.S. sewing-machine patents (1850–1885) including total patents, sewing-machine patents excluding attachments and tables, and shares relative to all patents. | `sewing_machines906022.xls` (sheet: `Tab sm pat total pat`) | Lampe, Ryan, and Petra Moser. “Do Patent Pools Encourage Innovation? Evidence from the 19th-Century Sewing Machine Industry.” *Journal of Economic History* 70, no. 4 (2010): 898–920. |
| Exhibit-level dataset for U.S. exhibitors at the 1851 Crystal Palace Exhibition matched with census population data, including exhibitor name, location, industry classification, patent indicators, and awards. | `usa1851_census.xls` | Moser, Petra. “How Do Patent Laws Influence Innovation? Evidence from Nineteenth-Century World Fairs.” *American Economic Review* 95, no. 4 (2005): 1214–1236. |
| Dataset on patent pools across 20 industries during the New Deal, including characteristics of pools and industry-level information. | `pools111203b.xlsx` (sheet: `pool_chars.csv`) | Lampe, Ryan, and Petra Moser. “Patent Pools, Competition, and Innovation.” *Journal of Law, Economics, and Organization* (2016). |
| Patent counts by stitch type (chain vs. lock) in the U.S. sewing machine industry, identified by USPTO subclass and year. | `RJE_data140123.dta` | Lampe, Ryan, and Petra Moser. “Patent Pools and Innovation in Substitute Technologies.” *RAND Journal of Economics* (2014). |
| Main dataset on sewing machine patents used to study the Sewing Machine Combination patent pool and its effect on innovation. | `JEH_data140123.dta` | Lampe, Ryan, and Petra Moser. “Do Patent Pools Encourage Innovation?” *Journal of Economic History* 70, no. 4 (2010): 898–920. |
| Patent counts by chemical subclass in the USPTO between 1875 and 1939 with indicators for subclasses whose German-owned patents were confiscated or licensed under the Trading with the Enemy Act. | `twea_data.dta` | Moser, Petra, and Alessandra Voena. “Compulsory Licensing: Evidence from the Trading with the Enemy Act.” *American Economic Review* 102, no. 1 (2012): 396–427. |
| Patent counts by class and year for inventions patented in Germany between 1900 and 1930, including indicators for classes affected by compulsory licensing under the Trading with the Enemy Act. | `class_year.dta` | Baten, Joerg, Nicola Bianchi, and Petra Moser. “Compulsory Licensing and Innovation: Evidence from German Patents after World War I.” *Journal of Development Economics* 126 (2017). |
| Plant patent dataset with one observation per plant innovation (1930–1970), including patent number, inventor name, inventor gender, state of origin, and an indicator for rose varieties. | `PlantPat_DateMerge.dta` | Moser, Petra. Plant patent data constructed for research on innovation and intellectual property in plant breeding. |
| Opera-level dataset for Italian operas (1781–1821) including premiere location, composer information, and indicators of long-run success such as inclusion in Loewenberg’s *Annals of Opera* and availability on Amazon. | `20years.dta` | Giorcelli, Michela, and Petra Moser. “Copyright and Creativity: Evidence from Italian Operas.” *Journal of Political Economy* 128, no. 11 (2020): 4163–4210. |
| Composer-level dataset identifying Italian composers living abroad and the year they returned to Italy. | `Fig 5.xlsx` | Giorcelli, Michela, and Petra Moser. “Copyright and Creativity: Evidence from Italian Operas.” *Journal of Political Economy* 128, no. 11 (2020): 4163–4210. |
| Performance-level dataset tracking repeat performances of operas over time, allowing measurement of longevity and diffusion across cities and theaters. | `repeated_performances140405.dta` | Giorcelli, Michela, and Petra Moser. “Copyright and Creativity: Evidence from Italian Operas.” *Journal of Political Economy* 128, no. 11 (2020): 4163–4210. |
| Dataset on poetry book publications including prices, publication year, author information, genre, and author death year to study copyright expiration and book prices. | `dat_rom_ecb_final.dta` | Li, Xing, Megan MacGarvie, and Petra Moser. “Dead Poet’s Property: How Does Copyright Influence Price?” *RAND Journal of Economics* 49, no. 1 (2018): 181–205. |
| Dataset on scientific books with yearly citation counts and information on participation in the WWII Book Republication Program (BRP). | `books_data.dta`; `brp_dataset.dta` | Biasi, Barbara, and Petra Moser. “Effects of Copyright on Science: Evidence from the WWII Book Republication Program.” *AEJ: Microeconomics* 13, no. 4 (2021): 218–260. |
| Citations to BRP books by scientists listed in *American Men of Science* and mathematics PhD students. | `mos_citations.dta` | Biasi, Barbara, and Petra Moser. “Effects of Copyright on Science: Evidence from the WWII Book Republication Program.” *AEJ: Microeconomics* 13, no. 4 (2021): 218–260. |
| University library holdings and citation coordinates for BRP books, including geographic information for citations and library locations. | `libraries_books.dta`; `libraries_cit_coord.dta` | Biasi, Barbara, and Petra Moser. “Effects of Copyright on Science: Evidence from the WWII Book Republication Program.” *AEJ: Microeconomics* 13, no. 4 (2021): 218–260. |
------

## Data Files for Replication Code
| **Code Description** | **Code File** | **Data File(s) Used** |
|----------------------|---------------|-----------------------|
|Replication of Figure 1.5 |  `Figure_1.5_preprocess.ipynb`; `Figure_1.5.R` | `patents_per_year.csv`; `Brit_patents_app_sealed1617-1938.xlsx`|
|Replication of Figure 1.7 |  `Figure_1.7.R` | `pat_timeline.xlsx`|
|Replication of Figure 3.1 |  `Figure_3.1.R` | `rpat100513.xls`|
|Replication of Figure 3.6 |  `Figure_3.6.R` | `rpat100513.xls`|
|Replication of Figure 3.7 |  `Figure_3.7.R` | `pat_prize_sciam_cit.dta`|
|Replication of Figure 5.1 |  `Figure_5.1.R` | `usa1851_JO90724.xls`; `Britain1851.xls`; `industry.dta`|
|Replication of Figure 5.3 |  `Figure_5.3.R` | `rpat100513.xls`|
|Replication of Figure 5.6 |  `Figure_5.6.R` | `rpat509rep.xls`|
|Replication of Figure 6.1 |  `Figure_6.1.R` | `sewing_machines906022.xls`, sheet = `Tab sm pat total pat`|
|Replication of Figure 6.2 |  `Figure_6.2.R` | `RJE_data140123.dta`|
|Replication of Figure 9.3 |  `Figure_9.3.R` | `twea_data.dta`|
|Replication of Figure 9.4 |  `Figure_9.4.R` | `twea_data.dta`|
|Replication of Figure 9.6 |  `Figure_9.6.R` | `twea_data.dta`|
|Replication of Figure 9.8 |  `Figure_9.8.R` | `class_year.dta`|
|Replication of Figure 9.9 |  `Figure_9.9.R` | `class_year.dta`|
|Replication of Figure 10.4 |  `Figure_10.4.R` | `PlantPatDateMerge.dta`|
|Replication of Figure 11.2 |  `Figure_11.2.R` | `20years.dta`|
|Replication of Figure 11.3 |  `Figure_11.3.R` | `Fig 5.xlsx`|
|Replication of Figure 11.4 |  `Figure_11.4.R` | `repeated_performances140405.dta`|
|Replication of Figure 11.5 |  `Figure_11.5.R` | `dat_rom_ecb_final.dta`|
|Replication of Figure 11.7 |  `Figure_11.7.R` | `books_data.dta`|
|Replication of Figure 11.8 |  `Figure_11.8.R` | `books_data.dta`|
|Replication of Figure 11.9 |  `Figure_11.9.R` | `brp_dataset.dta`; `mos_citations.dta`|
|Replication of Figure 11.10 |  `Figure_11.10.R` | `libraries_books.dta`|
|Replication of Figure 11.11 |  `Figure_11.11.R` | `libraries_cit_coord.dta`|
|Replication of Table 4.1 |  `Table_4.1.R` | `Britain1851.xls`; `usa1851_census.xls`|
---

## Sources for Exhibition Data
For Moser (2003, 2005) I collected data from two official catalogues and one commission report available in the holdings of the UC Berkeley Library. For this book, I have extended the data with additional editions that have become available through Google Books, including the Third and Revised Edition of the Official Catalog of the International Exhibition of 1876, the Swiss Catalogue of the International Exhibition 1876 Philadelphia, and the Special Catalogue of the Netherland Section.

- 1851 Exhibits: Royal Commission. Official Catalogue of the Great Exhibition of the Work of Industry of All Nations 1851, Third Corrected and Improved Edition. London: Spicer Brothers, 1851.
- 1876 Exhibits: United States Centennial Commission. International Exhibition 1876 Official Catalogue, Second and Revised Edition. Philadelphia: John R. Nagle and Company, 1876.
- 1851 Awards: Berichterstattungs-Kommission der Deutschen Zollvereins-Regierungen. Amtlicher Bericht über die Industrie-Austellung aller Völker zu London im Jahre 1851. Vols. I–III. Berlin: Verlag der Deckerschen Geheimen Ober-Hofbuchdruckerei, 1852–1853.

## Population Data Construction
Population data are taken from *Annuaire international de statistique* (1916, vol. 1, État de la population (Europe)) for German states (Bavaria, Prussia, Saxony, Württemberg) and from Maddison (2006) for all other countries. Exhibits per capita differ from Moser (2003, 2005) because we use Maddison’s revised population estimates. In particular, Britain’s 1851 population is revised from 25,601,000 (older series) to 26,945,000 (Maddison 2006), a difference of +1,344,000 (+5.25%), and Austria’s from 3,950,000 to 3,978,000, a difference of +28,000 (+0.71%). These revisions mechanically change per-capita exhibit counts even when exhibit totals are unchanged.

## Patenting Rate in Urban vs. Rural Areas Data
Data for US exhibits in 1876 for the Centennial fair, found in `usa1851_JO90724.xls`, includes the patenting rates across Britain and the United States for both rural and urban areas. Since place names change over time, I use historical gazetteers like *Bartholomew’s Gazetteer of the British Isles* (1887) to identify towns whose names or borders have changed. Matching locations with population data from the British census yield city size for 5,317 (83.4 percent) of British exhibits. Since cities and towns that do not show up in the census are very likely to be small, I assign them to towns with fewer than 10,000 people. To control for historical border changes within London, I assign districts (such as Clerkenwell and Islington) that are part of London today to the City of London and maintain the record of their district name.


## Primary Sources
This folder includes copies of the historical sources relating to the Copyright Law in 1801. 

| **File** |     **Source**     |      **Description**     |   **Citation**  |
|----------|--------------------|--------------------------|-----------------|
|`French_Copyright_Law_1793.png`|Code du Commerce, ou Recueil de Lois, Réglemens et Arrêtés, pour les Tribunaux de Commerce (1799)|Photocopy of the French Chénier Act in July 19th, 1793. This granted authors of all genres, composers, and painters the exclusive rights to sell their work and extends the rights for 10 years after the death of authors.|Giorcelli & Moser 2020, Appendix B, p. 32|
|`Copyright_Law_Cisalpine_Republic_1801.pdf`|Legge N. 423 19 Fiorle Anno IX Repubblicano, Raccolta delle leggi, proclami, ordini ef avvisi pubblicati in Milano dal giorno 13 Peatile anno VII, n. 144, Milano, 1801|Official collection of laws and decrees issued in Milan during the late Cisalpine Republic that encompassed parts of northern Italy, specifically Lombardy and Venetia. Article 1 provides copyrights to authors of every kind. Article 2 provides hereditary rights to heirs or assignees for 10 years after the author's death.|Giorcelli & Moser 2020, p. 4170|
|`papal_state_literacy_scientific_work_1826.pdf`|Editio N. 433, 28 Settembree, 1826|Transcript of the official copyright law in papal state in 1826|Giorcelli & Moser 2020, Appendix B, pp. 39-40|
|`sicily_intellectual_property_1828.pdf`|REGIO DECRETO NO. 1904, 5 FEBBRAIO, 1828|Transcript of the official copyright law in the Kingdom of Two Scicilies in 1828|Giorcelli & Moser 2020, Appendix B, p. 40|
|`bileteral_treaty_austria_1840.pdf`|CONVENZIONE 22 MAGGIO 1840 SEGUITA TRA SUA MAESTÀ IL RE DI SARDEGNA E L’IMPERATORE D’AUSTRIA A FAVORE DELLA PROPRIETÀ E CONTRO LA CONTRAFFAZIONE DELLE OPERE SCIENTIFICHE, LETTERARIE E ARTISTICHE|Transcript of the Bilateral Treat with Austria in 1840. This treaty granted property rights to literary and artistic works with an extension of 30 years after author's death|Giorcelli & Moser 2020, Appendix B, pp. 40-44|
|`italy_copyright_1865.pdf`|LEGGE 25 GIUGNO 1865 NO. 2337 SUI DIRITTI SPETTANTI AGLI AUTORI DELLE OPERE DELL’INGEGNO|Italian Copyright Law of 25 June 1865, No. 2337. Issued under Vittorio Emanuele II, it consolidated Italy's first national copyright statute after unification. These laws were downloaded from Uberatzzi (law firm) back in 2013. The website is no longer available but we are making the transcription available here.|Giorcelli & Moser 2020, Appendix B, pp. 41-45|
|`carte_sciolte6268.png`|Archivio Storico Della Cità di Torino (ACS), Carte Sciolte (1111-1848)|Transcript for opera composition between Francesco Bendetto Ricci and Giuseppe Mosca, Teatro Alla Scala in Milano, January 16, 1802|Giorcelli & Moser 2020, Appendix B, p. 20|
|`carte_sciolte6261.png`|Archivio Storico Della Cità di Torino (ACS), Carte Sciolte (1111-1848)|Letter from the impresario Angelo Petracchi to the composer Giovanni Pacini, Treatro Alla Scala in Milano, December 12, 1819|Giorcelli & Moser 2020, Appendix B, p. 23|
|`carte_sciolte6253.png`|Archivio Storico Della Cità di Torino (ACS), Carte Sciolte (1111-1848)|Letter from the composer Stefano Pavesi to the impresatio Giacomo Pregliasco of the Teatro Regio in Torino, November 3, 1803|Giorcelli & Moser 2020, Appendix B, p. 22|
-------
 
## Notes

- Some data files appear in multiple studies; cite all relevant publications.
- Unless otherwise stated, file names are the same as the file names in replication packages for each paper.
---
