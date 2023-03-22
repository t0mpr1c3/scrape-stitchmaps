# scrape pattern page urls from https://stitch-maps.com/patterns/

require(rvest)
require(dplyr)

fields <- c("pattern_page_url", "pernmalink", "first_contributor_name", "first_contributor_url", "instructions", "date-accessed")

trim <- function(str) {
	return(sub("[\\n\\s]*$", "", sub("^[\\n\\s]*", "", str, perl=TRUE), perl=TRUE))
}

scrape_pattern_page <- function(url_) {
	webpage <- read_html(paste0("https://stitch-maps.com", url_))
	permalink <- webpage %>% 
		html_nodes(xpath="//a[@class='permalink']") %>% 
		html_attr("href")
	# double up the backslashes, remove HTML escapes
	instructions <- 
		gsub("&amp;", "&", 
			gsub("\\n", "\\\\n", 
				trim(paste0(webpage %>% html_nodes(xpath="//div[@id='writtenInstr']//text()"), collapse=""))))
	first_contributor <- webpage %>% 
		html_nodes(xpath="//ul[preceding::h5[text()='Contributor']]") %>% 
		html_nodes(xpath="li[descendant::a[@href[contains('contributor', text())]]]") %>%
		first
	first_contributor_urls <- first_contributor %>%
		html_nodes(xpath="a") %>% 
		html_attr("href")
	first_contributor_name <- sub("/patterns/[?]contributor=", "", first_contributor_urls[1])
	if (length(first_contributor_urls) >= 2) {
			first_contributor_url <- first_contributor_urls[2]
		} else {
			first_contributor_url <- ""
		}
	return(c(permalink, first_contributor_name, first_contributor_url, instructions))
}

scrape_pattern_pages <- function(input_filename_, output_filename_) {
	input <- read.csv(input_filename_)
	# output_filename_ = csv file to which results are appended
	if (file.exists(output_filename_)) {
		master <<- file(output_filename_, "at")
	} else {
		master <<- file(output_filename_, "wt")
		writeLines(paste(fields, collapse=","), master) # write headers
	}
	p <<- 1
	while(p < dim(input)[1]) {
	#scrape <- tryCatch({
		# loop over pages
		url <- input[p, 1]
		print(p)
		print(url)
		tryCatch(
			{
				info <- scrape_pattern_page(url)
			}, error = function(e) {
				message(paste0("Error on page ", url, ":"))
				message(e)
			})
		if (class(info) != "character")
			warning(paste("Could not find patterns on page ", url))
		else {
			result <- paste(
				sapply(c(info, date()), function(x) paste0("\"", x, "\"")),
				collapse=",")
			print(result)
			writeLines(result, master)
			}
		p <<- p + 1
	#}, error = function(e) e)
	}
	#close(master)
}

scrape_pattern_pages("stitchmaps-urls.csv", "stitchmaps.csv")


