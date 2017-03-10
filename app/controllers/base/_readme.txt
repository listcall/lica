Apr 22, 2013

There was a lot of methods piling up in application_controller.

Wanted to use something like 'concerns' to organize these methods into different files.

But - couldn't get concerns to work on Rails 3.2.

So instead, we're monkey-patching ActionController::Base

It is working but - yukk.

At some point: refactor this code to use concerns.