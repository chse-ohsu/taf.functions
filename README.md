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

## Requirements

<u>1) Install R:</u>

-   Windows: [Download R-4.3.1 for Windows. The R-project for
    statistical
    computing.](https://cran.r-project.org/bin/windows/base/)

-   OS X: [R for macOS
    (r-project.org)](https://cran.r-project.org/bin/macosx/)

-   Linux: [Index of /bin/linux
    (r-project.org)](https://cran.r-project.org/bin/linux/)

2<u>) Install Git or GitHub desktop:</u>

Git is a command line tool that is harder to learn but more powerful
than GitHub desktop. GitHub Desktop is a user-friendly desktop
application for accessing GitHub repositories such as this one. GitHub
Desktop may be preferable if you do not have a background in computer
programming, use Windows, and/or only use this specific GitHub
repository.

-   GitHub Desktop: [GitHub Desktop | Simple collaboration from your
    desktop](https://desktop.github.com/)

-   Git (command line tool): [Git - Installing Git
    (git-scm.com)](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

NOTE: if you work on a shared server, you may already have R and git
installed, If not, you may need to get permission or assistance from a
system administrator to complete these installations.

## How To Use:

1\) <u>Navigate to \<URL\> and clone the repository. For help cloning
the repository:</u>

-   with GitHub Desktop: [Cloning a repository from GitHub to GitHub
    Desktop - GitHub
    Docs](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/adding-and-cloning-repositories/cloning-a-repository-from-github-to-github-desktop)

-   with command line git: [Cloning a repository - GitHub
    Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

2\) <u>Install “taf.functions” package:</u>

-   

3\) <u>Start Using Functions:</u>

Documentation and examples for all the functions are contained in the
repositories with the functions.

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

You must first right an R script that simply reads in the data you wish
to use, calls the function you wish to use, and writes any results you
wish to use to a format you can import to stata. For example:

`my_data <- read.csv('/path/to/my_data/data.csv')`

`output_data <- get_apr_data_quality_measures(taf_prvdr_base_df=my_data)`

`write.csv(output_data, '/path/to/my/data/output_data.csv'`

Save this R script, and there is no more R programming necessary.

The Stata ‘shell’ command will execute the rest of the code on the line
as if it was typed into the shell for the operating system. For example,
‘shell rmdir dir_name’ would remove a directory called ‘dir_name’.

The command to execute an R script on any platform (Windows, OS X, or
Linux) is

`<Rscript my_rscript.R>`

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

## List of Current Functions

Additional documentation for each of these functions is available in the
folders where the functions are stored.

-   **Condition Definitions and Related Functions**

    -   *Opioid Use Disorder*

        -   Opioid use disorder definitions:

            -   /taf_open_source_functions/opioid_related_disorder.R

        -   get_taf_opioid_use_disorder_patients()

            -   /taf_open_source_functions/opioid_related_disorder.R

-   **Miscellaneous TAF Functions**

    -   fill_in_missing_demographic_data()

        -   taf_open_source_functions/misc/fill_in_missing_demographics.R

    -   get_apr_data_quality_measures()

        -   taf_open_source_functions/misc/get_apr_data_quality_measures.R

## Questions, feedback, or ideas for functions?

Contact Conor Hennessy - hennessc@ohsu.edu

Research Engineer III | Center for Health System Effectiveness

Oregon Health and Science University

## License

Copyright 2023, Center for Health System Effectiveness

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
“Software”), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
