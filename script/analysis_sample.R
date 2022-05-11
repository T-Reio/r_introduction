library(tidyverse)
library(AER)
library(skimr)
library(estimatr)
library(huxtable)
library(kableExtra)
library(ftExtra)
library(modelsummary)


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

saved <- huxtable(status_sum)

saved

#quick_xlsx(saved, file = "tab/college_sum.xlsx")

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

## huxtableを使った出力

huxreg(model1, model2, model3)


table <- huxreg(
  model1, model2, model3,
  statistics = c(
    '# observations' = 'nobs', 'R squared' = 'r.squared',
    'F statistic' = 'statistic','P value' = 'p.value'
  ), # 表示する統計量の選択
  stars = c(`***` = 0.001, `**` = 0.01, `*` = 0.05)
  # 有意水準の設定
)

table

#quick_pptx(table, file = "tab/college_sum.pptx")

# ロジスティック回帰

logit <- glm(formula = high_income ~ education + distance + ethnicity, data = CollegeDistance, family = binomial(link = "logit"))
summary(logit)

huxreg(logit)

logit$coefficients

CollegeDistance %>%
  lm_robust(formula = high_income ~ education + ethnicity + tuition + score, data = .) %>%
  summary()

CollegeDistance %>%
  lm_robust(formula = education ~ distance, data = .) %>%
  summary()

CollegeDistance %>%
  iv_robust(formula = high_income ~ education | distance + ethnicity + tuition + score, data = .) %>%
  summary()
