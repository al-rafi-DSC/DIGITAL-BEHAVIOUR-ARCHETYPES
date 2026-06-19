library(caret)
library(rpart)
library(rpart.plot)
library(randomForest)

# =====================================================
# PHASE 7
# CLASSIFICATION MODELS
# =====================================================

classification_data <- df %>%
  select(
    daily_screen_time_min,
    social_media_time_min,
    sleep_hours,
    notification_count,
    focus_score,
    anxiety_level,
    social_media_share,
    screen_sleep_ratio,
    cluster
  )

# =====================================================
# 7.2 Train /Test Split
# =====================================================
set.seed(123)

train_index <- createDataPartition(
  classification_data$cluster,
  p = 0.80,
  list = FALSE
)

train_data <- classification_data[train_index, ]

test_data <- classification_data[-train_index, ]
# =====================================================
# 7.3 Decision Tree
# =====================================================
decision_tree <- rpart(
  cluster ~ .,
  data = train_data,
  method = "class"
)
saveRDS(
  decision_tree,
  "outputs/models/decision_tree_model.rds"
)

#  Plot Decision Tree

png(
  "outputs/figures/decision_tree.png",
  width = 1200,
  height = 800,
  res = 150
)

rpart.plot(
  decision_tree,
  type = 2,
  extra = 104,
  fallen.leaves = TRUE
)

dev.off()


# Decision Tree Prediction

dt_predictions <- predict(
  decision_tree,
  test_data,
  type = "class"
)


# Confuision Matrix

dt_cm <- confusionMatrix(
  dt_predictions,
  test_data$cluster
)

print(dt_cm)

capture.output(
  dt_cm,
  file = "outputs/report_assets/decision_tree_results.txt"
)

# =====================================================
# 7.4 Random Forest
# =====================================================
set.seed(123)

rf_model <- randomForest(
  cluster ~ .,
  data = train_data,
  ntree = 300,
  importance = TRUE
)

saveRDS(
  rf_model,
  "outputs/models/random_forest_model.rds"
)



# Random Forest Prediction

rf_predictions <- predict(
  rf_model,
  test_data
)


# Confusion Matrix

rf_cm <- confusionMatrix(
  rf_predictions,
  test_data$cluster
)

print(rf_cm)

capture.output(
  rf_cm,
  file = "outputs/report_assets/random_forest_results.txt"
)



# =====================================================
# 7.5 Variable Importance
# ===================================================
importance_df <- data.frame(
  Variable = rownames(
    importance(rf_model)
  ),
  
  Importance = importance(
    rf_model
  )[,1]
)

importance_df <- importance_df %>%
  arrange(
    desc(Importance)
  )

write.csv(
  importance_df,
  "outputs/tables/variable_importance.csv",
  row.names = FALSE
)


# Variable Importance Plot

importance_plot <- ggplot(
  importance_df,
  aes(
    reorder(
      Variable,
      Importance
    ),
    Importance
  )
) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Random Forest Variable Importance",
    x = "",
    y = "Importance"
  )

ggsave(
  "outputs/figures/variable_importance.png",
  importance_plot,
  width = 8,
  height = 6
)

# =====================================================
# 7.6 Model Comparison Table
# ===================================================
model_results <- data.frame(
  
  Model = c(
    "Decision Tree",
    "Random Forest"
  ),
  
  Accuracy = c(
    dt_cm$overall["Accuracy"],
    rf_cm$overall["Accuracy"]
  )
)

print(model_results)

write.csv(
  model_results,
  "outputs/tables/model_results.csv",
  row.names = FALSE
)
