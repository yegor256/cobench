Feature: Simple Reporting
  I want to be able to build a report

  Scenario: Help can be printed
    When I run bin/cobench with "-h"
    Then Exit code is zero
    And Stdout contains "--help"

  Scenario: Version can be printed
    When I run bin/cobench with "--version"
    Then Exit code is zero

  Scenario: Simple report
    When I run bin/cobench with "--coder yegor256 --verbose --dry --to foo"
    Then Stdout contains "XML saved to"
    And Exit code is zero

