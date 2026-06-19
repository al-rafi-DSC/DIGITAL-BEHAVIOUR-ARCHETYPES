library(cluster)
library(factoextra)

# =====================================================
# PHASE 4
# DETERMINE OPTIMAL NUMBER OF CLUSTERS
# =====================================================

set.seed(123)

fviz_nbclust(
  scaled_data,
  kmeans,
  method = "wss"
) +
  labs(
    title = "Elbow Method"
  )

ggsave(
  "outputs/figures/elbow_plot.png",
  width = 8,
  height = 6
)

# =====================================================
# 4.2 Silhouette Method
# =====================================================
set.seed(123)

fviz_nbclust(
  scaled_data,
  kmeans,
  method = "silhouette"
) +
  labs(
    title = "Silhouette Analysis"
  )

ggsave(
  "outputs/figures/silhouette_plot.png",
  width = 8,
  height = 6
)

# =====================================================
# 4.2 Numerical Silhouette Scores
# ====================================================
sil_scores <- data.frame(
  k = 2:10,
  silhouette_score = NA
)

for(i in 2:10){
  
  km <- kmeans(
    scaled_data,
    centers = i,
    nstart = 25
  )
  
  ss <- silhouette(
    km$cluster,
    dist(scaled_data)
  )
  
  sil_scores$silhouette_score[
    sil_scores$k == i
  ] <- mean(ss[,3])
}

print(sil_scores)


#Save Table

write.csv(
  sil_scores,
  "outputs/tables/silhouette_scores.csv",
  row.names = FALSE
)


# =====================================================
# 4.4 Best K
# ====================================================
best_k <- sil_scores$k[
  which.max(
    sil_scores$silhouette_score
  )
]

cat(
  "Best K according to silhouette:",
  best_k,
  "\n"
)


# Save Recommendation

sink(
  "outputs/report_assets/cluster_selection_report.txt"
)
cat(
  "====================================\n"
)
cat(
  "CLUSTER SELECTION REPORT\n"
)
cat(
  "====================================\n\n"
)
cat(
  "Recommended Number of Clusters:",
  best_k,
  "\n\n"
)
cat(
  "Silhouette Scores:\n\n"
)

print(sil_scores)

sink()