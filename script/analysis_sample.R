library(tidyverse)
library(AER)
library(skimr)
library(estimatr)
library(huxtable)
library(kableExtra)
library(ftExtra)

data("CollegeDistance")

#View(CollegeDistance)

#CollegeDistance$ethnicity %>% unique()

CollegeDistance <- CollegeDistance %>%
  mutate(
    univ = if_else(education >= 16, "Yes", "No"),
    high_income = if_else(income == "high", 1, 0),
  )

CollegeDistance %>%
  group_by(univ) %>%
  summarise(
    N = n(),
    hispanic = sum(ethnicity == "hispanic", na.rm = T) / n() * 100,
    african_american = sum(ethnicity == "afam", na.rm = T) / n() * 100,
    fcollege =  sum(fcollege == "yes", na.rm = T) / n() * 100,
    mcollege =  sum(mcollege == "yes", na.rm = T) / n() * 100,
  ) -> status_sum

saved <- huxtable(status_sum)

quick_xlsx(saved, file = "tab/college_sum.xlsx")

factor <- CollegeDistance %>% 
  skim() %>%
  yank("factor")

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

CollegeDistance %>%
  lm_robust(formula = high_income ~ education + ethnicity + tuition + score, data = .) %>%
  summary()

CollegeDistance %>%
  lm_robust(formula = education ~ distance, data = .) %>%
  summary()

CollegeDistance %>%
  iv_robust(formula = high_income ~ education | distance + ethnicity + tuition + score, data = .) %>%
  summary()


logit <- glm(formula = high_income ~ education + distance + ethnicity, data = CollegeDistance, family = binomial(link = "logit"))
summary(logit)
logit$coefficients
