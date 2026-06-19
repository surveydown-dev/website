# Basic Components

## Overview

Every surveydown survey is composed of a *survey* and an *app*, defined in two separate files:

- **survey.qmd**: A [Quarto](https://quarto.org/) document that contains the main survey content, such as pages, questions, and navigation buttons. It is a standard Quarto document, so you can use any text editor or IDE to insert content.
- **app.R**: An R script defining a Shiny app that contains the global settings (libraries, database configuration, etc.) and any server configurations (e.g., conditional page skipping / question display, etc.).

These files must be named **survey.qmd** and **app.R**.

> **NOTE:**
>
> You do NOT need to render the **survey.qmd** file, and in fact we do not recommend doing so as the rendered output will not necessarily look like your final survey. Instead, to preview your survey you should [locally run](#local-run) your survey by running the **app.R** file.

Here is an example set of files for a basic survey:

## **survey.qmd**

```` r
---
format: html
---

```{r}
library(surveydown)
```

--- welcome

# Welcome to our survey!

```{r}
sd_question(
  type  = 'mc',
  id    = 'penguins',
  label = "Which type of penguin do you like the best?",
  option = c(
    'Adélie'    = 'adelie',
    'Chinstrap' = 'chinstrap',
    'Gentoo'    = 'gentoo'
  )
)
```

--- end

This is the last page of the survey.

```{r}
sd_close()
```
````

## **app.R**

``` downlit
library(surveydown)

# Connects to database
db <- sd_db_connect()

# Main UI
ui <- sd_ui()

server <- function(input, output, session) {
  # Main server
  sd_server(db)
}

shiny::shinyApp(ui = ui, server = server)
```

## survey.qmd

The **survey.qmd** file is where you will define all of the main survey content, such as pages, questions, and navigation buttons.

### YAML header

The YAML header is at the top of the **survey.qmd** file. It is where you specify all global settings for your survey. If you do not specify a YAML header, all default settings will be used. The simplest YAML header just specifies the output format as HTML, like this:

``` yaml
---
format: html
---
```

The YAML header can also contain other settings, such as theme settings, survey settings, and system message settings. See the [Survey Settings](survey-settings.llms.md) page for details.

The rest of the content in the **survey.qmd** file is the content you want in your survey, including **pages**, **navigation buttons**, and **questions**.

### Defining pages

In surveydown, pages are defined using the shorthand syntax with three dashes `---` followed by the page ID:

``` r
--- page1

Page 1 content here

--- page2

Page 2 content here
```

Each new page delimiter automatically closes the previous page, so you don’t need explicit closing tags.

Alternatively, you can use fence syntax with `:::` to explicitly mark the start and end of pages (see the [Page Navigation](page-navigation.llms.md) page for details on both syntax options).

### Adding questions

Every survey question is created using the [`sd_question()`](https://pkg.surveydown.org/reference/sd_question.html) function inside a code chunk. The question type is defined by the `type` argument.

For example, to add a multiple choice question, you could insert the following code chunk:

## Code chunk

```` markdown
```{r}
sd_question(
  type = 'mc',
  id = 'penguins',
  label = "Which is your favorite type of penguin?",
  option = c(
    'Adélie' = 'adelie',
    'Chinstrap' = 'chinstrap',
    'Gentoo' = 'gentoo'
  )
)
```
````

## Output

Which is your favorite type of penguin?

Adélie

Chinstrap

Gentoo

\*

The [`sd_question()`](https://pkg.surveydown.org/reference/sd_question.html) function can be used to create a variety of question types, like text input, select drop down choices, and more by changing the `type` argument (see the [Question Types](question-types.llms.md) page for more on the types of questions supported)

The function has many other arguments for customizing the look and feel of the question, such as the `height` and `width` (see the [Question Formatting](question-formatting.llms.md) page).

By default all questions are optional, but you can make questions required in the survey settings (see the [Survey Settings](survey-settings.llms.md#required-questions) page for details).

### Navigation buttons

By default, navigation buttons are automatically added to each page to allow respondents to move forward through the survey. To change the global settings (e.g., add a previous button on all pages, change the message shown on all next buttons, etc.), you can edit the survey settings in the YAML header (see the [Survey Settings](survey-settings.llms.md#default-settings) page for details).

Additionally, you can also manually add navigation buttons using the [`sd_nav()`](https://pkg.surveydown.org/reference/sd_nav.html) function inside code chunks on any page, which will override the global settings for that specific page, like this:

```` markdown
```{r}
sd_nav()
```
````

The [`sd_nav()`](https://pkg.surveydown.org/reference/sd_nav.html) function allows you to control mutliple aspects of the navigation buttons on a given page, including control over the labels used in the navigation buttons, control over whether to show either button at all, and control over which page to navigate to next. See the [Navigation Buttons](page-navigation.llms.md#navigation-buttons) page for more details.

### Ending the survey

The simplest way to end a survey is to create a page with no [`sd_next()`](https://pkg.surveydown.org/reference/sd_next.html) button on it. This will effectively serve as a ending page, because the respondent will not be able to navigate anywhere else once reaching a page with no next button.

For example, you may want to have a screen-out page that respondents are sent to if they answer a certain way on a question (e.g., see [Conditional Survey Flow](conditional-survey-flow.llms.md)). You can do this by creating a page with no [`sd_next()`](https://pkg.surveydown.org/reference/sd_next.html) button on it, like this:

``` r
--- screenout

Sorry, you are not eligible for this survey.

You can close this window now.
```

When a respondent reaches this page, they will not be able to navigate anywhere else, so the survey is over.

You can also add a button to end the survey programmatically using the [`sd_close()`](https://pkg.surveydown.org/reference/sd_close.html) function inside a code chunk, like this:

```` markdown
```{r}
sd_close()
```
````

This will create a button with the label “Exit Survey” that the respondent can click on to close the survey window. If you want to customize the label, use the `label` argument, like this:

```` markdown
```{r}
sd_close(label = 'Close Window')
```
````

This button can be added anywhere in the survey, not necessarily on the last page - all it does is close the browser window.

Finally, you can also add a button to end the survey and redirect the respondent to another page. You can do this using the [`sd_redirect()`](https://pkg.surveydown.org/reference/sd_redirect.html) function, like this:

## Code chunk

``` downlit
sd_redirect(
  id     = "redirect",
  url    = "https://www.google.com",
  label  = "Redirect to Google",
  button = TRUE,
  newtab = TRUE
)
```

## Output

Redirect to Google

This will create a button with the label “Redirect to Google” that the respondent can click on to be redirected to Google. You can also customize the url to include url parameters. See the [External Redirect](external-redirect.llms.md) page for more details.

## app.R

The main components of the **app.R** file are:

- **Global settings**: where you load the surveydown package and define the database connection.
- **Server**: where you define the logic of the survey (conditional question display / conditional survey flow, etc.)

### Global settings

The global settings are at the top of the **app.R** file. At a minimum, you need to load the `surveydown` package and define the database connection. You can also load other packages / global objects here if you need to. It typically looks like this:

``` downlit
library(surveydown)

# sd_db_config()
db <- sd_db_connect()
```

The `db` object is used to store survey data - see the [Storing Data](storing-data.llms.md) page for details on how to set up the database connection.

### Server

The `server()` function is a standard Shiny server function that takes `input`, `output`, and `session` as arguments. It is where you can set custom control logic and other configuration options, such as [conditional showing](conditional-logic.llms.md#showing-questions) logic with the [`sd_show_if()`](https://pkg.surveydown.org/reference/sd_show_if.html) function, [conditional page skipping](conditional-logic.llms.md#conditional-skipping) logic with the [`sd_skip_if()`](https://pkg.surveydown.org/reference/sd_skip_if.html) function, or [conditional stopping](conditional-logic.llms.md#conditional-stopping) logic with the [`sd_stop_if()`](https://pkg.surveydown.org/reference/sd_stop_if.html) function. It is also where you can control the logic for [reactive elements](reactivity.llms.md) in your survey.

If you create a new survey using a [template](getting-started.llms.md#start-with-a-template), the `server()` function might look something like this:

``` downlit
server <- function(input, output, session) {

  # Define conditional skip logic 
  # (skip forward to page if a condition is TRUE)
  sd_skip_if()

  # Define conditional display logic 
  # (show a question if a condition is TRUE)
  sd_show_if()

  # Main server to control the app
  sd_server(db = db)

}
```

The [`sd_server()`](https://pkg.surveydown.org/reference/sd_server.html) function at the bottom makes everything run. It also includes some optional arguments that you can use to customize the survey.

> **NOTE:**
>
> The `db = db` argument in [`sd_server()`](https://pkg.surveydown.org/reference/sd_server.html) is required if you are using a database connection, which should be defined using the [`sd_database()`](https://pkg.surveydown.org/reference/sd_database.html) function as mentioned above in the [Global Settings](#global-settings) section. See the [Store Data](storing-data.llms.md) page for more details.

### Launch app

At the very bottom of the **app.R** file, you will see the following code:

``` downlit
shiny::shinyApp(ui = ui, server = server)
```

This code defines the Shiny app and should always be at the bottom of the **app.R** file.

### Local run

To preview your survey, you can run the Shiny app locally by clicking the “Run App” button in RStudio or in your R console run the code `shiny::runApp('app.R')`. Typically, RStudio will launch the app in a new window, but you can also choose to have the app launch in a dedicated viewer pane, or in your external web browser. Make your selection by clicking the icon next to Run App:

![image showing the launch options of local run](https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/images/launch-options.png)

Back to top
