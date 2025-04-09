generate_pdf <- function() {

  return(pagedown::chrome_print(
    input = "test.Rmd",
    output = "test.pdf"
  ))

}

