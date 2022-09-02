1 + 1

1/3

class(100)

class("1000")

class(090)
"090"

"100" + "200"

moji

pi + 10


df <- palmerpenguins::penguins %>%
  dplyr::filter(species == "Gentoo") # ジェンツーペンギンのみに絞る

print(df %>% head(2))

NA

palmerpenguins::penguins %>%
  filter(!is.na(body_mass_g)) %>% # 体重が欠損している個体を除外
  nrow()

df <- palmerpenguins::penguins %>%
  dplyr::select(species, sex, 5, 6)


df <- palmerpenguins::penguins %>%
  mutate(
    flipper_length_2 = log(flipper_length_mm), # 羽根の長さの2乗
    weight_size = if_else(condition = body_mass_g >= 4050, true = "L", false = "F"),
    flipper_size_3 = case_when(
      body_mass_g <= 3550 ~ "S",
      body_mass_g >= 3550 & body_mass_g <= 4750 ~ "M",
      TRUE ~ "L" # TRUE はそれ以外
    )
  )


df <- palmerpenguins::penguins
ggplot2::ggplot(data = df)

ggplot2::ggplot(data = df) +
  aes(x = body_mass_g) +
  geom_histogram()

ggplot2::ggplot(data = df) +
  aes(x = body_mass_g, y = ..density..) +
  geom_histogram() +
  theme_dark() + # 背景の設定
  labs(x = "体重 (g)", y = "密度", title = "ぺんぎんの体重分布")


ggplot2::ggplot(df) +
  ggplot2::aes(x = body_mass_g, y = bill_length_mm, colour = species) +
  ggplot2::geom_point()

ggplot2::ggplot(df) +
  ggplot2::aes(x = body_mass_g, y = bill_length_mm, colour = species) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", colour = "black") + # 最小二乗法で近似曲線を描画
  ggplot2::labs(x = "体重 (g)", y = "くちばしの長さ (mm)")

ggplot2::ggplot(df) +
  ggplot2::aes(x = body_mass_g, y = bill_length_mm, colour = species, group = species) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", colour = "black") + # 最小二乗法で近似曲線を描画
  ggplot2::labs(x = "体重 (g)", y = "くちばしの長さ (mm)")


model1 <- CollegeDistance %>%
  estimatr::lm_robust(high_income ~ education, data = .)
model2 <- CollegeDistance %>%
  estimatr::lm_robust(high_income ~ education + score, data = .)
model3 <- CollegeDistance %>%
  estimatr::lm_robust(high_income ~ education + score + ethnicity, data = .)

table <- huxtable::huxreg(model1, model2, model3)
