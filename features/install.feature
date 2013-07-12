Feature: Install

  In Rails projects, Kender tasks are loaded automatically. For other
  projects, add `require 'kender/tasks'` to your `Rakefile` or wherever your
  local rake tasks are defined.

  Scenario: Require Kender tasks in Rakefile
    Given a file named "Rakefile" with:
      """
      require 'kender/tasks'
      """
    When I run `rake ci`
    Then the exit status should be 0
