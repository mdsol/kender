Feature: PB Duplicates
  Kender is able to run the pb duplicates task against existing scenarios

  Scenario: The project has scenarios where no pb numbers are duplicated
    Given a file named "features/testing.feature" with:
    """
    Feature: test
    @PB10-001
    Scenario: first test
    @PB10-002
    Scenario: first test
    """
    When I run `rake pb:duplicates features=features`
    Then the exit status should be 0

  Scenario: The project has scenarios in same feature file where pb numbers are duplicated
    Given a file named "features/testing.feature" with:
    """
    Feature: test
    @PB10-001
    Scenario: first test
    @PB10-001
    Scenario: second test
    """
    When I run `rake pb:duplicates features=features`
    Then the exit status should not be 0

  Scenario: The project has scenarios in two separate feature files where pb numbers are duplicated
    Given a file named "features/testing.feature" with:
    """
    Feature: test
    @PB10-001
    Scenario: first test
    """
    And a file named "features/testing_two.feature" with:
    """
    Feature: test the 2nd
    @PB10-001
    Scenario: first test
    """
    When I run `rake pb:duplicates features=features`
    Then the exit status should not be 0

  Scenario: The project has scenarios in same feature file where pb numbers are duplicated
    Given a file named "features/test/testing.feature" with:
    """
    Feature: test
    @PB10-001
    Scenario: first test
    @PB10-001
    Scenario: second test
    """
    When I run `rake pb:duplicates features=features`
    Then the exit status should not be 0
