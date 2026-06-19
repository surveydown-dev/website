# Page Navigation

This page discusses how to create pages and navigate between them in a surveydown survey.

## Defining pages

In surveydown, pages can be defined using two different syntax options:

- **Shorthand syntax** (recommended)
- **Fence syntax**

### Shorthand syntax

The shorthand syntax uses three dashes `---` followed by the page ID to mark the start of a page. Each new page delimiter automatically closes the previous page, so you don’t need explicit closing tags:

``` r
--- page1

Page 1 content here

--- page2

Page 2 content here
```

This is the recommended approach as it’s more concise and easier to read.

### Fence syntax

Alternatively, you can define pages using fences (`:::`), which explicitly mark both the start and end of each page:

``` r
::: {.sd_page id=page1}

Page 1 content here

:::

::: {.sd_page id=page2}

Page 2 content here

:::
```

With fence syntax, we use three colon symbols `:::`, called a “fence”, to mark the start and end of pages. This notation is commonly used in Quarto for a variety of use cases, like defining [subfigures](https://quarto.org/docs/authoring/figures.html#subfigures) in images.

In the starting fence, you need to define the class as `.sd_page` and provide a page id (e.g. `page1` and `page2` in the example above). Then anything you put between the page fences will appear on that page.

Both syntaxes work identically - choose whichever you find more readable.

If you are using RStudio, you can also make use of the page gadget to create pages under the “Addins” dropdown menu. You can easily link the gadget with a keyboard shortcut from the “Tools” menu. Check out [this blog post](../blog/2025-04-08-surveydown-gadgets/) for a detailed walkthrough.

Here is what the **Survey Page Gadget** looks like in RStudio:

  

![](../images/screenshots/gadget_of_page.gif)

  

## Navigation buttons

By default, a **Next** button is automatically added to each page to allow respondents to move forward through the survey. You don’t need to add these buttons yourself.

To add a **Previous** button to every page so respondents can go back, you don’t need to edit each page individually. Just set `show-previous: yes` under `survey-settings` in your **survey.qmd** YAML header:

``` yaml
survey-settings:
  show-previous: yes
```

This (and other global navigation defaults, like the button labels) is applied to every page automatically. See the [Survey Settings](survey-settings.llms.md#default-settings) page for the full list of options.

If instead you want to control the buttons on a **single page only**, you can manually add navigation buttons using the `sd_nav()` function inside a code chunk on that page, which overrides the global settings for that specific page, like this:

```` markdown
```{r}
sd_nav()
```
````

The `sd_nav()` function allows you control over the labels using the `label_next` and `label_prev` arguments, e.g.:

- `label_next = "Next Page"`
- `label_prev = "Previous Page"`

You can also control whether to show either button at all using the following arguments:

- `show_next`: Set to `TRUE` or `FALSE` to show the next button or not.
- `show_prev`: Set to `TRUE` or `FALSE` to show the previous button or not.
- `show_buttons`: Set to `TRUE` or `FALSE` to show both buttons or not.

Finally, you can also control which page to navigate to next using the `page_next` argument (see [Direct Forward Skipping](#direct-forward-skipping) below).

## Skipping Forward

### Direct Forward Skipping

You can send the survey respondent to other forward pages by changing the value assigned to the `page_next` argument in the `sd_nav()` function. For example, to send the user to a page with the id `page3`, you can use:

```` markdown
```{r}
sd_nav(page_next = 'page3')
```
````

### Conditional Forward Skipping

While basic page navigation is handled automatically (or with the `sd_nav()` function for more fine-tuned control), you can override this static navigation in your server function with the `sd_skip_if()` function to send the respondent to a forward page based on some condition.

A common example is the need to **screen out** people based on their response(s) to a question. Let’s say you need to screen out people who do not own a vehicle. To do this, you would first define a question in your **survey.qmd** file about their vehicle ownership, e.g.:

```` markdown
```{r}
sd_question(
  type  = 'mc',
  id    = 'vehicle_ownership',
  label = "Do you own your vehicle?",
  option = c(
    'Yes' = 'yes',
    'No'  = 'no'
  )
)
```
````

You would also need to define a screenout page to send respondents to, like this:

``` r
--- screenout

Sorry, but you are not qualified to take our survey.
```

Then in the server function in the **app.R** file, you can use the `sd_skip_if()` function to define the condition under which the respondent will be sent to the target `screenout` page, like this:

``` downlit
server <- function(input, output, session) {

  sd_skip_if(
    sd_value("vehicle_ownership") == "no" ~ "screenout"
  )

  # ...other server code...

}
```

You can provide multiple conditions to the `sd_skip_if()` function, each separated by a comma. The structure for each condition is always:

> `<condition> ~ "target_page_id"`

In the example above, `sd_value("vehicle_ownership") == "no"` is the condition, and `"screenout"` is the target page that the respondent will be sent to if the condition is met.

Take a look at the [Common Conditions](conditional-logic.llms.md#common-conditions) section for examples of other types of supported conditions you can use to conditionally control the survey flow.

Back to top
