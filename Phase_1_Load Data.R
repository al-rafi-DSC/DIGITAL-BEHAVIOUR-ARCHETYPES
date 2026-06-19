# =====================================================
# DIGITAL BEHAVIOUR ARCHETYPES
# Phase 1: Setup & Data Quality Assessment
# =====================================================

# -----------------------------------------------------
# 1. Libraries
# -----------------------------------------------------

library(tidyverse)
library(corrplot)
library(gridExtra)

# -----------------------------------------------------
# 2. Create Project Folders
# -----------------------------------------------------
dirs <- c(
  "outputs",
  "outputs/figures",
  "outputs/tables",
  "outputs/models",
  "outputs/report_assets"
)

invisible(lapply(dirs, dir.create, showWarnings = FALSE))
getwd()
# -----------------------------------------------------
# 3. Load Data
# -----------------------------------------------------

df <-mental_health_digital_behavior_data

# -----------------------------------------------------
# 4. Initial Inspection
# -----------------------------------------------------

cat("====================================\n")
cat("DATASET OVERVIEW\n")
cat("====================================\n")

cat("Rows:", nrow(df), "\n")
cat("Columns:", ncol(df), "\n\n")

str(df)

# -----------------------------------------------------
# 5. Missing Values Check
# -----------------------------------------------------

missing_values <- data.frame(
  Variable = names(df),
  Missing_Count = colSums(is.na(df)),
  Missing_Percentage =
    round(colSums(is.na(df)) / nrow(df) * 100, 2)
)

print(missing_values)

write.csv(
  missing_values,
  "outputs/tables/missing_values.csv",
  row.names = FALSE
)

# -----------------------------------------------------
# 6. Duplicate Records Check
# -----------------------------------------------------

duplicate_count <- sum(duplicated(df))

cat("\n")
cat("Duplicate Rows:", duplicate_count, "\n")

# -----------------------------------------------------
# 7. Data Types
# -----------------------------------------------------

data_types <- data.frame(
  Variable = names(df),
  Data_Type = sapply(df, class)
)

write.csv(
  data_types,
  "outputs/tables/data_types.csv",
  row.names = FALSE
)

# -----------------------------------------------------
# 8. Summary Statistics
# -----------------------------------------------------

summary_stats <- data.frame(
  Variable = names(df),
  
  Mean =
    round(sapply(df, mean, na.rm = TRUE), 2),
  
  SD =
    round(sapply(df, sd, na.rm = TRUE), 2),
  
  Min =
    round(sapply(df, min, na.rm = TRUE), 2),
  
  Median =
    round(sapply(df, median, na.rm = TRUE), 2),
  
  Max =
    round(sapply(df, max, na.rm = TRUE), 2)
)

print(summary_stats)

write.csv(
  summary_stats,
  "outputs/tables/summary_statistics.csv",
  row.names = FALSE
)

# -----------------------------------------------------
# 9. Data Quality Report
# -----------------------------------------------------

sink("outputs/report_assets/data_quality_report.txt")

cat("====================================\n")
cat("DATA QUALITY REPORT\n")
cat("====================================\n\n")

cat("Rows:", nrow(df), "\n")
cat("Columns:", ncol(df), "\n\n")

cat("Duplicate Rows:", duplicate_count, "\n\n")

cat("Missing Values:\n")
print(missing_values)

cat("\n\nSummary Statistics:\n")
print(summary_stats)

sink()

# -----------------------------------------------------
# 10. Phase 1 Completion Message
# -----------------------------------------------------

cat("\n====================================\n")
cat("PHASE 1 COMPLETED SUCCESSFULLY\n")
cat("====================================\n")

cat("\nGenerated Files:\n")

cat("- outputs/tables/missing_values.csv\n")
cat("- outputs/tables/data_types.csv\n")
cat("- outputs/tables/summary_statistics.csv\n")
cat("- outputs/report/data_quality_report.txt\n")