# User Manual for PRISM

The purpose of this package is to create documentation for the `prism` package. To view the documentation on GitHub Pages, got to: https://resplab.github.io/prismUserGuide/

# Editing the Documentation

If you want to compile the BookDown yourself/add new documentation, you can download this package in R:

```
devtools::install_github("resplab/prismUserGuide.git")
```
Once you have downloaded the package, you need to set the working directory to the package folder. For example, if I installed the `prismUserGuide` package in my `Coding` folder, I would change the directory as follows:

```
setwd("~/Coding/prismUserGuide")
```
Once you have made the changes you want, you can recompile the BookDown files as follows:

```
bookdown::render_book("1-prism.Rmd", "bookdown::gitbook", output_dir="docs")
```

The output_dir must be "docs" in order to work with Github Pages. Also, the `index.html` file is necessary for GitHub Pages.

## CSS Files

The CSS files are in the `css` folder. The BookDown package comes with its own set of CSS files, but I added some of my own to incorporate Bootstrap elements, etc. Most of the CSS used is in `main-bookdown-styles.css`. The `python.css` file contains some additional styling for Python code highlighting in code chunks. The `shadow.css` file contains styles for the Shadow DOM elements. 

## Images

The folder `img` contains all the image files used in the documentation.

## Use of HTML in BookDown

In the Rmd files, you will see code chunks that incorporate raw HTML. I created a function in the file `R/addHTML.R` called `addHTML`, which takes the file name and section number, and creates the HTML. For example, in `2-api.Rmd`:

```
source("R/addHTML.R")
addHTML("user-server-api.html", section = 2, codeChunk = FALSE)
```

Basically this allows me to write some parts in HTML/CSS/Javascript, and BookDown will incorporate it inline. All the `.html` files are in the `html` folder, which is divided into folders for each Section (each Rmd file is a section).

The `codeChunk` argument is whether or not the raw HTML is a `code-chunk` component (explained in more detail below). Default is `FALSE`. The only difference is that if the HTML is a `code-chunk` component, we need to add line breaks in order to use the Highlight.js functions for syntax highlighting. 

## Code Chunks

In R Markdown/Bookdown, you can write code by using ``` ```{r, echo = TRUE, eval = TRUE}``` ```. During compilation, the `render_book()` function will format the code and add the necessary highlighting. However, I wanted to add some Javascript to the code chunks, in particular to add a "Copy" button and a "Language" button, the latter of which allows the user to change the language. Unfortunately, I was unable to find a simple way to integrate this functionality into the Bookdown package, so I added my own HTML components.

I wanted to create an object, or component, that was reusable. To do this, I used Shadow DOM. In the `js` folder, there is a file called `code-chunk-component.js`. This is the Javascript used to create the code chunk components. To create the component, I extended a Javascript class called `HTMLElement`, to create a new class called `code-chunk`. In the constructor, you will see there are two slots, one called "language", and the other called "code." Slots are what make components reusable. 

The first slot, "language," is going to be the same in all the components, so I defined it below the constructor. You can see the "Language" dropdown menu and the "Copy" button are added to the inner HTML.

The second slot, "code," is going to be different each time the component is used, because it will allow the user to add code (similar to markup). If you go into the `html/section-5` folder, there is a file called `get-default-input.html`. This is an example of how the "code-chunk" component is used. Because we defined a new HTMLElement `code-chunk`, we can now use it as a tag: ```<code-chunk></code-chunk>```. The next line after this tag is the call: ```<div slot="code">```. This slot is divided into different divisions for the languages. If you would like to use this component, you can copy and paste the code from the `get-default-input.html` file, and replace the marked up code with the code you wish to use. 

If you want to change or add any languages, you must change the `language` slot definition in the `code-chunk-component.js` file, and also change the languages in the `code` slot. 

An example from `3-using-prism.Rmd`:

```
source("R/addHTML.R")
addHTML("install.html", section = 3, codeChunk = TRUE)
```

## Highlight JS

For the HTML component `code-chunk` described above, I also wanted to highlight the code syntax. There is a package called Highlight.js, which can be found here: https://highlightjs.org/download/. You can source from CDN, however, this version does not contain syntax highlighting for R. To customize the language support, scroll down to "Custom package", click on the languages you want, and click `Download`. Extract this folder, and save it as `highlightjs` in the `prismBookDown` folder. Then copy the `highlight.pack.js` file to the `js` folder, and you should be good to go!

