
# Joint Clustering of HPC samples using PRECAST

<!-- badges: start -->
<!-- badges: end -->

The goal of SRT_HPC_PRECAST is to analyze [HPC data](https://github.com/LieberInstitute/spatial_hpc). Specifically, we are interested in the consistent clustering of multiple slices/samples. A recent method/pipeline [PRECAST](https://www.biorxiv.org/content/10.1101/2022.06.26.497672v2), employing spatial factor analysis, provides an optimistic outlook to address the analytic needs of the _HPC_ project. 

## Summary of PRECAST

The claimed benefit of PRECAST is that it provides consistent clustering results across different samples without having to position/augment in an imaginary bigger capture area  (as in `BayesSpace`). Another claimed benefit is that it can automatically account for batch effects. So one doesn’t have to run `harmony`.

[`PRECAST`](https://cran.r-project.org/web/packages/PRECAST/index.html) provides its own analytic pipeline, which is based on [`seurat`](https://cran.r-project.org/web/packages/Seurat/index.html). For technical reasons, a [`SpatialExperiment`](https://bioconductor.org/packages/release/bioc/html/SpatialExperiment.html) object, commonly used to contain spatial transcriptomics data doesn't directly translate to a `seurat` object. Hence we provide a helper funtion for the translation step, see `R/spe_to_seurat.R`.


## Get Started

1.  Download [R](https://www.r-project.org/) and [RStudio
    IDE](https://www.rstudio.com/products/rstudio/download/)
2.  Install the necessary workflow packages
    [`targets`](https://cran.r-project.org/web/packages/targets/index.html)
    and [`renv`](https://rstudio.github.io/renv/articles/renv.html) if
    you don’t already have
3.  Open the R project in RStudio and call `renv::restore()` to install
    the required R packages. Please give permission to install the
    necessary packages. This will mirror the version of packages used in
    the creation of the work exactly.
4.  Call `targets::tar_make()` in the console to reproduce the analysis
5.  Use `targets::tar_load(_obj_name_)` in the console to retrieve components in 
the analysis. We defer to [The {targets} R package user manual](https://books.ropensci.org/targets/) for more information.

> The analysis has been encased in the `targets` workflow. If you doin't have prior background in `targets` workflow and are interested in see an whole example, please see the example  hosted in `R/example_script_of_PRECAST_pipeline.R`.
