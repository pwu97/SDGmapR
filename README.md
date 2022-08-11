# USC SDGmap R Package

<!-- badges: start -->
<!-- badges: end -->

The goal of `SDGmapR` is to provide an open-source foundation for the systematic mapping
to the United Nations Sustainable Development Goals (SDGs). In this R package one can find publicly available [SDG keyword datasets](https://github.com/pwu97/SDGmapR/tree/main/datasets) in the `tidy` data format, the [UN Official SDG color scheme](https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/01/SDG_Guidelines_AUG_2019_Final.pdf) and [SDG Descriptions](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdg_desc_cleaned.csv), and several functions related to the mapping of text to particular sets of keywords.

## Installation

You can install the development version from [Github](https://github.com/USC-Office-of-Sustainability/USC-SDGmap) with:

''r
# install.packages("devtools")
devtools::install_github("USC-Office-of-Sustainability/USC-SDGmap")
'''

## Publicly Available SDG Keywords

The table below lists publicly available SDG keywords that have been published online. Some
of the lists have weights associated with every keyword, while some do not. For the purposes
of the `SDGmapR` package, we will assign an equal weight of one to every word if weights are not given. 
Note that the column for `SDG17` will represent whether the dataset has keywords
related to SDG17.

```{r, echo=FALSE, example}
library(knitr)
sdg_table <- data.frame(
  "Source" = c("[Core Elsevier (Work in Progress)](https://data.mendeley.com/datasets/87txkw7khs/1)", 
               "[Improved Elsevier Top 100](https://data.mendeley.com/datasets/9sxdykm8s4/2)", 
               "[SDSN](https://ap-unsdsn.org/regional-initiatives/universities-sdgs/)", 
               "[CMU Top 250 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html)",
               "[CMU Top 500 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html)",
               "[CMU Top 1000 Words](https://www.cmu.edu/leadership/the-provost/provost-priorities/sustainability-initiative/sdg-definitions.html)",
               "[University of Auckland (Work in Progress)](https://www.sdgmapping.auckland.ac.nz/)", "[University of Toronto (Work in Progress)](https://data.utoronto.ca/sustainable-development-goals-sdg-report/sdg-report-appendix/)"),
  "Dataset" = c("`elsevier_keywords`",
             "`elsevier100_keywords`",
             "`sdsn_keywords`",
             "`cmu250_keywords`",
             "`cmu500_keywords`",
             "`cmu1000_keywords`",
             "`auckland_keywords`",
             "`toronto_keywords`"),
  "CSV" = c("[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier_keywords_cleaned.csv)", "[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/elsevier100_keywords_cleaned.csv)", "[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/sdsn_keywords_cleaned.csv)", 
"[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu250_keywords_cleaned.csv)",
"[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu500_keywords_cleaned.csv)",
"[Link](https://github.com/pwu97/SDGmapR/blob/main/datasets/cmu1000_keywords_cleaned.csv)", "", ""),
  "SDG17" = c("No", "No", "Yes", "No", "No", "No", "Yes", "Yes")
)
kable(sdg_table)
```


