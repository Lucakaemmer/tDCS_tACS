library(tidyverse)
library(ggpubr)
library(rstatix)
library(ggplot2)

stats_data = read.csv("/Users/lucakammer/Documents/GitHub/tDCS_tACS/data_analysis/data/stats_data.csv", header=FALSE)
colnames(stats_data) = c("subject", "treatment", "run", "accuracy")


### Summary Statistics ###
stats_data %>%
  group_by(treatment, run) %>%
  get_summary_stats(accuracy, type = "mean_sd")

# Outliers
stats_data %>%
  group_by(treatment, run) %>%
  identify_outliers(accuracy)

# Normality
stats_data %>%
  group_by(treatment, run) %>%
  shapiro_test(accuracy)



### Factorisazion of variables for later analysis ###
col_names <- c("subject", "treatment", "run")
stats_data[,col_names] <- lapply(stats_data[,col_names] , factor)
str(stats_data)


### Visualization ###
bxp <- ggboxplot(
  stats_data, x = "run", y = "accuracy",
  color = "treatment", palette = "jco",
)
bxp



### ANOVA ###

res.aov <- anova_test(
  data = stats_data, dv = accuracy, wid = subject,
  within = c(treatment, run)
)
get_anova_table(res.aov)


### Post-hoc ###

# Effect of treatment in each run
one.way <- stats_data %>%
  group_by(run) %>%
  anova_test(dv = accuracy, wid = subject, within = treatment) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")
one.way

# Pairwise comparisons between treatment groups
pwc <- stats_data %>%
  group_by(run) %>%
  pairwise_t_test(
    accuracy ~ treatment, paired = TRUE,
    p.adjust.method = "bonferroni"
  )
pwc




