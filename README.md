# USC Sustainability Course Finder

Peter Wu at Carnegie Mellon wrote the initial code that inspired this
project, and his original R package can be found on
[Github](https://github.com/pwu97/SDGmapR). At USC, Brian Tinsley and
Dr. Julie Hopper in the Office of Sustainability have been working to
develop this package further and raise sustainability awareness in
higher education by mapping USC course descriptions to the United
Nations Sustainability Development Goals.

## Table of Contents

-   [Installation](#installation)
-   [Cleaning Course Data](#cleaning-course-data)

## Installation

If you wish to install this package on your computer, clone this
repository by following [these
instructions.](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
Once installed, you can open, view, and edit all files in this
repository.

## Cleaning Course Data

Course data was retrieved from the USC’s Office of Academic Records and
Registrar, and the raw data files can be found in the
`cleaning_raw_data` folder. These files had lots of problems with
spacing and column names, and we addressed these issues in
`cleaning_scattered_files.R`. <!-- show the dataframe -->

``` r
top <- head(data)
knitr::kable(top, format = "html")
```

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
function (…, list = character(), package = NULL, lib.loc = NULL,
</td>
</tr>
<tr>
<td style="text-align:left;">
verbose = getOption("verbose"), envir = .GlobalEnv, overwrite = TRUE)
</td>
</tr>
<tr>
<td style="text-align:left;">
{
</td>
</tr>
<tr>
<td style="text-align:left;">
fileExt \<- function(x) {
</td>
</tr>
<tr>
<td style="text-align:left;">
db \<- grepl("\\.\[^.\]+\\.(gz\|bz2\|xz)$", x)
</td>
</tr>
<tr>
<td style="text-align:left;">
ans \<- sub(".\*\\.", "", x)
</td>
</tr>
</tbody>
</table>

Here is the code for cleaning a file…
