# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the source code for the [surveydown.org](https://surveydown.org/) website, which documents the surveydown R package for creating online surveys. The site is built using **Quarto** and deployed via **Netlify**.

**surveydown** is a platform that combines:
- **Quarto** for designing surveys using markdown and R code
- **Shiny** for rendering surveys as interactive web applications  
- **PostgreSQL/Supabase** for storing survey response data

## Common Commands

### Building and Previewing
- `quarto render` - Render the entire website to `_site/` directory
- `quarto preview` - Start local development server (port 5678 by default)
- `quarto preview --port 5678` - Preview with specific port (as configured in _quarto.yml)

### Development Workflow
- Edit `.qmd` files in root, `docs/`, `blog/`, or `templates/` directories
- Use `quarto preview` for live development with auto-refresh
- The `chunks/` directory contains reusable content snippets included via `{{< include >}}`

## Architecture

### File Structure
- **_quarto.yml** - Main Quarto project configuration with website structure, navigation, and rendering options
- **docs/*.qmd** - Documentation pages covering surveydown features and usage
- **templates/*.qmd** - Live examples and templates for different survey types
- **blog/*.qmd** - Blog posts and announcements  
- **css/** - Custom styling (surveydown.css, templates.css, theme.scss)
- **chunks/** - Reusable content snippets included across pages
- **images/** - Static assets including logos, screenshots, and diagrams
- **_site/** - Generated website output (git-ignored)

### Key Architecture Concepts
- **Documentation structure**: Organized into logical sections (Survey Basics, Question Development, Survey Design Concepts, etc.) as defined in the sidebar navigation
- **Template system**: Live, interactive examples hosted on shinyapps.io and embedded via iframes
- **Content reuse**: Common content stored in `chunks/` and included via Quarto's include directive
- **R dependencies**: Listed in DESCRIPTION file, includes core packages like surveydown, dplyr, leaflet, plotly

### Navigation Structure
The site uses a two-sidebar approach:
1. **Documentation sidebar**: Hierarchical navigation for all docs content
2. **Templates sidebar**: Categorized examples (Basic, Randomization, Reactivity, Conjoint, Custom)

### Styling System
- Uses Quarto's theme system with Bootstrap 5
- Light/dark theme support via flatly/darkly themes
- Custom SCSS in `css/theme.scss`
- Template-specific styles in `css/templates.css`
- Documentation styles in `css/surveydown.css`

## Content Development

### Adding Documentation
1. Create new `.qmd` file in `docs/`
2. Add navigation entry to `_quarto.yml` sidebar
3. Use existing content structure and styling patterns
4. Include reusable chunks from `chunks/` when appropriate

### Adding Templates  
1. Create new `.qmd` file in `templates/`
2. Add metadata (title, date, categories, image, description)
3. Include link to live demo and GitHub repo 
4. Add iframe embed of live template
5. Update `_quarto.yml` templates sidebar navigation

### R Code Integration
- R code blocks are set to `eval: false` by default (see _quarto.yml execute settings)
- Use `#| eval: true` for blocks that should execute
- Common R setup in `_common.R` for shared functions
- Knitr options configured for clean output formatting