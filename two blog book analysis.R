install.packages("rvest")
library(rvest)
library(rvest)
page <- read_html("https://books.toscrape.com/catalogue/page-1.html")
titles <- page %>% html_elements("article.product_pod h3 a") %>% html_attr("title")
prices <- page %>% html_elements("p.price_color") %>% html_text2()
data.frame(book_titles=titles, book_prices=prices)
rating <- page %>% html_elements("p.star-rating") %>% html_attr("class")
rating
books_df <- data.frame(
book_title = titles,
book_price = prices,
book_rating = rating
)
books_df
books_clean <- books_df
books_clean$price_num <- as.numeric(sub("$","",books_clean$book_price))
books_clean$price_num <- as.numeric(sub("£","",books_clean$book_price))
books_clean
books_clean$score <- NA
books_clean$score[endsWith(books_clean$book_rating, "One")] <- 1
books_clean$score[endsWith(books_clean$book_rating, "Two")] <- 2
books_clean$score[endsWith(books_clean$book_rating, "Three")] <- 3
books_clean$score[endsWith(books_clean$book_rating, "Four")] <- 4
books_clean$score[endsWith(books_clean$book_rating, "Five")] <- 5
books_clean
books_clean$value_index <- books_clean$score / books_clean$price_num
books_clean
titles
books_clean$book_title <- titles
books_clean
books_sorted <- books_clean[order(books_clean$value_index), ]
books_sorted
plot(books_sorted$price_num, books_sorted$score, xlab="Price", ylab="Star Rating", main="Book Price vs Star Rating")
