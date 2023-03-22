# scrape pattern page urls from https://stitch-maps.com/patterns/

require(rvest)
require(dplyr)

fields <- c("pattern_url", "date-accessed")

scrape_page <- function(url_) {
	webpage <- read_html(url_)
	char_vec <- webpage %>% 
		html_nodes(xpath="//div[@class='chart-thumbnail']/a[1]") %>% 
		html_attr("href")
	return(char_vec)
}

scrape_pagenames <- function(filename_) {
	# filename_ = csv file to which results are appended
	if (file.exists(filename_)) {
		master <<- file(filename_, "at")
	} else {
		master <<- file(filename_, "wt")
		writeLines(paste(fields, collapse=","), master) # write headers
	}
	p <<- 1
	while(TRUE) {
	#scrape <- tryCatch({
		# loop over pages
		if (p == 1) {
			url <- "https://stitch-maps.com/patterns/"
		} else {
			url <- paste0("https://stitch-maps.com/patterns/?page=", p)
		}
		tryCatch(
			{
				pattern_urls <- scrape_page(url)
			}, error = function(e) {
				message(paste0("Error on page ", p, ":"))
				message(e)
			})
		if (class(pattern_urls) != "character")
			warning(paste("Could not find patterns on page ", p))
		else {
			result <- paste(
				sapply(pattern_urls, function(x) paste0("\"", x, "\", \"", date(), "\"")),
				collapse="\n")
			print(result)
			writeLines(result, master)
			}
		p <<- p + 1
	#}, error = function(e) e)
	}
	#close(master)
}

scrape_pagenames("stitchmap-urls.csv")
