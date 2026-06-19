# =====================================================
# PHASE 3
# FEATURE ENGINEERING & SCALING
# =====================================================

# -----------------------------------------------------
# Create Behaviour Features
# -----------------------------------------------------

df <- df %>%
  mutate(
    
    screen_time_hours =
      daily_screen_time_min / 60,
    
    social_media_share =
      social_media_time_min /
      daily_screen_time_min,
    
    screen_sleep_ratio =
      daily_screen_time_min /
      sleep_hours,
    
    notification_intensity =
      notification_count /
      screen_time_hours
  )

# -----------------------------------------------------
# Check New Variables
# -----------------------------------------------------

summary(
  df %>%
    select(
      screen_time_hours,
      social_media_share,
      screen_sleep_ratio,
      notification_intensity
    )
)

# -----------------------------------------------------
# Save Feature Summary
# -----------------------------------------------------

feature_summary <- data.frame(
  Variable = c(
    "screen_time_hours",
    "social_media_share",
    "screen_sleep_ratio",
    "notification_intensity"
  ),
  
  Mean = round(
    sapply(
      df %>%
        select(
          screen_time_hours,
          social_media_share,
          screen_sleep_ratio,
          notification_intensity
        ),
      mean
    ),
    3
  ),
  
  SD = round(
    sapply(
      df %>%
        select(
          screen_time_hours,
          social_media_share,
          screen_sleep_ratio,
          notification_intensity
        ),
      sd
    ),
    3
  )
)

write.csv(
  feature_summary,
  "outputs/tables/feature_summary.csv",
  row.names = FALSE
)



# -----------------------------------------------------
# Clustering
# -----------------------------------------------------

clustering_features <- df %>%
  select(
    daily_screen_time_min,
    social_media_time_min,
    sleep_hours,
    notification_count,
    focus_score,
    anxiety_level,
    social_media_share,
    screen_sleep_ratio
  )

#Scaled Data
scaled_data <- scale(clustering_features)

#Scaling Check
scaling_check <- data.frame(
  Variable = colnames(scaled_data),
  Mean = round(colMeans(scaled_data), 4),
  SD = round(apply(scaled_data, 2, sd), 4)
)

print(scaling_check)

write.csv(
  scaling_check,
  "outputs/tables/scaling_check.csv",
  row.names = FALSE
)