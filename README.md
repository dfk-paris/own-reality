# README

This repository contains the data platform for the research project [OwnReality. Jedem seine Wirklichkeit. Der Begriff der Wirklichkeit in der Bildenden Kunst in Frankreich, BRD, DDR und Polen der 1960er bis Ende der 1980er Jahre](https://dfk-paris.org/de/ownreality) (website in German) by Dr. Mathilde Arnoux at the [German Centre for Art History Paris](https://dfk-paris.org). The project was funded by the European Research Council.

During the course of the project, data was gathered and entered into a database.
In general, this platform allows the integration of that data into web based
systems such as content management systems. To be independent of the target
technology, the integration is implemented with a set of customized html tags
with no assumptions on lower layers. An API-only web application retrieves the
data from an elasticsearch instance and relays to the widgets.

For legal reasons, the image data cannot be made available publicly. Please
contact Dr. Mathilde Arnoux (marnoux@dfk-paris.org) if you would like to have
access to the additional media.

This documentation aims to provide information on:

* the requirements to run the application
* how to set up the API-application
* importing the data from the included json documents
* importing the additional image data
* building the javascript integration asset
* how to integrate the widgets on a third-party page

## Requirements

We will just list the requirements here because their installation procedures
are documented nicely on their respective pages. The versions indicate tested
compatibility.

* linux (not a requirement but this howto assumes linux)
* elasticsearch (7.10.2)
* ruby (2.6.6)
* nodejs (12.20.1), only for building

## Setup

The API is a rails application that can be deployed under a ruby web server, the
phusion passenger apache module, the phusion passenger nginx module or a
combination of the above. For simplicity's sake, we will concentrate on a setup
under the ruby application server.

### Dependencies

Navigate to the folder where the application should reside and unpack the
sources there:

    mkdir -p /var/www/rack
    cd /var/www/rack
    wget https://github.com/moritzschepp/ownreality/archive/master.tar.gz
    tar xzf master.tar.gz
    mv ownreality-master ownreality
    cd ownreality

With ruby installed, proceed by installing the `bundler` gem:

    gem install bundler

This will allow you to fetch all other gems required for the app and install
them into a local directory:

    bundle install --path=./bundled_gems

And finally copy the default configuration file

    cp config/app.yml.example config/app.yml

### Building the javascript

This step is optional as the sources include a pre-built version of the
javascript. However, should you want to make modifications, the javascript will
have to be rebuilt afterwards. To do so, run the following with nodejs
installed:

    npm install
    npm run build

The built version will be placed at public/app.js within the app's directory.

### Data import

The json data is available at https://ownreality.dfkg.org/data.js.tar.gz. Please
download the archive to the application directory, e.g.

    tar xzf /root/json.data.tar.gz

The json files include the metadata for the platform but they have to be
imported. The environment variable tells rails that it should run in the
production environment where some optimizations apply. So then, run

    RAILS_ENV=production bundle exec rake or:from_json

If you received a copy of the image data, you should have an additional tarball.
Simply unpack it within the application directory (e.g.):

    tar xzf /root/ownreality_media.tar.gz

The application will work without this last step but the user will be shown
placeholders instead of the actual media.

### Running the app

Now you can run the application:

    RAILS_ENV=production bundle exec puma

Simply go to http://127.0.0.1:9292 with your browser and you should see a demo
page integrating a subset of the available widgets.


## Using the widgets

In order to use the widgets, the javascript must be included **below** all usage
of the custom tags on that page. So the best would be to place the following 
directly above the closing body tag:

    <body>
      ...
      <script
        type="text/javascript"
        src="https://ownreality.dfkg.org/app.js"
        or-api-url="http://127.0.0.1:9292"
      ></script>
    </body>

because that allows you to use the custom tags anywhere on the page. It doesn't
matter how you place the content. This can be a static html page or a page
managed with a content management system. Note that the `or-api-url` attribute
has to be set to the url where the app was deployed to.

### Widgets

* `<or-language-selector></or-language-selector>`: lets the user select the
content language. If you set the attribute **locales**, the widget will change
from a select box to a set of buttons allowing switches between those languages
instead of the default (de, fr, en).
* `<or-busy-wheel></busy-wheel>`: shows a spinning wheel as an indicator while
data is being loaded
* `<or-general-filters></or-general-filters>`: query input, time slider, people
(facets) and attribute (facets), requires attributes
**or-base-target-attribs-url** and **or-base-target-people-url** each indicating
the target link url for the respective facet groups.
* `<or-results></or-results>`: displays the tabbed result panel, the widget
or-general-filters is required on the same page
* `<or-filtered-chronology></or-filtered-chronology>`: displays the chronology
results for the current search, the widget or-general-filters is required on the
same page
* `<or-item-list type="magazines"></or-item-list>`: shows the full list of
magazines. You may also use “articles” or “interviews” instead of “magazines”.
* `<or-chronology-ranges></or-chronology-ranges>`: shows a list of links (one
for each year)
* `<or-chronology-results></or-chronology-results>`: shows the chronology
results according to the selected year, the widget or-chronology-ranges is
required on the same page
* `<or-list-item></or-list-item>` shows an individual item as within the search
results, required attributes: **id** (the id of the object to display, e.g.
“23258”) **type** (can have values “articles”, “sources”, “interviews” or
"magazines")
* `<or-item></or-item>` shows an individual item as inline as possible. required
attributes: **id** (the id of the object to display), **type** (magazines or 
articles or interviews). By default, the items title is shown as a link to a
dialog that shows more detail. You may specify **label** which will show that
information instead. If you set **or-search-url** to an url, then the widget
will assume that there is a working search on that page; on click, the user will
be switching to that search page with this item preconfigured as criterion
(currently only works for the magazines type)
