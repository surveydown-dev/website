# Getting Started

This page covers everything you need to get started making a survey with surveydown.

## Overview

Every surveydown survey is composed of a *survey* and an *app*, defined in two separate files:

- **survey.qmd**: A [Quarto](https://quarto.org/) document that contains the main survey content, such as pages, questions, and navigation buttons. It is a standard Quarto document, so you can use any text editor or IDE to insert content.
- **app.R**: An R script defining a Shiny app that contains the global settings (libraries, database configuration, etc.) and any server configurations (e.g., conditional page skipping / question display, etc.).

These files must be named **survey.qmd** and **app.R**.

The [**surveydown**](https://pkg.surveydown.org) R package provides a set of functions for defining the survey content and configuration options. Each function starts with `sd_` to make them easy to identify.

The platform is based on some basic principles:

- All content is defined and controlled in code, making it fully reproducible and version controllable.
- Survey content is defined inside a [Quarto](https://quarto.org/) document, allowing for rich content combining Markdown syntax and code chunks.
- Each survey is rendered as a single Shiny application, allowing for interactivity and dynamic behavior.
- Data storage is flexible and managed independently of where the survey app is hosted, providing flexibility and control over all data handling and storage.

The remaining steps on this page will guide you through the process of creating a surveydown survey.

## 1. Install

### Install R & Quarto

You need both:

- Install [](https://CRAN.R-project.org/)
- Install [Quarto](https://quarto.org/)

We also recommend working with an IDE that has good support for R, Quarto, and Shiny.

[RStudio](https://posit.co/products/open-source/rstudio/) is great, and we also like [VSCode](https://code.visualstudio.com/) and [Positron](https://github.com/posit-dev/positron).

### Install the surveydown R package

You can install surveydown from CRAN in your R console:

``` downlit
install.packages("surveydown")
```

or you can install the development version from [GitHub](https://github.com/surveydown-dev/surveydown):

``` downlit
# install.packages("pak")
pak::pak("surveydown-dev/surveydown")
```

Load the package with:

``` downlit
library(surveydown)
```

You can also check which version you have installed:

``` downlit
surveydown::sd_version()
```

## 2. Start with a template

> **NOTE:**
>
> Every survey created with surveydown should be in its own separate project folder.

We recommend starting with a template to build your first surveydown survey. In the R console, run the following to to setup a generic template survey:

``` downlit
surveydown::sd_create_survey()
```

You can also specify where you want the template survey to be created using the `path` argument, and you can also specify which template to use with the `template` argument, like this:

``` downlit
surveydown::sd_create_survey(
  path = "path/to/folder",
  template = "question_types"
)
```

The default is `template = "default"`, but you can specify other templates. See the [Templates](../templates.llms.md) page for an overview of all currently available templates.

> **TIP:**
>
> Prefer to let an AI agent do it? The [`/surveydown-skill`](agentic-skill.llms.md#create-a-survey) can scaffold a survey from any template (or compose a custom one you describe) for you.

## 3. Add survey content

Survey content is edited in the **survey.qmd** file. See the [Basic Components](../docs/basic-components.llms.md) page for more details on how to add more content to a surveydown survey. At a minimum, you can add pages and questions like this:

- Add pages with the shorthand syntax (details [here](page-navigation.llms.md#defining-pages)), like this:

``` r
--- page1

Page 1 content here

--- page2

Page 2 content here
```

- Add questions with the [`sd_question()`](https://pkg.surveydown.org/reference/sd_question.html) function in code chunks (see the [Question Types](question-types.llms.md) page for more on the types of questions supported). For example, here’s a multiple choice question:

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

## 4. Add control options

In the `server()` function in the **app.R** file, add rich functionality to your survey using a variety of [Survey Settings](survey-settings.llms.md) or [Conditional Logic](conditional-logic.llms.md).

## 5. Setup your database connection

Setup your database connection using the [`sd_db_config()`](https://pkg.surveydown.org/reference/sd_db_config.html) function. Once your configuration credentials are created (they get saved in a `.env` file), make a connection to your database using the [`sd_db_connect()`](https://pkg.surveydown.org/reference/sd_db_connect.html) function in the global settings at the top of the **app.R** file. To run the survey locally without storing data to a database, set `mode: preview` in your `survey.qmd` YAML. See the [Storing Data](../docs/storing-data.llms.md) page for more details on the available modes.

> **TIP:**
>
> The [`/surveydown-skill`](agentic-skill.llms.md#connect-a-database) can set up this database connection for you, including creating a free Supabase project and writing the `.env`.

## 6. Locally preview

Preview your survey by clicking the “Run App” button in RStudio or in your R console running the `runApp()` command.

## 7. Deploy

Deploy your survey on a host that runs R/Shiny: [Posit Connect Cloud](https://connect.posit.cloud/), [Hugging Face Spaces](https://huggingface.co/), or [Google Cloud Run](https://cloud.google.com/run). See the [Deployment](deployment.llms.md) page for details, or let the [`/surveydown-skill`](agentic-skill.llms.md#deploy-online) deploy it for you.

Back to top
