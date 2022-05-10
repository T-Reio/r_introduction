#install.packages("palmerpenguins")
#install.packages("tidyverse")
#install.packages("AER")
#install.packages("estimatr")
#install.packages("huxtable")
#install.packages("skimr")

#でコメントアウトできる：実行しても無視されるので、メモ書きに使える

library(tidyverse)

# ここに項目名を書いて -----か####を打つと折りたたみできる -----------------

# 基本操作-------------------------------

1 + 2 * (3 / 4) # 掛け算は*で
13 %% 5 # 剰余

# 変数型---------------------------------
class(3.14) # class()はその変数の型を返す関数
class('1.90') # 文字列 character と判定される

"1" + "2" # エラーが出る

### オブジェクトの定義

pi # デフォルトで円周率が格納されている
value <- 8 # valueという文字列に8を代入
value + 10

### ベクトル

vec <- c(1192, 2960)
vec * 2
c(1, 3, 5, 7, 9)
seq(1, 100, 2) #規則性のあるベクトルを作成
1:30
rep(0, 10)

### パッケージインストール
#install.packages("palmerpenguins")
#install.packages("tidyverse")
#install.packages("AER")
#install.packages("estimatr")
#install.packages("huxtable")
#install.packages("skimr") #パッケージをインストール
library(tidyverse) # tidyverse パッケージを有効化：起動したときに毎回実行する

### データフレーム

library(tidyverse)
df <- tibble::tibble( # dfというオブジェクトにデータフレームを定義
  faculty = c("econ", "law", "foreign", "lit"), # 各列のデータをベクトル形式で代入
  grade = c(4, 2, 1, 1),
  toeic = c(300, 820, NA, 785) # NA: 該当する値が存在しないことを表す＝無回答など
)
df
view(df) # 別ウィンドウで見る


listA <- list(data.frame(a = 1:5, b = 11:15, c = 100:104), df)
listA # 2つのデータフレームが一つのオブジェクトにまとめて入っている

listA[[1]] # リストの中の1つ目の要素だけ出してくる


### 関数

log(x = 100, base = 10) # 100の対数、底10で計算
log(x = 100, base = 5) # 底を5に変更

log(100, 10)
log(base = 100, x = 10)

values <- c(1:5, rep(3, 10), 4:10) #1, 2, ..., 5, 3, 3, ... 
mean(values) # ベクトルの平均を計算
sd(values)

### 図形を描画する関数

graphics::plot(x = -5:5, y = (-5:5)^2, pch = 19, col = "magenta")
plot(x = -5:5, y = (-5:5)^2, pch = 19, col = "magenta")

domain <- seq(-5, 5, .05) # ベクトルをオブジェクトに定義してから使うこともできる
graphics::plot(x = domain, y = domain^2, pch = 19, col = "magenta")
graphics::plot(x = domain, y = .5 * domain + 4, pch = 19, col = "blue")
# 計算式を変えれば異なるグラフが描画される

# y = x^2 のグラフの描画、定義域は-5から5
# pchはプロットの形を指定、colはプロットの色


# データ操作---------------------

# パイプ演算子

mean(1:10)

1:10 %>%
  mean()

1:10 %>% # ベクトルを作る、これが直後の関数で操作される
  mean() %>% # 平均を求める
  print()

#install.packages("palmerpenguins")
library(palmerpenguins)

df <- penguins

head(df, 3)
tail(df)

penguin_df <- palmerpenguins::penguins
write_excel_csv(penguin_df, file = "data/penguins.csv")

palmerpenguins::penguins %>% # パイプ演算子を使った記法
  write_csv("data/penguins.csv")

df <- read_csv('data/penguins.csv') # 読み込み


## URLから読み込む

url <- 'https://raw.githubusercontent.com/chadwickbureau/register/master/data/people.csv' # URLは一例
df <- read_csv(url)

## write_rds
readr::write_rds(penguin_df, file = "data/penguins.rds")

# データの要約-------------------

summary(penguin_df)

palmerpenguins::penguins %>%
  summary()

penguin_df %>%
  dplyr::rename(weight = body_mass_g)

newnames <- c("species", "island", "bill_lg", "bill_dep", "flipper", "weight", "sex", "yr")

penguin_df %>%
  purrr::set_names(newnames)

gentoo <- palmerpenguins::penguins %>%
  dplyr::filter(species == "Gentoo") # ジェンツーペンギンのみに絞る

gentoo

# filter
na_omitted <- penguin_df %>%
  filter(!is.na(body_mass_g)) %>%
  nrow()

# select

penguin_df %>%
  dplyr::select(species, sex, 5, 6)

# mutate
penguin_df %>%
  mutate(
    flipper_length_2 = flipper_length_mm^2, # 羽根の長さの2乗
    weight_size = if_else(condition = body_mass_g >= 4050, true = "L", false = "F"),
    flipper_size_3 = case_when(
      body_mass_g <= 3550 ~ "S",
      body_mass_g >= 3550 & body_mass_g <= 4750 ~ "M",
      TRUE ~ "L" # TRUE はそれ以外
    )
  )


df_split <- penguin_df %>%
  select(species, island, sex) %>% # 表示の都合上列数を限定
  split(pull(., sex)) # 分割の基準にしたい変数を入力
df_split


# summarize-----

palmerpenguins::penguins %>%
  summarise(
    mean_bill_length_mm = mean(bill_length_mm, na.rm = T), # くちばしの長さの平均を取る、欠損値は除外
    mean_flipper_length_mm = mean(flipper_length_mm, na.rm = T),
    mean_body_mass_g = mean(body_mass_g, na.rm = T),
  )


penguin_df %>%
  group_by(species) %>% # 種類ごとに
  summarise(
    N = n(), # サンプルサイズ
    mean_bill_length_mm = mean(bill_length_mm, na.rm = T), # くちばしの長さの平均を取る、欠損値は除外
    mean_flipper_length_mm = mean(flipper_length_mm, na.rm = T),
    mean_body_mass_g = mean(body_mass_g, na.rm = T),
  )


penguin_df %>%
  group_by(sex, species) %>% # 種類と性別ごとに
  summarise(
    N = n(),
    mean_bill_length_mm = mean(bill_length_mm, na.rm = T), # くちばしの長さの平均を取る、欠損値は除外
    mean_flipper_length_mm = mean(flipper_length_mm, na.rm = T),
    mean_body_mass_g = mean(body_mass_g, na.rm = T),
  )

# skimr------
library(skimr)
descriptive <- palmerpenguins::penguins %>%
  skim()
descriptive

penguin_df %>%
  skim() %>%
  yank(., skim_type = "numeric") %>% # numeric型の要約統計量を表示
  print()

sum <- penguin_df %>%
  group_by(island) %>%
  skim() %>%
  yank(., skim_type = "numeric")

sum %>%
  filter(skim_variable == "bill_length_mm") %>%
  filter(island %in% c('Biscoe', 'Dream')) %>%
  select(skim_variable, island, complete_rate, mean, sd)

# ggplotの可視化

mean(1:10)
1:10 %>%
  mean(x = .)

1:10 %>% # ベクトルを作る、これが直後の関数で操作される
  mean() %>% # 平均を求める
  print() 
