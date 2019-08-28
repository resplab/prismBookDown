
getItemizeDocs = function(functionName, section, keyword = "arguments", first = FALSE, maxSize = 12) {
  wd = getwd()
  fileName = paste0(wd, "/man/", functionName, ".Rd")
  arguments = readItems(fileName, keyword)
  htmlFile = paste0("html/section-", section, "/", functionName, "-", keyword, ".html")
  argumentsToHtml(arguments, htmlFile, functionName, first, maxSize)
}

argumentsToHtml = function(arguments, htmlFile, functionName, first, maxSize = 12) {

  size = length(arguments)
  con = file(htmlFile, "w")
  if(first) {
    head = '<head><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="js/list-group.js"></script>
    </head>'
  } else {
  head = '<head><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  <script src="js/list-group.js"></script>
  </head>'
  }
  writeLines(head, con)
  count = size / maxSize
  i = 1
  while(i <=  count+1) {
    if(i*maxSize >= size && i %% 2 == 1) {
      index = (i-1)*maxSize + 1
      row = '<br><div class="row">'
      writeLines(row, con)
      writeListGroup(arguments[c(index:size)], functionName, con, "left")
      writeTextGroup(arguments[c(index:size)], functionName, con, colSize = 8)
    } else if(i %% 2 == 0) {
      index = (i-1)*maxSize + 1
      index2 = min(index + maxSize-1, size)
      writeListGroup(arguments[c(index:index2)], functionName, con, "right")
      writeTextGroup(arguments[c((index-maxSize):index2)], functionName, con, colSize = 4)
    } else {
      index = (i-1)*maxSize + 1
      index2 = index + maxSize-1
      row = '<br><div class="row">'
      writeLines(row, con)
      writeListGroup(arguments[c(index:index2)], functionName, con, "left")
    }
    i = i + 1
  }
  end='<br>'
  writeLines(end, con)
  close(con)
}

writeListGroup = function(arguments, functionName, con, side) {

   listGroup = paste0('<div class="col-4">
    <div class="list-group ', side, '" id="list-tab" role="tablist">')

  writeLines(listGroup, con)
  toggleItemActive = '<a class="list-group-item list-group-item-action active" id="list-'
  toggleItem1 = '<a class="list-group-item list-group-item-action" id="list-'
  toggleItem2 = '-list" data-toggle="list" href="#list-'
  toggleItem3 = '" role="tab" aria-controls="'
  toggleItem4 = '">'
  first = TRUE
  for(argument in arguments) {
    id = paste0(argument$name,"-", functionName)
    if(first){
      toggleItem = paste0(toggleItemActive, id, toggleItem2, id, toggleItem3, id, toggleItem4, argument$name, '</a>')
    } else {
      toggleItem = paste0(toggleItem1, id, toggleItem2, id, toggleItem3, id, toggleItem4, argument$name, '</a>')
    }
    writeLines(toggleItem, con)
    first = FALSE
  }
  end = '</div>
  </div>'
  writeLines(end, con)
}

writeTextGroup = function(arguments, functionName, con, colSize = 8) {
  textGroup = paste0('<div class="col-', colSize, '">
    <div class="tab-content" id="nav-tabContent">')
  writeLines(textGroup, con)
  textItemActive = '<div class="tab-pane fade show active" id="list-'
  textItem1 = '<div class="tab-pane fade" id="list-'
  textItem2 = '" role="tabpanel" aria-labelledby="list-'
  textItem3 = '-list">'
  first = TRUE
  for(argument in arguments) {
    id = paste0(argument$name,"-", functionName)
    if(first){
      textItem = paste0(textItemActive, id, textItem2, id, textItem3, argument$text, '</div>')
    } else {
      textItem = paste0(textItem1, id, textItem2, id, textItem3, argument$text, '</div>')
    }
    writeLines(textItem, con)
    first = FALSE
  }
  end = '</div>
    </div>
  </div>'
  writeLines(end, con)
}

readItems = function(fileName, keyword) {
  con = file(fileName, "r")
  arguments = list()
  startArg = FALSE
  while ( TRUE ) {
    line = readLines(con, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    if(line == "}" && startArg) {
      startArg = FALSE
      break
    }
    if(startArg) {
       argument =  data.frame(matrix(ncol = 2, nrow = 1))
       names(argument) = c("name", "text")
       if(strContains("item", line)) {
         argument$name = getItemName(line)
         argument$text = getItemText(line)
         arguments = listAdd(arguments, argument)
       }
    }
    if(strContains(keyword, line)) {
      startArg = TRUE
    }
  }

  close(con)
  return(arguments)
}

strContains = function(str1, str2) {
  check = grep(str1, str2)
  return(length(check)>0)
}

getItemName = function(line) {

  lineSplit = strsplit(line, "")[[1]]

  startItem = FALSE
  itemName = ""
  for (char in lineSplit) {
    if(startItem && char=="}") {
      startItem = FALSE
      break
    }
    if(startItem) {
      itemName = paste0(itemName, char)
    }
    if(char=="{") {
      startItem = TRUE
    }
  }
  return(itemName)
}

getItemText = function(line) {

  lineSplit = strsplit(line, "")[[1]]

  startNext = FALSE
  startText = FALSE
  itemText = ""
  for (char in lineSplit) {
    if(startText && char=="}") {
      startText = FALSE
      break
    }
    if(startText) {
      itemText = paste0(itemText, char)
    }
    if(char=="}") {
      startNext = TRUE
    }
    if(char=="{" && startNext) {
      startText = TRUE
    }
  }
  return(itemText)
}

listAdd = function(myList, newItem) {
  size = length(myList)
  myList[[size+1]] = newItem
  return(myList)
}
