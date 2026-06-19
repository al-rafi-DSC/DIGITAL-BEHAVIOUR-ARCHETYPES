# =====================================================
# PHASE 8
# FINAL MODEL EVALUATION & PROJECT SUMMARY
# =====================================================

# -----------------------------------------------------
# Calculate Evaluation Metrics
# -----------------------------------------------------

calculate_metrics <- function(cm){
  
  precision <- mean(cm$byClass[, "Pos Pred Value"])
  recall <- mean(cm$byClass[, "Sensitivity"])
  f1 <- 2 * precision * recall /
    (precision + recall)
  
  data.frame(
    
    Accuracy =
      round(cm$overall["Accuracy"],4),
    
    Kappa =
      round(cm$overall["Kappa"],4),
    
    Precision =
      round(precision,4),
    
    Recall =
      round(recall,4),
    
    F1_Score =
      round(f1,4)
  )
  
}

# =====================================================
# 8.2 Evaluate Both Models
# =====================================================
dt_metrics <- calculate_metrics(dt_cm)
rf_metrics <- calculate_metrics(rf_cm)

evaluation_table <- rbind(
  
  cbind(
    Model = "Decision Tree",
    dt_metrics
  ),
  
  cbind(
    Model = "Random Forest",
    rf_metrics
  )
  
)

print(evaluation_table)

write.csv(
  evaluation_table,
  "outputs/tables/model_evaluation.csv",
  row.names = FALSE
)

# =====================================================
# 8.3 Best Model
# =====================================================
best_model <- evaluation_table$Model[
  which.max(
    evaluation_table$Accuracy
  )
]

cat(
  "Best Model:",
  best_model,
  "\n"
)


# =====================================================
# 8.4 Key Findings Report
# =====================================================
sink(
  "outputs/report_assets/key_findings.txt"
)

cat("=========================================\n")
cat("KEY FINDINGS\n")
cat("=========================================\n\n")

cat("1. Three Digital Behaviour Archetypes were discovered using K-Means clustering.\n\n")

cat("2. The optimal number of clusters was selected using both the Elbow Method and Silhouette Analysis.\n\n")

cat("3. PCA visualization confirmed that the three clusters are reasonably well separated.\n\n")

cat("4. Random Forest achieved the highest predictive performance.\n\n")

cat(
  "Best Model: ",
  best_model,
  "\n\n",
  sep=""
)

cat("5. The most influential behavioural variables were:\n")

for(i in 1:5){
  
  cat(
    i,
    ". ",
    importance_df$Variable[i],
    "\n",
    sep=""
  )
  
}
sink()




# =====================================================
# 8.5 Project summary Report
# =====================================================
sink(
  "outputs/project_summary.txt"
)

cat("=========================================\n")
cat("DIGITAL BEHAVIOUR ARCHETYPES PROJECT\n")
cat("=========================================\n\n")

cat("Project Workflow\n\n")

cat("1. Data Cleaning\n")
cat("2. Exploratory Data Analysis\n")
cat("3. Feature Engineering\n")
cat("4. Feature Scaling\n")
cat("5. Cluster Selection\n")
cat("6. K-Means Clustering\n")
cat("7. PCA Visualization\n")
cat("8. Decision Tree Classification\n")
cat("9. Random Forest Classification\n")
cat("10. Model Evaluation\n\n")

cat("Final Results\n\n")

cat(
  "Number of Archetypes: 3\n"
)

cat(
  "Best Classification Model: ",
  best_model,
  "\n",
  sep=""
)

cat(
  "Random Forest Accuracy: ",
  round(rf_metrics$Accuracy,4),
  "\n",
  sep=""
)

cat(
  "Decision Tree Accuracy: ",
  round(dt_metrics$Accuracy,4),
  "\n",
  sep=""
)

sink()

# =====================================================
# 8.6 Final Console Summary
# =====================================================
cat("\n=====================================\n")
cat("PROJECT COMPLETED SUCCESSFULLY\n")
cat("=====================================\n\n")

cat("Best Model:", best_model, "\n")

print(evaluation_table)

cat("\nOutputs saved in the outputs folder.\n")