<!-- {<img src="https://travis-ci.org/mediafinger/t8r.png?branch=master" alt="Build Status" />}[https://travis-ci.org/mediafinger/t8r] -->
# README

T8r is meant to make the maintenance of the I18n process of web apps easier. It won't do any magic or use dirty tricks, but it wants to be a helpful tool. It is aimed at developers, translators and copy-writers.

It has support for multiple apps and each app can have it's own set of languages that need to be maintained.

Text ressources (called 'phrases' in T8r) will always be the draft or master. They can be created in T8r - or via bulk import from a YAML file (on locale at a time).

Translation that are not marked as 'done' are highlighted and linked in T8r. This functionality can also be used to add a proofreading step after the translation.

It is realy simple, this is the full ERD:

![ERD.pdf](https://github.com/mediafinger/t8r/raw/master/erd.pdf)

## Setup

Like every normal Rails app. Just clone it, bundle, create the databases, migrate, prepare the test database, run the tests with 'rake', start the server and open 'localhost:3000' in your browser.

I have not tested it yet, but it should run without any issue on a free heroku dyno.


## Dependencies

T8r was written with Ruby 2.1.1 and Rails 4.0.3.

It uses Puma as server and Postgres as database, but these could easily be exchanged to fit your infrastructure.

There are no external dependencies


## ToDo

A lot :) Just the most important features that I have in mind:

*  Export of YML files
*  Import of files in other formats
*  Export of files in other formats
*  Configurable import and export
*  better usablitiy of the frontend (filtering, display and linking of new/untranslated...)
*  a nice design
*  JSON REST API for all important functionality, including bulk-imports
*  (maybe) a User Rights System or Role System


## About T8r

Like I18n stands for Internationalization and L10n for Localization, T8r stands for Translator.

The first idea for a tool like this I had around the year 2009 / 2010 when coordinating a team of international translators for a browser game.
The thoughts reemerged, when I was working for a translation provider - and again not 100% happy with the provided tools.
But finally, at my current employer, I really feel the pain. The tool we have to use is one of the slowest (and oldest) web based tools I every worked with.

So, while T8r is meant to be a lightweight app, that nevertheless satisfies all the more important needs, it is also directed to be a potential in-house alternative for the current system. This might influence the feature road-map.


## About the author

I live in Barcelona and I use twitter: @mediafinger

You will find the latest version of T8r in my GitHub repo: https://github.com/mediafinger/t8r
