# =============================================================================
#  THE CORNER CUP COFFEE CHAIN
#  Part C - Regression & Probability (R)
# -----------------------------------------------------------------------------
#  Course : Statistics and Predictive Analytics for Decision-Making
#  Task   : Group Work 1, Part C (C1 Simple Linear Regression, C2 Probability)
#  Group  : Fathima Mufliha Kottaparamban, Aaliya Kaunain Mustafa Baig, Shubhangi Dubey, Shruti Chalke, Azra Lokhandwala
#  Date   : 11/11/2026
# -----------------------------------------------------------------------------
#  HOW TO RUN (RStudio)
#   1. Put this script and the data file in the SAME folder.
#   2. Session > Set Working Directory > To Source File Location.
#   3. Click "Source" (or select everything and press Ctrl + Enter).
#   Charts appear in the Plots pane and are also saved as PNG files
#   (C1_regression_plot.png, C2_binomial_plot.png, C2_poisson_plot.png).
#
#  Uses base R only: no packages need to be installed.
# =============================================================================


# ---- 0. SETUP ---------------------------------------------------------------

# House colours: the same as our Excel and Python charts
URBAN    <- "#76923C"   # green = Urban shops
SUBURBAN <- "#C0504D"   # red   = Suburban shops
ACCENT   <- "#953735"   # dark red for titles and highlights
NEUTRAL  <- "#7F7F7F"   # grey

# Small helper to print a section heading in the Console
heading <- function(text) {
  cat("\n", strrep("=", 70), "\n ", text, "\n", strrep("=", 70), "\n", sep = "")
}

# Load the data (accepts either name the course file may have)
data_file <- c("GW1_CornerCup_Data.csv", "GW1_CornerCup_Data1.csv")
data_file <- data_file[file.exists(data_file)][1]
if (is.na(data_file)) {
  stop("Data file not found. Use Session > Set Working Directory > To Source File Location.")
}
data <- read.csv(data_file)

heading("DATA CHECK")
cat("File loaded:", data_file, "\n")
cat("Shops (rows):", nrow(data), " | Variables (columns):", ncol(data), "\n\n")
print(head(data))


# =============================================================================
#  C1. SIMPLE LINEAR REGRESSION
#      Can we predict Monthly Revenue ($000) from Daily Customers?
# =============================================================================

# ---- C1.1 Fit the model -------------------------------------------------------
# lm(y ~ x): y = Monthly_Revenue_000 (what we predict), x = Daily_Customers (predictor)
model <- lm(Monthly_Revenue_000 ~ Daily_Customers, data = data)

heading("C1. REGRESSION MODEL SUMMARY")
print(summary(model))

# ---- C1.2 Pull out the key numbers -------------------------------------------
b0 <- unname(coef(model)[1])           # intercept
b1 <- unname(coef(model)[2])           # slope
r2 <- summary(model)$r.squared         # R-squared
r  <- cor(data$Daily_Customers, data$Monthly_Revenue_000)
p_slope <- summary(model)$coefficients[2, 4]

heading("C1. KEY RESULTS")
cat(sprintf("Intercept (b0)        = %8.4f\n", b0))
cat(sprintf("Slope (b1)            = %8.4f\n", b1))
cat(sprintf("Correlation (r)       = %8.4f\n", r))
cat(sprintf("R-squared (R^2)       = %8.4f  (%.1f%% of the variation in revenue)\n", r2, r2 * 100))
cat(sprintf("p-value of the slope  = %8.6f\n", p_slope))
cat(sprintf("\nRegression equation:  Revenue_hat = %.3f + %.4f x Daily_Customers\n", b0, b1))

# ---- C1.3 Prediction for a new shop with 300 customers per day ---------------
new_shop <- data.frame(Daily_Customers = 300)
pred     <- predict(model, new_shop)
pred_int <- predict(model, new_shop, interval = "prediction", level = 0.95)

heading("C1. PREDICTION FOR 300 CUSTOMERS PER DAY")
cat(sprintf("Step 1: Revenue_hat = b0 + b1 x 300\n"))
cat(sprintf("Step 2: Revenue_hat = %.4f + %.4f x 300\n", b0, b1))
cat(sprintf("Step 3: Revenue_hat = %.4f + %.4f\n", b0, b1 * 300))
cat(sprintf("Result: Revenue_hat = %.2f  ->  about $%s per month\n",
            pred, format(round(pred * 1000), big.mark = ",")))
cat(sprintf("95%% prediction interval: %.1f to %.1f ($000)\n", pred_int[2], pred_int[3]))


# ---- C1.4 Scatter plot with the regression line -------------------------------
draw_regression_plot <- function() {
  par(mar = c(5, 5, 4, 2), las = 1)                       # margins, horizontal labels
  shop_col <- ifelse(data$Location_Type == "Urban", URBAN, SUBURBAN)
  plot(data$Daily_Customers, data$Monthly_Revenue_000,
       main = "Daily Customers vs Monthly Revenue",
       xlab = "Average Daily Customers", ylab = "Monthly Revenue ($000)",
       pch = 19, cex = 1.8, col = shop_col, col.main = ACCENT,
       xlim = c(140, 460), ylim = c(25, 140), bty = "l")
  grid(col = "grey90", lty = 1)                           # light background grid
  abline(model, col = ACCENT, lwd = 2.5)                  # regression line
  points(300, pred, pch = 4, cex = 2, lwd = 3, col = "black")   # prediction at 300
  text(300, pred - 9, sprintf("300 customers -> %.1f", pred), pos = 4, cex = 0.8)
  legend("topleft", bty = "n",
         legend = c("Urban", "Suburban", "Regression line", "Prediction (x = 300)"),
         col = c(URBAN, SUBURBAN, ACCENT, "black"),
         pch = c(19, 19, NA, 4), lty = c(NA, NA, 1, NA), lwd = c(NA, NA, 2.5, 3))
  mtext(sprintf("Revenue = %.2f + %.4f x Customers   |   R-squared = %.3f", b0, b1, r2),
        side = 3, line = 0.3, cex = 0.85, col = "grey30")
}
draw_regression_plot()                                     # show in RStudio
png("C1_regression_plot.png", width = 1800, height = 1200, res = 200)
draw_regression_plot(); invisible(dev.off())               # save for the report

# ---- C1.5 Interpretation ------------------------------------------------------
# * Equation: Revenue = -2.785 + 0.2760 x Daily_Customers.
# * Slope (b1 = 0.276): each extra daily customer adds about $276 to monthly
#   revenue (0.276 thousand dollars), so 100 more customers a day is about $27,600.
# * Intercept (b0 = -2.785): the revenue for a shop with zero customers. It has no
#   real meaning here, because no shop has close to zero customers.
# * R-squared = 0.768: daily customers explain about 77% of the variation in
#   monthly revenue. This is a strong relationship (r = 0.877), and the slope is
#   statistically significant (p < 0.001).
# * About 23% of the variation is left to other factors, mainly average spend per
#   customer: e.g. Airport Terminal has the most customers (441) but the lowest
#   spend ($6.90), so it sits well below the line.
# * Prediction: a new shop with 300 customers a day is expected to earn about
#   $80,000 a month (80.02 in $000). With only 12 shops, the 95% prediction
#   interval is wide (47.3 to 112.7), so this is an estimate, not a guarantee.


# =============================================================================
#  C2. PROBABILITY ANALYSIS
# =============================================================================

# ---- Question 1: P(a random shop earns more than $80,000 per month) ----------
heading("C2 - QUESTION 1: P(Revenue > $80K)")
high      <- data$Monthly_Revenue_000 > 80         # TRUE / FALSE for each shop
n_high    <- sum(high)                             # TRUE counts as 1
n_total   <- nrow(data)
p_high    <- n_high / n_total

cat("Step 1: Revenue is in $000, so $80,000 = 80.\n")
cat("Step 2: Shops with revenue > 80:\n")
print(data[high, c("Shop_Name", "Location_Type", "Monthly_Revenue_000")], row.names = FALSE)
cat(sprintf("Step 3: Count = %d shops out of %d\n", n_high, n_total))
cat(sprintf("Step 4: P(Revenue > 80) = %d / %d = %.4f  (%.1f%%)\n",
            n_high, n_total, p_high, p_high * 100))
# Interpretation: 4 of the 12 existing shops (1 in 3) are high-revenue shops,
# so the empirical probability is 0.333. Three of the four are Urban.


# ---- Question 2: Binomial distribution, 5 new suburban shops -----------------
#  X = number of high-revenue shops out of n = 5, each with p = 0.40
#  Conditions: fixed n, two outcomes (high / not high), same p, independent shops
n <- 5
p <- 0.40
heading("C2 - QUESTION 2: BINOMIAL  X ~ Bin(n = 5, p = 0.40)")

# (a) Expected number of high-revenue shops
expected <- n * p
cat(sprintf("(a) E(X) = n x p = %d x %.2f = %.1f shops\n", n, p, expected))
cat(sprintf("    Standard deviation = sqrt(n x p x (1 - p)) = %.4f\n", sqrt(n * p * (1 - p))))

# (b) P(exactly 2)
p_exactly2 <- dbinom(2, size = n, prob = p)
cat("\n(b) P(X = 2) = C(5,2) x 0.40^2 x 0.60^3\n")
cat(sprintf("           = %d x %.4f x %.4f\n", choose(5, 2), p^2, (1 - p)^3))
cat(sprintf("           = %.4f  (%.2f%%)   [R: dbinom(2, 5, 0.40)]\n",
            p_exactly2, p_exactly2 * 100))

# (c) P(at least 1) = 1 - P(none)
p_none    <- dbinom(0, size = n, prob = p)
p_atleast <- 1 - pbinom(0, size = n, prob = p)
cat("\n(c) P(X >= 1) = 1 - P(X = 0)\n")
cat(sprintf("            = 1 - 0.60^5 = 1 - %.5f\n", p_none))
cat(sprintf("            = %.4f  (%.2f%%)   [R: 1 - pbinom(0, 5, 0.40)]\n",
            p_atleast, p_atleast * 100))

cat("\nFull distribution of X:\n")
binom_table <- data.frame(X = 0:n, Probability = round(dbinom(0:n, n, p), 4))
print(binom_table, row.names = FALSE)

# Chart of the binomial distribution (P(X = 2) highlighted)
draw_binomial_plot <- function() {
  par(mar = c(5, 5, 4, 2), las = 1)
  bar_col <- ifelse(0:n == 2, ACCENT, "grey75")
  bp <- barplot(dbinom(0:n, n, p), names.arg = 0:n, col = bar_col, border = NA,
                ylim = c(0, 0.42), main = "Binomial Distribution: 5 New Suburban Shops",
                col.main = ACCENT, xlab = "Number of high-revenue shops (X)",
                ylab = "Probability")
  text(bp, dbinom(0:n, n, p), sprintf("%.3f", dbinom(0:n, n, p)), pos = 3, cex = 0.9)
  legend("topright", bty = "n", fill = ACCENT, border = NA, legend = "P(X = 2) = 0.3456")
}
draw_binomial_plot()
png("C2_binomial_plot.png", width = 1600, height = 1100, res = 200)
draw_binomial_plot(); invisible(dev.off())

# Interpretation: Maya should expect about 2 of the 5 new shops to become
# high-revenue. There is a 34.6% chance that exactly 2 do, and a 92.2% chance
# that at least one does, so it is very likely (but not certain) that the
# expansion produces at least one high-revenue shop.


# ---- Question 3: Poisson distribution, Airport Terminal customers per hour ---
#  X = customers arriving in one hour, average lambda = 18
#  (441 customers / 24 hours = 18.4, rounded to 18 in the brief)
lambda <- 18
heading("C2 - QUESTION 3: POISSON  X ~ Poisson(lambda = 18)")

# (d) P(exactly 20 customers in one hour)
p20 <- dpois(20, lambda)
cat("(d) P(X = 20) = e^(-18) x 18^20 / 20!\n")
cat(sprintf("            = %.4f  (%.2f%%)   [R: dpois(20, 18)]\n", p20, p20 * 100))

# (e) P(25 or more customers in one hour) = 1 - P(X <= 24)
p25plus <- 1 - ppois(24, lambda)
cat("\n(e) P(X >= 25) = 1 - P(X <= 24)\n")
cat(sprintf("             = 1 - %.4f\n", ppois(24, lambda)))
cat(sprintf("             = %.4f  (%.2f%%)   [R: 1 - ppois(24, 18)]\n", p25plus, p25plus * 100))
cat(sprintf("    About %.1f busy hours (25+ customers) in a 24-hour day.\n", p25plus * 24))

# (f) Mean and standard deviation
cat("\n(f) For a Poisson distribution, mean = variance = lambda\n")
cat(sprintf("    Expected customers per hour  E(X) = lambda = %d\n", lambda))
cat(sprintf("    Standard deviation           SD   = sqrt(18) = %.4f\n", sqrt(lambda)))

# Chart of the Poisson distribution (X = 20 and X >= 25 highlighted)
draw_poisson_plot <- function() {
  par(mar = c(5, 5, 4, 2), las = 1)
  x_vals  <- 5:35
  bar_col <- ifelse(x_vals == 20, ACCENT, ifelse(x_vals >= 25, SUBURBAN, "grey75"))
  barplot(dpois(x_vals, lambda), names.arg = x_vals, col = bar_col, border = NA,
          main = "Poisson Distribution: Airport Terminal Customers per Hour",
          col.main = ACCENT, xlab = "Customers in one hour (X)", ylab = "Probability",
          cex.names = 0.75)
  legend("topright", bty = "n", border = NA, fill = c(ACCENT, SUBURBAN),
         legend = c(sprintf("P(X = 20) = %.4f", p20), sprintf("P(X >= 25) = %.4f", p25plus)))
}
draw_poisson_plot()
png("C2_poisson_plot.png", width = 1800, height = 1100, res = 200)
draw_poisson_plot(); invisible(dev.off())

# Interpretation: The Airport Terminal expects 18 customers an hour, typically
# varying by about 4 customers (SD = 4.24). Exactly 20 customers happens in about
# 8% of hours. A peak of 25 or more customers happens in about 6.8% of hours
# (roughly 1.6 hours a day), so Maya should plan extra staff for those peak periods.

heading("END OF PART C. Charts saved as PNG files in the working directory.")