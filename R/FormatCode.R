
addBreaks = function(htmlLines) {
  start = FALSE
  newLines = c()
  for(line in htmlLines) {
    newLine = line
    if(strContains("</code>", line)) {
      start = FALSE
    }
    if(start) {
      newLine = paste0(line, "<br>")
    }
    if(strContains("<code ", line)) {
      start = TRUE
    }
    newLines = c(newLines, newLine)
  }
  return(newLines)
}

strContains = function(str1, str2) {
  check = grep(str1, str2)
  return(length(check)>0)
}

