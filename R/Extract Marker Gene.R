
# Extract Marker Genes ----------------------------------------------------

seu_sample1 <-best_PRECASTObj_Br3942@seulist[[1]]

seu_sample1@assays$RNA@data@Dimnames[[1]] |> head()

seu_sample2 <- best_PRECASTObj_Br3942@seulist[[2]]
seu_sample2@assays$RNA@data@Dimnames[[1]] |> head()

# Check if the gene names are arrange the same across samples
identical(seu_sample1@assays$RNA@data@Dimnames[[1]],
          seu_sample2@assays$RNA@data@Dimnames[[1]])

# The answer is yes.

# Retrieve gene name & info from spe
slct_genes <- data.frame(gene_id = seu_sample1@assays$RNA@data@Dimnames[[1]]) |> 
  left_join(spe_Br8325 |>rowData() |> as.data.frame() |>
              select(gene_id, gene_name, gene_type)
            )

# Retrieve loading matrix
ld_mat <- best_PRECASTObj_Br3942@resList$hW

clstr1_loading <- data.frame(slct_genes, wgt = ld_mat[,1]) |> arrange(desc(abs(wgt)))

clstr7_loading <- data.frame(slct_genes, wgt = ld_mat[,7]) |> arrange(desc(abs(wgt)))
clstr10_loading <- data.frame(slct_genes, wgt = ld_mat[,10]) |> arrange(desc(abs(wgt)))
clstr11_loading <- data.frame(slct_genes, wgt = ld_mat[,11]) |> arrange(desc(abs(wgt)))

erik_top10_gene <- tibble(
  `Cluster 7` = head(clstr7_loading, 10) |> pull(gene_name),
  `Cluster 10` = head(clstr10_loading, 10) |> pull(gene_name),
  `Cluster 11` = head(clstr11_loading, 10) |> pull(gene_name),
)


# neuropil-like
clstr8_loading <- data.frame(slct_genes, wgt = ld_mat[,8]) |> arrange(desc(abs(wgt)))
clstr12_loading <- data.frame(slct_genes, wgt = ld_mat[,12]) |> arrange(desc(abs(wgt)))
clstr13_loading <- data.frame(slct_genes, wgt = ld_mat[,13]) |> arrange(desc(abs(wgt)))

neuropil_top10_gene <- tibble(
  `Cluster 8` = head(clstr8_loading, 10) |> pull(gene_name),
  `Cluster 12` = head(clstr12_loading, 10) |> pull(gene_name),
  `Cluster 13` = head(clstr13_loading, 10) |> pull(gene_name),
)
