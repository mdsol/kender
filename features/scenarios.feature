Feature: Scenarios
  Kender is able to run scenarious using the cucumber tool

  Scenario: The project has some scenarios to run
    Given a file named "Rakefile" with:
      """
      require 'kender/tasks'
      """
    And a file named "features/testing.feature" with:
      """
      Feature: test
      This is a test of my product
      Scenario: first test
      """
    When I run `rake ci`
    Then it should pass with:
    """
    1 scenario (1 passed)
    0 steps
    """

  Scenario: The project has no scenarios to run but cucumber is executed
    Given a file named "Rakefile" with:
      """
      require 'kender/tasks'
      """
    When I run `rake ci`
    Then it should pass with:
    """
    0 scenarios
    0 steps
    """
