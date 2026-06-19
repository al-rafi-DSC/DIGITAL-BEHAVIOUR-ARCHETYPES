# =====================================================
# PHASE 5
# K-MEANS CLUSTERING & ARCHETYPE DISCOVERY
# =====================================================

set.seed(123)

kmeans_model <- kmeans(
  scaled_data,
  centers = 3,
  nstart = 50
)

# Save model
saveRDS(
  kmeans_model,
  "outputs/models/kmeans_model.rds"
)

# =====================================================
# 5.2 Add Cluster Labels
# =====================================================
df$cluster <- as.factor(
  kmeans_model$cluster
)

table(df$cluster)


# =====================================================
# 5.3 Save Cluster Sizes
# =====================================================
cluster_sizes <- data.frame(
  Cluster = names(table(df$cluster)),
  Count = as.vector(table(df$cluster))
)

write.csv(
  cluster_sizes,
  "outputs/tables/cluster_sizes.csv",
  row.names = FALSE
)

print(cluster_sizes)


# =====================================================
# 5.4 Cluster Summary
# =====================================================
cluster_summary <- df %>%
  group_by(cluster) %>%
  summarise(
    avg_screen_time =
      round(mean(daily_screen_time_min),2),
    
    avg_social_media =
      round(mean(social_media_time_min),2),
    
    avg_sleep =
      round(mean(sleep_hours),2),
    
    avg_notifications =
      round(mean(notification_count),2),
    
    avg_focus =
      round(mean(focus_score),2),
    
    avg_anxiety =
      round(mean(anxiety_level),2),
    
    avg_wellbeing =
      round(mean(digital_wellbeing_score),2),
    
    n = n()
  )

print(cluster_summary)

write.csv(
  cluster_summary,
  "outputs/tables/cluster_summary.csv",
  row.names = FALSE
)

# =====================================================
# 5.5 Cluster Profile Visualization
# =====================================================
library(tidyr)

cluster_long <- cluster_summary %>%
  select(
    cluster,
    avg_screen_time,
    avg_social_media,
    avg_sleep,
    avg_notifications,
    avg_focus,
    avg_anxiety,
    avg_wellbeing
  ) %>%
  pivot_longer(
    -cluster,
    names_to = "metric",
    values_to = "value"
  )

p_cluster <- ggplot(
  cluster_long,
  aes(
    metric,
    value,
    fill = cluster
  )
) +
  geom_col(position = "dodge") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Cluster Profiles",
    x = "",
    y = "Average Value"
  )

ggsave(
  "outputs/figures/cluster_profiles.png",
  p_cluster,
  width = 10,
  height = 7
)
# =====================================================
# 5.6 Preliminary Archetype Names
# =====================================================
archetype_table <- data.frame(
  Cluster = c(1,2,3),
  Archetype = c(
    "Cluster 1",
    "Cluster 2",
    "Cluster 3"
  )
)

write.csv(
  archetype_table,
  "outputs/tables/archetype_profiles.csv",
  row.names = FALSE
)
# =====================================================
# 5.7 Cluster Report
# =====================================================
sink(
  "outputs/report_assets/cluster_report.txt"
)

cat("====================================\n")
cat("CLUSTERING REPORT\n")
cat("====================================\n\n")

cat("Number of Clusters: 3\n\n")

cat("Cluster Sizes:\n")
print(cluster_sizes)

cat("\n\nCluster Summary:\n")
print(cluster_summary)

sink()