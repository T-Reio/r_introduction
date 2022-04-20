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

pi
value <- 8 # valueという文字列に8を代入
value + 10 # 今valueの値は8なので、8 + 10を計算した結果を返してくれる


### ベクトル

vec <- c(1192, 2960)
vec * 2

seq(1, 10, 2) #規則性のあるベクトルを作成
rep(0, 10)


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

### パッケージインストール
#install.packages("tidyverse") # tidyverse パッケージをインストール
library(tidyverse) # tidyverse パッケージを有効化：起動したときに毎回実行する

### 図形を描画する関数

graphics::plot(x = -5:5, y = (-5:5)^2, pch = 19, col = "magenta")


domain <- seq(-5, 5, .05) # ベクトルをオブジェクトに定義してから使うこともできる
graphics::plot(x = domain, y = domain^2, pch = 19, col = "magenta")
graphics::plot(x = domain, y = .5 * domain + 4, pch = 19, col = "blue")
# 計算式を変えれば異なるグラフが描画される

# y = x^2 のグラフの描画、定義域は-5から5
# pchはプロットの形を指定、colはプロットの色


# データ操作---------------------

library(palmerpenguins)

penguin_df <- palmerpenguins::penguins
write_excel_csv(penguin_df, path = "data/penguins.csv")

palmerpenguins::penguins %>% # パイプ演算子を使った記法
  write_csv("data/penguins.csv")

df <- read_csv('data/penguins.csv') # 読み込み


# データの要約-------------------

summary(df)

library(skimr)

df %>%
  skim()


# ggplotの可視化

