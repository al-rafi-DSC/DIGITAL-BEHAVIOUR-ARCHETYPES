library(tidyverse)
library(corrplot)
library(gridExtra)

# =====================================================
# 2.1 UNIVARIATE ANALYSIS
# =====================================================

p1 <- ggplot(df, aes(daily_screen_time_min)) +
  geom_histogram(
    bins = 30,
    fill = "steelblue",
    color = "black"
  ) +
  labs(
    title = "Daily Screen Time Distribution",
    x = "Minutes",
    y = "Count"
  ) +
  theme_minimal()

p2 <- ggplot(df, aes(sleep_hours)) +
  geom_histogram(
    bins = 30,
    fill = "forestgreen",
    color = "black"
  ) +
  labs(
    title = "Sleep Hours Distribution",
    x = "Hours",
    y = "Count"
  ) +
  theme_minimal()

p3 <- ggplot(df, aes(anxiety_level)) +
  geom_histogram(
    bins = 30,
    fill = "tomato",
    color = "black"
  ) +
  labs(
    title = "Anxiety Level Distribution",
    x = "Anxiety",
    y = "Count"
  ) +
  theme_minimal()

p4 <- ggplot(df, aes(digital_wellbeing_score)) +
  geom_histogram(
    bins = 30,
    fill = "goldenrod",
    color = "black"
  ) +
  labs(
    title = "Digital Wellbeing Distribution",
    x = "Wellbeing Score",
    y = "Count"
  ) +
  theme_minimal()

png( "outputs/figures/distributions.png", width = 1400, height = 1000, res = 150 ) 
grid.arrange(p1, p2, p3, p4, ncol = 2)
dev.off()

# =====================================================
# 2.2 Boxplot
# =====================================================

p_box <- df %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Value"
  ) %>%
  ggplot(aes(x = Variable, y = Value)) +
  geom_boxplot() +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Boxplots of All Variables"
  )

ggsave(
  "outputs/figures/boxplots.png",
  p_box,
  width = 10,
  height = 7
)


# =====================================================
# 2.3 Correlation Matrix
# =====================================================

cor_matrix <- cor(df)

png(
  "outputs/figures/correlation_matrix.png",
  width = 1200,
  height = 1000,
  res = 150
)

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.cex = 0.8,
  number.cex = 0.7
)

dev.off()

# =====================================================
# 2.4 Bivariate Analysis
# =====================================================
p_screen_wellbeing <- ggplot(
  df,
  aes(
    daily_screen_time_min,
    digital_wellbeing_score
  )
) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal() +
  labs(
    title = "Screen Time vs Digital Wellbeing",
    x = "Daily Screen Time (min)",
    y = "Wellbeing Score"
  )

ggsave(
  "outputs/figures/screen_time_vs_wellbeing.png",
  p_screen_wellbeing,
  width = 8,
  height = 6
)

# =====================================================
#  Social Media vs Anxety
# =====================================================
p_social_anxiety <- ggplot(
  df,
  aes(
    social_media_time_min,
    anxiety_level
  )
) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal() +
  labs(
    title = "Social Media Time vs Anxiety",
    x = "Social Media Time (min)",
    y = "Anxiety Level"
  )

ggsave(
  "outputs/figures/social_media_vs_anxiety.png",
  p_social_anxiety,
  width = 8,
  height = 6
)

# =====================================================
#  Sleep vs Wellbing
# =====================================================

#Creating Categories
df$sleep_category <- cut(
  df$sleep_hours,
  breaks = quantile(
    df$sleep_hours,
    probs = seq(0, 1, 0.25),
    na.rm = TRUE
  ),
  include.lowest = TRUE,
  labels = c(
    "Very Low",
    "Low",
    "High",
    "Very High"
  )
)

#Plot the Categories
p_sleep <- ggplot(
  df,
  aes(
    sleep_category,
    digital_wellbeing_score
  )
) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Sleep Category vs Wellbeing"
  )

ggsave(
  "outputs/figures/sleep_vs_wellbeing.png",
  p_sleep,
  width = 8,
  height = 6
)


# =====================================================
# 2.5 Correlation Table
# =====================================================
correlations <- data.frame(
  Variable = names(df)[1:9],
  Correlation_With_Wellbeing =
    round(
      cor(
        df[,1:9],
        df$digital_wellbeing_score
      )[,1],
      3
    )
)

write.csv(
  correlations,
  "outputs/tables/correlation_table.csv",
  row.names = FALSE
)


# =====================================================
# 2.6 EDA Report
# =====================================================
sink("outputs/report_assets/eda_summary.txt")

cat("====================================\n")
cat("EDA SUMMARY\n")
cat("====================================\n\n")

cat("Correlation Matrix Generated\n")
cat("Distribution Plots Generated\n")
cat("Bivariate Analysis Completed\n")

sink()