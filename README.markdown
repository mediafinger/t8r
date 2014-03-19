![Travis-CI Build Status](https://travis-ci.org/mediafinger/t8r.png?branch=master)
# T8r README

T8r is a Rails app that supports the I18n / translation process of web apps. It won't do any magic or use dirty tricks, but it wants to be a helpful translation / text resource management tool. It is aimed at developers, translators and copy-writers.

It has support for multiple *apps* and each app can have it's own set of languages (called *locales* in T8r).

Text resources (called *phrases* in T8r) provide the unique key, the 'master content' and optional hints (e.g. length restrictions, links to webpages or screenshots). They can be created in T8r - or via bulk import from a YAML file (or other formats).

Translations are created for every phrase and locale - either empty, or prefilled when importing text resource files. The ones not marked as *done* (✓) are highlighted as *untranslated* (ఠ_ఠ). This functionality can be used to add a proofreading step after the translation and to control which translations are exported.

__Editing translations happens in-place. Sorting, filtering and full-text search are availabe.__

The translations can be export as YAML, or as tab separated key value text files.

It is realy simple, this is the full ERD:

![ERD](https://github.com/mediafinger/t8r/raw/master/t8r_erd.png)


## Setup

Like every normal Rails app. Just clone it, bundle, create the databases, migrate, prepare the test database, run the tests with 'rake', start the server and open 'localhost:3000' in your browser.

Then create an app (just provide a name and a unique key) and either add locales, phrases and translations by hand - or import them via existing YAML files (one locale at a time).

I have not tested it yet, but it should run without any issue on a free heroku dyno.


## Dependencies

T8r was written with Ruby 2.1.1 and Rails 4.0.3.

It uses Puma as server and Postgres as database, but these could easily be exchanged to fit your infrastructure.

There are no external dependencies


## Exporters and Importers

A translation management tool needs support for many different file formats. T8r is easily expandable to support more file formats.

Several might be added soon - but if you need to support another format, ping me or send me a pull request!


## ToDo

A lot :) Just the most important features that I have in mind:

*  JSON REST API for all important functionality, including bulk-imports
*  Frontend design
*  Specs
*  Import of files in other formats than YAML and tab separated key value files (e.g. Android and iOS)
*  Export of files in other formats than YAML and tab separated key value files (e.g. Android and iOS)
*  (maybe) a User Rights System or Role System


## About T8r

Like I18n stands for Internationalization and L10n for Localization, T8r stands for Translator.

The first idea for a translation tool like this I had around the year 2009 / 2010 when coordinating a team of international translators for a browser game.
The thoughts reemerged, when I was working for a translation provider - and again not 100% happy with the provided tools.
But finally, at my current employer, I really feel the pain. The tool we have to use is one of the slowest (and oldest) web based tools I've ever worked with.

While T8r is meant to be a lightweight app, that nevertheless satisfies all the more important needs, it is also meant to be to be a potential in-house alternative for our current system. This might influence the feature road-map.


## About the author

I live in Barcelona and I use twitter: @mediafinger

You will find the latest version of T8r in my GitHub repo: https://github.com/mediafinger/t8r
