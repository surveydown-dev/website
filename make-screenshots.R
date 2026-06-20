# Regenerate the question screenshots in images/screenshots/ that the docs
# embed for widgets that only render well in a live Shiny environment
# (see chunks/question-screenshot-note.qmd).
#
# Run from the website repo root, with the current surveydown version
# installed: Rscript make-screenshots.R
# Requires: surveydown, shiny, chromote, and Google Chrome.

library(chromote)

port <- 8121
shots <- list(
  # selector = output file (relative to website root)
  "#container-experience" = "images/screenshots/slider.png",
  "#container-slider_single_val" = "images/screenshots/slider-numeric-single.png",
  "#container-slider_range" = "images/screenshots/slider-numeric-range.png",
  "#container-pet" = "images/screenshots/mc-image.png",
  "#container-pet_no_caption" = "images/screenshots/mc-image-no-caption.png",
  "#container-pets_owned" = "images/screenshots/mc-multiple-image.png"
)

# Image-choice cards whose inputs to click (to show the selected state)
# before screenshotting, keyed by container selector
clicks <- list(
  "#container-pet" = "#pet input[value=\"cat\"]",
  "#container-pet_no_caption" = "#pet_no_caption input[value=\"cat\"]",
  "#container-pets_owned" = c(
    "#pets_owned input[value=\"cat\"]",
    "#pets_owned input[value=\"dog\"]"
  )
)

# -- Build a temporary survey app with the questions to screenshot -------
# Question code must match the examples shown on docs/question-types.qmd.

app_dir <- file.path(tempdir(), "screenshot_app")
dir.create(app_dir, showWarnings = FALSE)

# Image-choice examples need their images on Shiny's resource path
dir.create(file.path(app_dir, "images"), showWarnings = FALSE)
file.copy(
  c("images/cat.png", "images/dog.png"),
  file.path(app_dir, "images"),
  overwrite = TRUE
)

writeLines(
  c(
    "---",
    "survey-settings:",
    "  mode: preview",
    "  use-cookies: false",
    "---",
    "",
    "```{r}",
    "library(surveydown)",
    "```",
    "",
    "--- page1",
    "",
    "```{r}",
    "sd_question(",
    "  type  = 'slider',",
    "  id    = 'experience',",
    "  label = \"How would you rate your overall experience?\",",
    "  option = c(",
    "    \"Very poor\" = \"very_poor\",",
    "    \"Poor\"      = \"poor\",",
    "    \"Neutral\"   = \"neutral\",",
    "    \"Good\"      = \"good\",",
    "    \"Very good\" = \"very_good\"",
    "  ),",
    "  selected = 'neutral'",
    ")",
    "",
    "sd_question(",
    "  type = 'slider_numeric',",
    "  id = 'slider_single_val',",
    "  label = 'Single value example',",
    "  option = seq(0, 10, 1)",
    ")",
    "",
    "sd_question(",
    "  type = 'slider_numeric',",
    "  id = 'slider_range',",
    "  label = 'Range example',",
    "  option = seq(0, 10, 1),",
    "  default = c(3, 5)",
    ")",
    "",
    "sd_question(",
    "  type   = 'mc_image',",
    "  id     = 'pet',",
    "  label  = \"Which pet do you prefer?\",",
    "  option = c('Cat' = 'cat', 'Dog' = 'dog'),",
    "  image  = c('images/cat.png', 'images/dog.png')",
    ")",
    "",
    "sd_question(",
    "  type   = 'mc_image',",
    "  id     = 'pet_no_caption',",
    "  label  = \"Which pet do you prefer?\",",
    "  option = c('cat', 'dog'),",
    "  image  = c('images/cat.png', 'images/dog.png')",
    ")",
    "",
    "sd_question(",
    "  type   = 'mc_multiple_image',",
    "  id     = 'pets_owned',",
    "  label  = \"Which pets have you owned? (select all that apply)\",",
    "  option = c('Cat' = 'cat', 'Dog' = 'dog'),",
    "  image  = c('images/cat.png', 'images/dog.png')",
    ")",
    "```",
    "",
    "--- end",
    "",
    "End.",
    "",
    "```{r}",
    "sd_close()",
    "```"
  ),
  file.path(app_dir, "survey.qmd")
)

writeLines(
  c(
    "library(surveydown)",
    "ui <- sd_ui()",
    "server <- function(input, output, session) {",
    "  sd_server()",
    "}",
    "shiny::shinyApp(ui = ui, server = server)"
  ),
  file.path(app_dir, "app.R")
)

# -- Launch the app -------------------------------------------------------

system(sprintf("pkill -f 'shiny::runApp.*%d'", port), ignore.stderr = TRUE)
Sys.sleep(1)
cat("Launching screenshot app (first render takes ~1 min)...\n")
system(sprintf(
  "Rscript -e 'shiny::runApp(\"%s\", port = %d)' > /tmp/sd_screenshot_app.log 2>&1 &",
  normalizePath(app_dir), port
))
url <- sprintf("http://127.0.0.1:%d/", port)
up <- FALSE
for (i in 1:60) {
  up <- tryCatch(
    {
      suppressWarnings(readLines(url, n = 1))
      TRUE
    },
    error = function(e) FALSE
  )
  if (up) break
  Sys.sleep(3)
}
if (!up) stop("App did not start. See /tmp/sd_screenshot_app.log")

# -- Take the screenshots -------------------------------------------------

b <- ChromoteSession$new(width = 1000, height = 1600)
b$Page$navigate(url)
Sys.sleep(6)

# Click image-choice cards to show the selected state in the screenshots
for (container in names(clicks)) {
  for (target in clicks[[container]]) {
    b$Runtime$evaluate(sprintf(
      "document.querySelector('%s').click();", target
    ))
  }
}
Sys.sleep(1)

for (sel in names(shots)) {
  out <- shots[[sel]]
  b$screenshot(out, selector = sel, scale = 2)
  cat("Saved", out, "\n")
}

b$close()
system(sprintf("pkill -f 'shiny::runApp.*%d'", port))
unlink(app_dir, recursive = TRUE)
cat("Done.\n")
