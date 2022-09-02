library(tidyverse)
library(AER)
library(skimr)
library(estimatr)
library(huxtable)
library(kableExtra)
library(ftExtra)
library(modelsummary)
library(knitr)
library(revealjs)
library(palmerpenguins)


# データの読み込み----------------

data("CollegeDistance")

#View(CollegeDistance)

#CollegeDistance$ethnicity %>% unique() # その列に含まれる要素を表示

CollegeDistance <- CollegeDistance %>%
  mutate(
    univ = if_else(education >= 16, "Yes", "No"),
    high_income = if_else(income == "high", 1, 0),
  ) # 新しい変数を定義

# 記述統計量の作成
## summarise関数を利用

CollegeDistance %>%
  group_by(univ) %>%
  summarise(
    N = n(),
    hispanic = sum(ethnicity == "hispanic", na.rm = T) / n() * 100,
    african_american = sum(ethnicity == "afam", na.rm = T) / n() * 100,
    fcollege =  sum(fcollege == "yes", na.rm = T) / n() * 100,
    mcollege =  sum(mcollege == "yes", na.rm = T) / n() * 100,
  ) -> status_sum


## huxtableパッケージを使ってデータフレームをExcelファイルに

summary_table <- huxtable(status_sum)

summary_table

#quick_xlsx(summary_table, file = "college_sum.xlsx")

## t検定

CD_split <- CollegeDistance %>%
  split(pull(., univ)) # 大卒か否かでサンプルを分割

t.test(CD_split[["No"]]$score, CD_split[["Yes"]]$score)

# 高卒のサンプルと大卒のサンプルとで、score: テストの点数に差があるかを検定

## skim変数を使った要約

factor <- CollegeDistance %>%
  skim() %>%
  yank("factor")

factor

## kable関数を使って綺麗な表を出力

CollegeDistance %>%
  group_by(univ) %>%
  skim() %>%
  yank("numeric") %>%
  select(skim_variable, univ, mean, sd) %>%
  pivot_wider(names_from = univ, values_from = c('mean', 'sd')) %>%
  select(1, 3, 5, 2, 4) %>%
  kable(format = "html", 
        booktabs = TRUE,
        col.names = c('変数', '平均', '標準偏差',
                      '平均', '標準偏差'),
        digits = 2) %>%
  kableExtra::add_header_above(
    c(" ", "大卒" = 2, 
      "高卒" = 2)) %>%
  kable_styling() %>%
  print()

# 回帰分析 -------------------------------

CollegeDistance %>%
  lm_robust(high_income ~ education, data = .) %>%
  summary() # とりあえず結果を見たい場合はこれ

model1 <- CollegeDistance %>%
  lm_robust(high_income ~ education, data = .)

model2 <- CollegeDistance %>%
  lm_robust(high_income ~ education + score, data = .)

model3 <- CollegeDistance %>%
  lm_robust(high_income ~ education + score + ethnicity, data = .)

summary(model3)

## huxtableを使った出力

huxreg(model1, model2, model3)


table <- huxreg( # 回帰式を
  model1, model2, model3,
  statistics = c(
    '# observations' = 'nobs', 'R squared' = 'r.squared',
    'F statistic' = 'statistic','P value' = 'p.value'
  ), # 表示する統計量の選択
  stars = c(`***` = 0.001, `**` = 0.01, `*` = 0.05)
  # 有意水準の設定
)

table

#quick_pptx(table, file = "tab/college_regression.pptx") # quick_〇〇関数で保存

quick_xlsx(table, file = "tab/college_regression.xlsx")


## modelsummary

table_list <- list("(1)" = model1, "(2)" = model2, "(3)" = model3)

msummary(table_list)
#msummary(table_list, output = "tab/college_reg.docx")

tab <- msummary(table_list, output = "huxtable") # huxtableでの出力を嚙ませればexcelにも出力可能
#quick_xlsx(tab, file = "tab/college_reg.xlsx")

msummary(table_list)

gof_map

gof_shown <- tribble(
  ~raw,        ~clean,          ~fmt,
  "nobs",      "N",             0,
  "r.squared", "R2", 2,
  "adj.r.squared", "adj. R2", 2,
  "statistic", "F", 3,
  )

msummary(
  table_list,
  gof_map = gof_shown,
  escape = FALSE
)

# 固定効果モデル ------------------------------

penguins %>%
  lm_robust(body_mass_g ~ flipper_length_mm + sex, fixed_effects = island + species, data = .) %>%
  summary()

# ロジスティック回帰---------------------------

logit <- glm(formula = high_income ~ education + distance + ethnicity, data = CollegeDistance, family = binomial(link = "logit"))
probit <- glm(formula = high_income ~ education + distance + ethnicity, data = CollegeDistance, family = binomial(link = "probit"))
summary(logit)

huxreg(logit)

logit$coefficients

fitted_values <- predict(logit, type = 'response') # 推定したモデルでの予測値(X_i \beta)

avgPred <- mean(fitted_values)
AME <- avgPred * coef(logit)
AME

fitted_values <- predict(probit, type = 'link') # 推定したモデルでの予測値(X_i \beta)

avgPred <- mean(dnorm(fitted_values))
AME <- avgPred * coef(probit)
AME

# 操作変数法-------------------------

# distance: 教育年数

model4 <- CollegeDistance %>%
  iv_robust(formula = high_income ~ education | distance, data = .)

model5 <- CollegeDistance %>%
  iv_robust(formula = high_income ~ education | distance + ethnicity + tuition + score, data = .)

table_list2 <- list("(1)" = model4, "(2)" = model5, "OLS" = model3)

msummary(table_list2)

gof_shown <- tribble(
  ~raw,        ~clean,          ~fmt,
  "nobs",      "N",             0,
  "r.squared", "R2", 2,
  "adj.r.squared", "adj. R2", 2,
  "statistic", "F-value", 2,
  "statistic.Weak.instrument", "Weak IV", 2
)

msummary(
  table_list2,
  gof_map = gof_shown,
  escape = FALSE
)
