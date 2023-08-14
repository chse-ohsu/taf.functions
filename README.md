TAF Open Source Functions
================
Conor Hennessy

## Purpose

The purpose of this repository is to provide assistance to people who
which to work with data from the T-MSIS Analytic Files (TAF data). The
repository contains a number of functions that perform common research
tasks using the TAF data, such as providing lists of beneficiaries with
certain conditions, evaluating data quality, etc.

Using this repository provides value to researchers by:

-   allowing those working with TAF to utilize easy-to-use functions to
    perform frequently needed data preparation & manipulation functions
    rather than writing time-consuming functions themselves

-   providing consistent and standardized procedures and definitions
    (changes/overriding definitions is possible for those who wish)

## Setup & Requirements

To use the taf.functions package, you will first need to install R and
the ‘devtools’ package for R (the devtools package is necessary to
install packages that are on GitHub rather than Cran).

<u>1) Install R:</u>

-   Windows: [Download R-4.3.1 for Windows. The R-project for
    statistical
    computing.](https://cran.r-project.org/bin/windows/base/)

-   OS X: [R for macOS
    (r-project.org)](https://cran.r-project.org/bin/macosx/)

-   Linux: [Index of /bin/linux
    (r-project.org)](https://cran.r-project.org/bin/linux/)

2\) Install ‘devtools’ package:

Run the following line of R Code:

*install.packages(‘devtools’)*

3\) <u>Install ‘taf.functions’ package:</u>

*devtools::install_github(chse-ohsu/taf.functions)*

4\) <u>Start Using Functions:</u>

*output_data \<-
taf.functions::get_apr_data_quality_measures(taf_prvdr_base_df=my_data)*

Documentation and examples for all the functions are at the bottom of
this page, or can be obained by typing ?function,
(e.g. ?get_apr_data_quality_measures).

## What If I Do Not Use R?

Most programming languages (inlcuding Stata) allow you to run code
written in another language. Thus, it will be possible for you to use
these R functions while still working in your preferred programming
language. It will be necessary to install R first, otherwise these
functions will not run. However, R is free to install (for instructions,
see ‘requirements - install R’ above).

I will provide an example in Stata as it is commonly used by researchers
working with TAF data. I may be able to provide further examples of how
to run R functions in other languages, or write the functions themselves
in other languages upon request. Please contact me if you are interested
in this possibility.

**Stata Example:**

You must first write an R script that simply reads in the data you wish
to use, calls the function you wish to use, and writes any results you
wish to use to a format you can import to Stata. For example:

`my_data <- read.csv('/path/to/my_data/data.csv')`

`output_data <- taf.functions::get_apr_data_quality_measures(taf_prvdr_base_df=my_data)`

`write.csv(output_data, '/path/to/my/data/output_data.csv'`

Save this R script, and there is no more R programming necessary.

The Stata ‘shell’ command will execute the rest of the code on the line
as if it was typed into the shell for the operating system. For example,
‘shell rmdir dir_name’ would remove a directory called ‘dir_name’.

The command to execute an R script on most platforms (Windows, OS X, or
Linux) is

`Rscript my_rscript.R`

In windows, you must first put the path to your R executable file, e.g.

`"C:\R\R-4.2.1\bin\R.exe" Rscript my_rscript.R`

Thus, to exectute an R script, you can use ‘shell Rscript’, or ’shell
“C:\R\R-4.2.1\bin\R.exe” Rscript. Say you saved your R script to
my_r\_script.R - the following Stata code should execute your R script
from Stata:

`<your stata code here>`

`export delimited my_taf_data.csv`

`shell "C:\R\R-4.2.1\bin\R.exe" Rscript my_r_script.R`

`impored delimited my_rscript_output.csv`

`<your stata code here>`

NOTE: in older versions of Windows, use ‘CMD BATCH’ instead of Rscript,
e.g.:

`shell "C:\R\R-4.2.1\bin\R.exe" CMD BATCH my_r_script.R`

## List of Current Functions:

<u>get_apr_data_quality_measures()</u>

Description: This function replicates the analysis of the data quality
of the APR files that DQ atlas does here:
https://www.medicaid.gov/dq-atlas/landing/topics/single/map?topic=g6m94&tafVersionId=34
when the topic ‘Facility/Group/Individual Code’ is selected.

The function takes data from the ‘taf_prvdr_base’ file as input, and
returns data similar to what is contained in the .csvs you can obtain by
clicking on ‘data (csv)’ above the map at the link above.

However, the DQ atlas website does not public analysis for every
year/release combination for which data is available - thus, this
function can re-create this analysis for years/releases where the DQ
Atlas data is not available, or on incomplete subsets of taf_prvdr_base
data that may be of interest to researchers.

Parameters:

taf_prvdr_base_df - dataframe, must have data from ‘taf_prvdr_base’ file

year_col - optional. A character or string with the name of the column
with the year if such a column exists (no such column is in the raw TAF
data, but is necessary if you are analyzing multiple years of data).

Returns: a dataframe with data quality measures stratified by state (and
year, if applicable)

Examples:

\(1\)

`my_data <- read.csv('/path/to/my/taf/data/taf_prvdr_base.csv')`

`data_quality_df <- get_apr_data_quality_measures(get_apr_data_quality_measures(taf_prvdr_base_df=my_data)`

\(2\)

`my_data_2016 <- read.csv('/path/to/my/taf/data/taf_prvdr_base_2016.csv')`

`my_data_2016$year <- 2016`

`my_data_2017 <- read.csv('/path/to/my/taf/data/taf_prvdr_base_2017.csv')`

`my_data_2017$year <- 2017`

`my_data_2017$year <- rbind(my_data_2016, my_data_2017)`

`data_quality_df <-get_apr_data_quality_measures(get_apr_data_quality_measures(taf_prvdr_base_df=my_data, year_col='year')`

## Contact Information

Conor Hennessy, Research Engineer III

hennessc@ohsu.edu

Center for Health System Effectiveness

3030 S Moody Ave

3030 Moody Building Suite 200

Portland, OR , 97239
