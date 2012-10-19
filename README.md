# Kender

Kender provides general tasks for the Continuous Integration system.
The goal is to be project and CI agnostic.

# Usage

Add this gem into your test group. It will bring some testing
dependencies.

To see the newly added tasks you can use:
```
rake -T
```
and see all the tasks starting with ci:

To run your project in the same way CI would run it, execute:
```
RAILS_ENV=test rake ci:run
```

# Contributing

We follow the gitflow model.

# Owners

* [Andrew Smith](mailto:asmith@mdsol.com)
* [Jordi Carres](mailto:jcarres@mdsol.com)
