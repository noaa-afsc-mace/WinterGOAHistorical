# WinterGOAHistorical

A simple data package to provide background to MACE Cruise Reports

## How to install the package

1. First, install the Devtools package if needed.

`install.packages("devtools")`

2. Load the Devtools package.

`library(devtools)`

3. Load WinterGOAHistorical

`devtools::install_github('noaa-afsc-mace/WinterGOAHistorical')`

file:///D:/R/work/WinterGOAHistorical/docs/index.html
## More information can be found on the [WinterGOAHistorical page](https://noaa-afsc-mace.github.io/WinterGOAHistorical/)

This data package contains two dataframes. PreSelectivityWinterGOA.RData is the pre-selectivity biomass and numbers at length by interval for all of the winter GOA survey regions. The other (PreSelectivityWinterGOAages.RData) is pre-selectivity biomass and numbers at AGE by interval for just Shelikof, because we don't have Shumagins age data. 

For Shelikof, historical data are contained in MB and MB2 from 1995- 2023, but we're limiting this data set to surveys prior to implementation of net-selectivity corrections, which includes 1995-2007. Shelikof selectivity corrections started in 2008. For the Shumagins, the pre-selectivity data include 2001-2008. Shumagins selectivity corrections started in 2009. Shumagins surveys only go back to 2001 (!!!) in MB, MB2, and MB-historic.

Shelikof surveys prior to 1995 and Shumagins surveys prior to 2001 only exist as .csv files summarized in numbers and biomass by length in the depths of the G/ drive. Shelikof: 198001, 198102, 198302x, 198402, 198503, 198603, 198703, 198802, 198902, 199001, 199101, 199102, 199202, 199302, 199403x, where the x indicates that a Shumagins survey was included, and Shumagins-only: 199501 and 199602. All of these surveys were conducted aboard the Miller Freeman. 

## Disclaimer

“The United States Department of Commerce (DOC) GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. DOC has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce stemming from the use of its GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.”


<img src="https://raw.githubusercontent.com/nmfs-fish-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
