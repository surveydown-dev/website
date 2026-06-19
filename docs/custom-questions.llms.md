# Custom Questions

If you have an html widget that isn’t yet directly supported by surveydown, you can still use it by defining it in the server and using the `sd_question_custom()` function to store the value in the resulting survey data.

## Basic Syntax

Use the `sd_question_custom()` function to create custom questions. The function requires the following arguments:

- `id`: A unique identifier for the question, which will be used as the variable name in the resulting survey data (just like the `id` in `sd_question()`).
- `label`: The label that will be displayed on the question in the survey.
- `output`: The output widget. This needs to be an output function designed for shiny, e.g. `leafletOutput()`, `plotOutput()`, etc.
- `value`: The value to be returned by the question. This must be a reactive value that updates based on user interaction with the `output` widget (e.g. selecting a state on a leaflet map).
- `height` (optional): The height of the widget in pixels, defaults to 400.

Below is the basic syntax for creating a custom question:

``` downlit
sd_question_custom(
  id     = "some_id",
  label  = "Some Label",
  output = "some_output_widget",
  value  = "some_reactive_value"
)
```

To make `sd_question_custom()` work, you need to define the UI and functionality you want in the `server()` function in the **app.R** file. We have two examples that show how to set this up: an interactive map using leaflet, and an interactive plot using plotly.

## Leaflet Map Example

To reproduce this example, proceed to the [Custom Leaflet Map](../templates/custom_leaflet_map.llms.md) template. This template has a leaflet map that looks like the map below. When a user clicks on the map, it turns orange and stores the selected state in the resulting survey response data:

> Which state do you live in?

## Plotly Chart Example

To reproduce this example, proceed to the [Custom Plotly Chart](../templates/custom_plotly_chart.llms.md) template. This template has a plotly scatterplot map that looks like the chart below. When a user clicks on one of the points, it displays the point value and stores the point in the resulting survey response data:

> Click on a point to select it:

Back to top
