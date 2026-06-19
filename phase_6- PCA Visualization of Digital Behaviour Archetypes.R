# =====================================================
# PHASE 6
# PCA CLUSTER VISUALIZATION
# =====================================================

pca_result <- prcomp(
  scaled_data,
  center = TRUE,
  scale. = TRUE
)

# =====================================================
# 6.2 Create PCA Dataset
# =====================================================
pca_df <- data.frame(
  PC1 = pca_result$x[,1],
  PC2 = pca_result$x[,2],
  cluster = df$cluster
)

head(pca_df)

# =====================================================
# 6.3 Variance Explained
# =====================================================
variance_explained <- data.frame(
  Component = paste0(
    "PC",
    1:length(pca_result$sdev)
  ),
  
  Variance =
    (pca_result$sdev^2) /
    sum(pca_result$sdev^2),
  
  Cumulative =
    cumsum(
      (pca_result$sdev^2) /
        sum(pca_result$sdev^2)
    )
)

write.csv(
  variance_explained,
  "outputs/tables/pca_variance_explained.csv",
  row.names = FALSE
)

print(variance_explained)

# =====================================================
# 6.4 PCA Scatter Plot
# =====================================================
p_pca <- ggplot(
  pca_df,
  aes(
    x = PC1,
    y = PC2,
    color = cluster
  )
) +
  geom_point(
    size = 3,
    alpha = 0.7
  ) +
  theme_minimal() +
  labs(
    title = "PCA Visualization of Digital Behaviour Archetypes",
    x = "Principal Component 1",
    y = "Principal Component 2",
    color = "Cluster"
  )

ggsave(
  "outputs/figures/pca_clusters.png",
  p_pca,
  width = 9,
  height = 7
)
# =====================================================
# 6.5 Add Comfidence Ellipse
# =====================================================
p_pca_ellipse <- ggplot(
  pca_df,
  aes(
    PC1,
    PC2,
    color = cluster
  )
) +
  geom_point(
    alpha = 0.7,
    size = 2
  ) +
  stat_ellipse(
    linewidth = 1
  ) +
  theme_minimal() +
  labs(
    title = "Digital Behaviour Archetypes (PCA)",
    x = "Principal Component 1",
    y = "Principal Component 2"
  )

ggsave(
  "outputs/figures/pca_clusters_ellipse.png",
  p_pca_ellipse,
  width = 10,
  height = 7
)

# =====================================================
# 6.6 PCA report
# =====================================================
sink(
  "outputs/report_assets/pca_report.txt"
)

cat("====================================\n")
cat("PCA REPORT\n")
cat("====================================\n\n")

cat(
  "Variance Explained by Components\n\n"
)

print(
  head(
    variance_explained,
    5
  )
)

sink()

