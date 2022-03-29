library(palmerpenguins)

# 基本操作-------------------------------

1 + 2 * (3 / 4) # 掛け算は*で
13 %% 5 # 剰余

### 関数
log(x = 100, base = 10) # 100の対数、底10で計算
log(x = 100, base = 5) # 底を5に変更


### パッケージインストール
install.packages("tidyverse") # tidyverse パッケージをインストール
library(tidyverse) # tidyverse パッケージを有効化：起動したときに毎回実行する

### 図形を描画する関数

graphics::plot(x = -5:5, y = (-5:5)^2, pch = 19, col = "magenta") 

# y = x^2 のグラフの描画、定義域は-5から5
# pchはプロットの形を指定、colはプロットの色