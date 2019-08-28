library(htmltools)
source("R/FormatCode.R")

addHTML = function(fileName, section, codeChunk = FALSE) {
  file = paste0("html/section-", section, "/", fileName)
  if(codeChunk) {
    htmlLines = readLines(file)
    newLines = addBreaks(htmlLines)
    rawHTML <- paste(newLines, collapse="\n")
  } else {
    rawHTML <- paste(readLines(file), collapse="\n")
  }
  return(HTML(rawHTML))
}