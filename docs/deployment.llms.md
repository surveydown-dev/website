# Deploying Your Survey

## Preparing to deploy

Before deploying your survey, make sure everything is working locally. You should have done the following:

1.  You have locally previewed your **app.R** file by clicking the “Run App” button in RStudio or in your R console running the code `shiny::runApp('app.R')`.
2.  You have set up a database connection to store survey responses (e.g. using [Supabase](https://supabase.com/)) and have already stored the database credentials using the `sd_db_config()` function (see the [Storing Data](storing-data.llms.md) page for details).

With these steps completed, you are ready to deploy your survey online.

## Deploying to shinyapps.io

Deploying your survey is pretty much the same as deploying any other Shiny app. We recommend using [shinyapps.io](https://shinyapps.io/) to host your survey as it is designed to work with Shiny Apps, but you can also use [other hosting services](#deploying-to-other-hosting-services).

> **NOTE:**
>
> You may have deployed other Quarto documents on [Quarto Pub](https://quartopub.com) before, but this site is only for static websites, so you **SHOULD NOT** use Quarto Pub for your survey deployment.

To start using [shinyapps.io](https://shinyapps.io/), you’ll need to create an account and follow the basic instructions to set up your sub-domain and authorize your IDE. See more information [here](https://docs.posit.co/shinyapps.io/guide/getting_started/).

Once you have your account and sub-domain ready, make sure you have the [rsconnect](https://rstudio.github.io/rsconnect/) package installed. You should have done this while authorizing your IDE, but in case you didn’t, you can install it with:

``` downlit
install.packages('rsconnect')
```

Then to deploy your survey, run:

``` downlit
# Define your app name with the appName parameter
rsconnect::deployApp(appName = "my_survey")
```

That’s it! Now you should have your survey site deployed on **shinyapps.io**. Congratulations! 🎉

## Deploying to Other Hosting Services

You can deploy shiny apps to other hosting services. Here are some guides for several other alternatives:

- [Posit Connect Cloud](https://docs.posit.co/connect-cloud/how-to/r/shiny-r.html)
- [Hugging Face](https://huggingface.co/docs/hub/spaces-sdks-docker-shiny#shiny-for-r)
- [Heroku](https://medium.com/@gracemwendemicheni/deploy-r-shiny-app-to-heroku-31b48fb6eb39)

You can also install [Posit Connect](https://posit.co/products/enterprise/connect/) on your own server, which is the [recommended approach](https://docs.posit.co/shinyapps.io/guide/security_and_compliance/index.html) for remaining compliant with any security protocols your organization requires.

Back to top
