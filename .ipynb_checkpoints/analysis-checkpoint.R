library(ggplot2)
library(stargazer)

# Extract the data, discarding non-binary subjects
df <- read.csv("data/medical_insurance.csv")
df <- df[df$sex %in% c("Female", "Male"), ]

# Helper for saving files to disk with a consistent size
save_plot <- function(filename, plot) {
	ggsave(paste0("latex/images/", filename), plot, width=7, height=4.5, dpi=150)
}

# 2.1 - Explore variables in isolation
charges_plot <- 
	ggplot(df, aes(x=annual_premium)) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of Insurance Charges", x="Charges (USD)", y="Density")
save_plot("insurance_charges_distribution.png", charges_plot)

log_charges_plot <- 
	ggplot(df, aes(x=log(annual_premium))) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of Insurance Charges", x="Log Charges (USD)", y="Density")
save_plot("log_insurance_charges_distribution.png", log_charges_plot)

age_plot <- 
	ggplot(df, aes(x=age)) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of age of Subjects", x="Age (years)", y="Density")
save_plot("age_distribution.png", age_plot)

bmi_plot <- 
	ggplot(df, aes(x=age)) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of BMI of Subjects", x="Body Mass Index (BMI)", y="Density")
save_plot("bmi_distribution.png", bmi_plot)

# 2.2 - Explore Bivariate (sex)
log_sex_plot <- 
	ggplot(df, aes(x=age, y=log(annual_premium), fill=sex)) + 
	geom_boxplot(alpha = 0.7, outlier.size = 0.8) + 
	labs(title="Log Annual Insurance Premium by sex", x="Sex", y="Log Annual Insurance Premium (USD)")
save_plot("log_insurance_charges_vs_sex_distribution.png", log_sex_plot)

# 2.3 - Explore variables among the sexes
age_vs_sex_plot <- 
  ggplot(df, aes(x=age, y=log(annual_premium), color=sex)) +
  geom_boxplot(alpha = 0.7, outlier.size = 0.8) +
	labs(title="Age Vs. Sex", x="sex", y="Age (Years)")
save_plot("age_vs_sex_distribution.png", age_vs_sex_plot)

age_vs_log_charges_plot <-
  ggplot(df, aes(x=bmi, y=log(annual_premium), color=sex)) +
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="Age Vs. Log Charges", x="Age (Years)", y="Log Charges (USD)")
save_plot("age_vs_log_charges_distribution.png", age_vs_log_charges_plot)

bmi_vs_sex_plot <- 
	ggplot(df, aes(x=sex, y=bmi, color=sex)) + 
  geom_boxplot(alpha = 0.7, outlier.size = 0.8) +
	labs(title="Age Vs. Sex", x="sex", y="BMI (kg/m^2)")
save_plot("bmi_vs_sex_distribution.png", bmi_vs_sex_plot)

bmi_vs_log_charges_plot <-
	ggplot(df, aes(x=bmi, y=log(annual_premium), color=sex)) + 
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="BMI Vs. Log Charges", x="BMI (kg/m^2)", y="Log Charges (USD)")
save_plot("bmi_vs_log_charges_distribution.png", bmi_vs_log_charges_plot)

# 2.4 - Linear regression 
# Would have chosen more descriptive names but Stargazer has issues with long names for some reason
m1 <- lm(log(annual_premium) ~ sex, data=df)
m2 <- lm(log(annual_premium) ~ sex + age + bmi, data=df)


if (file.exists("latex/tables/regression_table.tex")) file.remove("tables/regression_table.tex")
table_lines <- capture.output(
  stargazer(m1, m2,
    type="latex",
    title="Staged Linear Regression Results",
    covariate.labels=c("Sex", "Age (Years)", "BMI (kg/m$^2$)"),
    column.labels=c("Sex Model", "Sex + Age + BMI"),
    model.numbers=FALSE,
    star.cutoffs=c(0.05, 0.01, 0.001),
    digits=4,
    no.space=TRUE
  )
)

writeLines(table_lines, "latex/tables/regression_table.tex")


print("Success!")
