# Agentic Skill

The [**surveydown-skill**](https://github.com/surveydown-dev/surveydown-skill) is an agentic skill that teaches an AI coding agent (like [Claude Code](https://www.anthropic.com/claude-code)) how to work with surveydown surveys end to end. Instead of explaining surveydown’s syntax, hosts, and settings to your agent every time, you install the skill once and it knows how to author, host, and demo a survey on its own.

We have implemented the skill to become compatible with Claude Code. If you use Claude Code, you can follow the installation instructions and use it right away. If you use other agents, such as CodeX or Gemini, it is also not hard to convert the skill to make it compatible with those agents.

> **NOTE:**
>
> The [templates](../templates.llms.md) on this website were built with this skill extensively. Many of them have live demos hosted on Hugging Face Spaces and Posit Connect Cloud, and some include walkthrough video recordings, all made possible by the `/surveydown-skill`.

## Installation

### Claude Code

The skill installs into [Claude Code](https://www.anthropic.com/claude-code) with a single command:

``` bash
npx skills add surveydown-dev/surveydown-skill -a claude-code -g -y
```

This installs the skill globally to `~/.claude/skills/`, which can be used in any of your new Claude Code sessions. Re-running the same command pulls the latest version.

To uninstall, run this command:

``` bash
npx skills remove surveydown-dev/surveydown-skill -g
```

### Other agents

If you work with an agent other than Claude Code, such as Codex or Gemini, you can still use this skill. Visit the skill’s GitHub repository at [surveydown-dev/surveydown-skill](https://github.com/surveydown-dev/surveydown-skill) and download or clone it to your computer:

``` bash
git clone https://github.com/surveydown-dev/surveydown-skill.git
```

The skill is just a set of plain Markdown instructions and helper scripts, so it isn’t locked to any one agent. Point your agent at the cloned folder and ask it to adapt the skill to your agent’s own format (for example, Codex’s `AGENTS.md` or Gemini’s instruction files). The agent can read the `SKILL.md` and section guides and rewrite them into whatever structure your tool expects.

## Usage

Once installed, invoke the skill by the `/surveydown-skill` command in your agent. By design, your agent will also look through the installed skills on your computer, so even if you do not invoke a skill yourself, your agent will be smart enough to invoke it automatically.

The skill is organized around four things you can do with a survey: **create a survey**, **connect a database**, **deploy online**, and **record a video walkthrough**.

Here are some example prompts that you can give to your agent:

What you'll do

Example prompt

Create a survey

Make me a surveydown survey about coffee preferences.

CopyCopied!

Connect a database

`/surveydown-skill` connect my survey to a Supabase database.

CopyCopied!

Deploy online

Deploy this survey to Hugging Face Spaces.

CopyCopied!

Record a video walkthrough

`/surveydown-skill` record a video walkthrough of my survey.

CopyCopied!

## Create a survey

The agent scaffolds a new survey, a folder holding a `survey.qmd` (pages, questions, navigation) and an `app.R` (the Shiny app). It offers three starting points:

- **Minimum starter** — the bare default template: two pages, one multiple-choice and one text question, plus a finish page.
- **Themed showcase** — a richer survey built from one of the 17 official templates that demonstrate a real feature (varied question types, conditional logic, randomization, reactivity, conjoint, custom Plotly/Leaflet questions, and more).
- **Custom survey** — you describe the topic, questions, and flow, and the agent composes one from the template patterns.

The agent asks *what* survey you want and *where* to create it, scaffolds the files, and leaves it in `mode: preview` (responses saved to a local `preview_data.csv`) so you can preview it immediately with *Run App* in RStudio.

> **TIP:**
>
> - *“Create a new surveydown survey with a few demographic questions.”*
> - *“Scaffold the conditional skipping template into a folder called `pilot-survey`.”*
> - *“Build a 3-page customer feedback survey: a rating slider, a multiple-choice, and a comment box.”*

## Connect a database

By default a new survey writes responses to a local CSV, which is fine for testing but lost when the app restarts. This section switches the survey to a durable **PostgreSQL** database (the docs recommend [Supabase](https://supabase.com) as a free option) so responses are collected for real.

The agent locates your survey, asks whether you already have database credentials, and if not, walks you through creating a free Supabase project. It then writes the six `SD_*` credentials into a git-ignored `.env` file (via `sd_db_config()`), confirms `app.R` calls `sd_db_connect()`, flips the survey’s setting to `mode: database`, and verifies the connection. Credentials stay in the local `.env` and are never committed or pasted into the chat.

> **TIP:**
>
> - *“Connect my survey to a database so responses are saved durably.”*
> - *“I have a Supabase project already, wire `pilot-survey` up to it.”*
> - *“Switch this survey to database mode and check that the connection works.”*

## Deploy online

A surveydown survey is a live R/Shiny app, so it needs a host that runs R, not a static host like GitHub Pages or Netlify. The skill supports the three valid hosts, each as its own deployment technique. The tooling treats your survey folder as the source of truth: it *generates* host-specific packaging and pushes it, but never modifies your survey.

For every host the agent always confirms two survey settings first, the data **mode** (local / preview / database) and whether to **use cookies** (per-browser resume), then handles the packaging and push for you.

### Hugging Face Spaces

Deploys the survey as a Docker Space served on a clean URL (`https://<owner>-<space>.hf.space`). The free tier runs roughly **3 surveys at once**. The agent creates the Space if needed, uploads the survey, and for a database-mode survey syncs the `SD_*` credentials to the Space’s Secrets automatically. It can also wait for the build and report the live URL.

> **TIP:**
>
> - *“Deploy this survey to Hugging Face Spaces.”*
> - *“Push `pilot-survey` to Hugging Face as `myname/pilot` and wait until it’s running.”*

### Posit Connect Cloud

Publishes the survey via `rsconnect` to Posit’s managed R/Shiny host (the successor to the retiring shinyapps.io), served at `https://<account>-<slug>.share.connect.posit.cloud`. The free plan allows **5 applications**. The agent sets the display title and custom URL slug for you, ships database credentials as content secrets, and tunes the survey for fast cold starts.

> **TIP:**
>
> - *“Deploy this survey to Posit Connect Cloud with the title ‘Customer Feedback’.”*
> - *“Publish `pilot-survey` to Connect Cloud at the slug `pilot`.”*

### Google Cloud Run

Deploys each survey as its own Cloud Run service with **no limit on the number of surveys**. Services scale to zero when idle, so an unused survey costs about \$0, but a **billing card is required** on the project. The agent shows the billing caveat once, builds and deploys the container, stores database credentials in Google Secret Manager, and prints the live URL plus a dashboard link.

> **TIP:**
>
> - *“Deploy this survey to Google Cloud Run.”*
> - *“Put `pilot-survey` on Cloud Run in `us-central1` with 2Gi of memory.”*

> **NOTE:**
>
> Not sure which host to pick? Just say you want to deploy a survey online and the agent will lay out the three options (and their free-tier limits) before choosing.

## Record a video walkthrough

When a survey can’t be hosted online (for example a free tier is full) but still needs a demo people can watch, the skill records one locally. It renders the survey, opens a **visible** Chrome window, drives a cursor through every question answering each one, and screen-captures the run to an `.mp4` next to the survey.

This reuses surveydown’s own browser-automation test helpers as the interaction engine, so every question type is driven correctly. It is currently **macOS only** and needs Chrome, `ffmpeg`, and Screen Recording permission for your terminal. The section also documents how to publish the resulting video in a GitHub README.

> **TIP:**
>
> - *“Record a video walkthrough of the reactive drilldown template.”*
> - *“Make an mp4 demo of `pilot-survey` answering every question.”*

> **TIP:**
>
> The full skill, including each section’s guide and tooling, lives on GitHub at [surveydown-dev/surveydown-skill](https://github.com/surveydown-dev/surveydown-skill).

Back to top
