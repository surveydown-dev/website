# Tips

This page has some helpful suggestions for working with surveydown surveys.

## Programmatically generate survey questions

You can use code to programmatically generate survey questions in your **survey.qmd** file, which can be useful if you have a large number of questions that are similar to each other. One way to do this is to first create a data frame with the question parameters, and then use the `sd_question()` function to create the questions.

Here’s an example using `map()` over the `items` data frame to generate a list of questions. Note that the list of questions is wrapped in [`shiny::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html), which is necessary for the survey to render properly since the `map()` function returns a list.

> **NOTE:**
>
> This approach inserts all the questions on the same page. We haven’t found a way to insert these questions on different pages, which would require more sophistication in the `map()` function.

## Code chunk

```` markdown
```{r}
# Generate data frame of question parameters
items <- tibble::tibble(
  type = "mc",
  id = as.character(1:3),
  label = LETTERS[1:3],
  option = list(c(
    "None" = "0", 
    "A Little" = "1",
    "A lot" = "2"
  ))
)

# Generate questions
shiny::tagList(
  purrr::map(1:nrow(items), function(i) {
    args <- items[i, ]
    sd_question(
      id     = as.character(args$id),
      type   = args$type,
      label  = args$label,
      option = unlist(args$option)
    )
  })
)
```
````

## Output

A

None

A Little

A lot

\*

B

None

A Little

A lot

\*

C

None

A Little

A lot

\*

Back to top
