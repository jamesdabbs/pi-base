# Brubeck Topology Database

[![Code Climate](https://codeclimate.com/github/jamesdabbs/brubeck.png)](https://codeclimate.com/github/jamesdabbs/brubeck)

### Testing locally

To run locally, you will need to install the following dependencies:

* mysql
* ruby 2.0 (recommended through [rbenv](https://github.com/sstephenson/rbenv/))
* redis

Then run the following:

```bash
$ git clone git@github.com:jamesdabbs/brubeck.git
$ cd brubeck
$ bundle          # Installs gem packages as specified in the Gemfile
$ rake db:setup   # Creates the database, with its required tables
```

At this point you should be set up to use any of these commands:

```bash
$ rails c           # Starts an interactive rails console session
$ rails s           # Spins up a rails server at localhost:3000
$ rake resque:work  # Starts a background worker (for automated proof generation, etc.)
```

If you have other gems installed on your system, you may need to prefix `rake` and `rails` commands with `bundle exec`.

Feel free to email me if you have any trouble getting things up and running.

### Contributing

I would _love_ bug reports and feature requests. Feel free to submit those in the [GitHub issues](https://github.com/jamesdabbs/brubeck/issues).

If you want to push up code, open up a pull request. I'll review it, merge it in, and push it live once it's good to go.
