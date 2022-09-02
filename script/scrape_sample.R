library(tidyverse)
library(rvest)

# URLを入力
url <- "https://www.pref.hokkaido.lg.jp/hs/82603.html"

# read_htmlで読み込む
base <- read_html(url) %>%
  paste0() %>%
  str_remove_all(., '<!--') %>%
  str_remove_all(., '-->') %>%
  read_html()

# 欲しいテーブルのあるノード：調べて を指定する (html ノードとかで出てくるはず)
base %>%
  html_nodes(xpath = '//*[@id="main-wrap"]/div[1]/div/article/div[2]/center/table/tbody/tr') -> rows

# 列名 (元ページの表の列名が二段組みになっているのでそのままだとバグる：とりあえずa - pで列名を着けてます)
label <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p")


# 表から1行ずつ数字を抜いてくる
map_df( # リストに対して、同じ操作を繰り返し実行する関数
  rows, 
  .f = ~ .x %>%
    html_nodes("td") %>%
    html_text() %>%
    set_names(label)
) -> df

rows[[1]] %>% #↑ 本質的にはこれと同じ操作をしている
  html_nodes("td") %>%
  html_text() %>%
  set_names(label)

df # データフレーム：列名を変更したり、文字型から数値型への変更も必要