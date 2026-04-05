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
charges_plot
save_plot("insurance_charges_distribution.png", charges_plot)

log_charges_plot <- 
	ggplot(df, aes(x=log(annual_premium))) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of Insurance Charges", x="Log Charges (USD)", y="Density")
log_charges_plot
save_plot("log_insurance_charges_distribution.png", log_charges_plot)

age_plot <- 
	ggplot(df, aes(x=age)) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of age of Subjects", x="Age (years)", y="Density")
age_plot
save_plot("age_distribution.png", age_plot)

bmi_plot <- 
	ggplot(df, aes(x=bmi)) + 
	geom_histogram(aes(y=after_stat(density))) + 
	labs(title="Distribution of BMI of Subjects", x="Body Mass Index (BMI)", y="Density")
bmi_plot
save_plot("bmi_distribution.png", bmi_plot)

# 2.2 - Explore Bivariate (sex)
log_sex_plot <- 
	ggplot(df, aes(x=age, y=log(annual_premium), fill=sex)) + 
	geom_boxplot(alpha=0.7, outlier.size=0.8) + 
	labs(title="Log Annual Insurance Premium by sex", x="Sex", y="Log Annual Insurance Premium (USD)")
log_sex_plot
save_plot("log_insurance_charges_vs_sex_distribution.png", log_sex_plot)

# 2.3 - Explore variables among the sexes
age_vs_sex_plot <- 
  ggplot(df, aes(x=age, y=sex, color=sex)) +
  geom_boxplot(alpha=0.7, outlier.size=0.8) +
	labs(title="Age Vs. Sex", x="sex", y="Age (Years)")
age_vs_sex_plot
save_plot("age_vs_sex_distribution.png", age_vs_sex_plot)

age_vs_log_charges_plot <-
  ggplot(df, aes(x=age, y=log(annual_premium), color=sex)) +
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="Age Vs. Log Charges", x="Age (Years)", y="Log Charges (USD)")
age_vs_log_charges_plot
save_plot("age_vs_log_charges_distribution.png", age_vs_log_charges_plot)

age_vs_charges_plot <-
  ggplot(df, aes(x=age, y=annual_premium, color=sex)) +
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="BMI Vs. Charges", x="Age (Years)", y="Charges (USD)")
age_vs_charges_plot
save_plot("age_vs_charges_distribution.png", age_vs_log_charges_plot)

bmi_vs_sex_plot <- 
	ggplot(df, aes(x=sex, y=bmi, color=sex)) + 
  geom_boxplot(alpha = 0.7, outlier.size = 0.8) +
	labs(title="BMI Vs. Sex", x="sex", y="BMI (kg/m^2)")
bmi_vs_sex_plot
save_plot("bmi_vs_sex_distribution.png", bmi_vs_sex_plot)

bmi_vs_log_charges_plot <-
	ggplot(df, aes(x=bmi, y=log(annual_premium), color=sex)) + 
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="BMI Vs. Log Charges", x="BMI (kg/m^2)", y="Log Charges (USD)")
bmi_vs_log_charges_plot
save_plot("bmi_vs_log_charges_distribution.png", bmi_vs_log_charges_plot)

# Plot risk vs log charges
risk_vs_log <-
	ggplot(df, aes(x=risk_score, y=log(annual_premium), color=sex)) + 
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="Risk Score Vs. Log Charges", x="Risk Score", y="Log Charges (USD)")
risk_vs_log
save_plot("risk_vs_logtotal.png", risk_vs_log)

# Plot total claims paid
huh_vs_log <-
	ggplot(df, aes(x=log(total_claims_paid), y=log(annual_premium - min(annual_premium)), color=sex)) + 
  geom_point(alpha = 0.2, size = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
	labs(title="Log Total Claims Paid Vs. Log Charges", x="Total Claims Paid (log USD)", y="Log Charges (log USD)")
huh_vs_log
save_plot("logclaimspaid_vs_logtotal.png", huh_vs_log)


# 2.4 - Linear regression 

# ------------- MODEL SELECTION ---------------------

# Full model
# We are transforming annual premium to be log annual premium above baseline
# We are transforming total claims paid to log total claims paid
# We are including interaction between sex and risk score
mfull <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age + bmi + risk_score + log(total_claims_paid + 1) + sex:risk_score, data=df)
summary(mfull)
# 6 covariates, 7 coefficients

# Look at qq and residuals for full model to ensure assumptions hold
qqnorm(residuals(mfull), main = "Normal Q-Q Plot for Full Model")
qqline(residuals(mfull), col = "red")
# Residuals
residual_plot <- ggplot() +
  geom_point(aes(x=mfull$fitted.values, y=mfull$residuals), alpha = 0.2, size = 0.6) +
  labs(title="Residuals vs Fitted Values for Full Model", x="Fitted Values", y="Residuals")
residual_plot

# Start calculating C_p 
n <- nrow(df)
ms_res_q <- sum(mfull$residuals ^ 2) / ( n - (6 + 1) )
cp_6_1 <- sum(mfull$residuals ^ 2) / ms_res_q - (n - 2 * (6 + 1))

# Interaction between risk and sex removed, p = 5
m5_1 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age + bmi + risk_score + log(total_claims_paid + 1), data=df)
cp_5_1 <- sum(m5_1$residuals ^ 2) / ms_res_q - (n - 2 * (5 + 1))

# Total claims paid removed, p = 4
m4_2 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age + bmi + risk_score, data=df)
cp_4_2 <- sum(m4_2$residuals ^ 2) / ms_res_q - (n - 2 * (4 + 1))

# Risk score removed, p = 4
m4_1 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age + bmi + log(total_claims_paid + 1), data=df)
cp_4_1 <- sum(m4_1$residuals ^ 2) / ms_res_q - (n - 2 * (4 + 1))

# Total claims paid removed, p = 3
m3_1 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age + bmi, data=df)
cp_3_1 <- sum(m3_1$residuals ^ 2) / ms_res_q - (n - 2 * (3 + 1))

# Bmi removed, p = 2
m2_1 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + age, data=df)
cp_2_1 <- sum(m2_1$residuals ^ 2) / ms_res_q - (n - 2 * (2 + 1))

# Age removed, p = 1
m1_1 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex, data=df)
cp_1_1 <- sum(m1_1$residuals ^ 2) / ms_res_q - (n - 2 * (1 + 1))

png("latex/images/mallows.png", width = 800, height = 600)
plot(c(6, 5, 4, 3, 2, 1, 0), log(c(cp_6_1, cp_5_1, cp_4_1, cp_3_1, cp_2_1, cp_1_1, 1)), xlab = "Number of Covariates", ylab = "Log Mallow's Statistic (Cp)")
segments(x0 = 0, y0 = 0, x1 = 6, y1 = log(6), col = "blue", lwd = 2)
dev.off()


# ----------- END MODEL SELECTION -------------------

# Would have chosen more descriptive names but Stargazer has issues with long names for some reason
m1 <- lm(log(annual_premium) ~ sex, data=df)
m2 <- lm(log(annual_premium) ~ sex + age + bmi, data=df)
m1nolog <- lm(annual_premium ~ sex, data=df)
m2nolog <- lm(annual_premium ~ sex + age + bmi, data=df)
# Assess model fit for m2. Clearly not so good.
ggplot() +
  geom_point(aes(x=m2$fitted.values, y=m2$residuals), alpha = 0.2, size = 0.6) +
  labs(title="Residuals vs Fitted Values", x="Fitted Values", y="Residuals")

# Q-Q Plots for early models
qqnorm(residuals(m2), main = "Normal Q-Q Plot for Log Model")
qqline(residuals(m2), col = "red")
qqnorm(residuals(m2nolog), main = "Normal Q-Q Plot for Non-log Model")
qqline(residuals(m2nolog), col = "red")


# Better model now
#mrisk <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + risk_score + log(total_claims_paid + 1), data=df)
mrisk2 <- lm(log(annual_premium - min(annual_premium) + 1) ~ sex + risk_score + log(total_claims_paid + 1) + age + bmi, data=df)
summary(mrisk2)

# Check assumptions
#qqnorm(residuals(mrisk), main = "Q-Q Plot for Improved Model")
#qqline(residuals(mrisk), col="red")

png("latex/images/qqplot.png", width = 800, height = 600)
qqnorm(residuals(mrisk2), main = "Q-Q Plot for Model")
qqline(residuals(mrisk2), col="red")
dev.off()


# Examine residuals, still off
#ggplot() +
#  geom_point(aes(x=mrisk$fitted.values, y=mrisk$residuals), alpha = 0.2, size = 0.6) +
#  labs(title="Residuals vs Fitted Values for Improved Model", x="Fitted Values", y="Residuals")
residual_plot <- ggplot() +
  geom_point(aes(x=mrisk2$fitted.values, y=mrisk2$residuals), alpha = 0.2, size = 0.6) +
  labs(title="Residuals vs Fitted Values for Model", x="Fitted Values", y="Residuals")
residual_plot
save_plot("mrisk_residuals.png", residual_plot)

if (file.exists("latex/tables/regression_table.tex")) file.remove("tables/regression_table.tex")
if (!dir.exists("latex")) dir.create("latex")
if (!dir.exists("latex/tables")) dir.create("latex/tables")
file.create("latex/tables/regression_table.tex")
table_lines <- capture.output(
  stargazer(m1, m2, mrisk2,
            type="latex",
            title="Staged Linear Regression Results",
            covariate.labels=c("Sex (Male)", "Age (Years)", "BMI (kg/m$^2$)", "Risk Score", "Log(Claims Paid)"),
            column.labels=c("Sex Only", "Demographics", "Risk & Claims"),
            model.numbers=FALSE,
						dep.var.labels = "Log(Claims Paid)",
						omit.table.layout = "d",
            star.cutoffs=c(0.05, 0.01, 0.001),
            digits=4,
            no.space=TRUE,
						out.header = FALSE
  )
)

writeLines(table_lines, "latex/tables/regression_table.tex")


print("Success!")
