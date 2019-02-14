# bitbar-concourse

[![Build Status](https://travis-ci.org/suhlig/bitbar-concourse.svg?branch=master)](https://travis-ci.org/suhlig/bitbar-concourse)

Presents the status of a [Concourse](https://concourse-ci.org/) pipeline in [bitbar](https://github.com/matryer/bitbar).

This started out as fork of Checkman's [concourse.check](https://github.com/cppforlife/checkman/blob/master/scripts/concourse.check), but has evolved since.

# Usage

* Install bitbar (`brew install bitbar`)
* Install this gem
* Add the following script as `~/.bitbar/concourse.1m.sh` and make it executable:

  ```sh
  #!/bin/bash

  # Change this URL to point to your own Concourse instance
  # but the public one should be ok as a demo
  export CONCOURSE_URI=http://concourse.ci/

  # username and password are optional
  export CONCOURSE_USER=user
  export CONCOURSE_PASSWORD=password

  # invoke the plugin
  bitbar-concourse
  ```

  I do not install bitbar-concourse as system gem, but I use chruby. For some reason bitbar does not seem to run a login shell, so I had to load `chruby` manually in `~/.bitbar/concourse.1m.sh` (just before the last line):

  ```sh
  export PATH=/usr/local/bin:$PATH
  source "$(brew --prefix)/share/chruby/chruby.sh"
  chruby 2.5.1
  ```

* Check the bitbar icon in the system tray for an updated status of your pipeline:

  Example:

  ![Flintstone CI](public/flintstone.png)

# Installation

```sh
$ gem install bitbar-concourse
```

# Development

* Use `fswatch` to run specs whenever code or tests change. Install it with `brew install fswatch` if not available.

  ```
  $ fswatch --one-per-batch spec lib | xargs -n1 -I{} rspec
  ```

* Since the bitbar protocol is text-based, the bitbar-concourse gem can be tested in the terminal. Just execute the script in `~/.bitbar/` in a terminal window.

# Tests

Running the integration tests requires a real Concourse server. By default, [ci.concourse-ci.org](https://ci.concourse-ci.org) is used. If you want to test with your own, which is required for the authentication tests, supply the environment variables listed in `.envrc.sample`.

# Misc

The propeller logo is in the [public domain](https://thenounproject.com/search/?q=propeller&i=13111).

# TODO

* Authentication works only for basic auth and the `main` team. We need a proper oauth flow similar to [what fly does](https://github.com/concourse/fly/blob/v4.0.1-rc.29/commands/login.go#L159).
* Use images from the Concourse server:
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_pause_blue.svg
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_pending_grey.svg
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_failing_red.svg
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_aborted_brown.svg
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_running_green.svg
    https://ci.flintstone.cf.cloud.ibm.com/public/images/ic_error_orange.svg
* Allow limiting the number of builds shown
* Use Excon in order to get easy tracing
* Order latest builds in presenter first by status and then by last-run date so that the broken ones appear at the top
* Use TerminalNotifier when a build is failing:

  TerminalNotifier.notify('Hello World', :open => 'http://twitter.com/alloy')

  Also, keep state about each job and notify only on a change (red => green etc.)
* Ignore certain jobs, e.g. releasing a lock
