Feature: Scenarios
  Kender is able to run scenarios using the cucumber tool.

  Background:
    Given a file named "Gemfile" with:
      """
      gem 'cucumber', '~>1.3'
      """
    And I run `bundle install`

  Scenario: The project has no scenarios to run but cucumber is executed
    When I run `rake ci`
    Then it should pass with:
    """
    0 scenarios
    0 steps
    """

  Scenario: The project has some passing scenarios to run
    Given a file named "features/testing.feature" with:
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

  Scenario: The project has some non passing scenarios to run
    Given a file named "features/testing.feature" with:
      """
      Feature: test
      This is a test of my product
      Scenario: first test
      Then failing step
      """
    And a file named "features/step_definitions/steps.rb" with:
      """
      Given(/^failing step$/) do
        raise 'failed'
      end
      """
    When I run `rake ci`
    Then the exit status should not be 0
