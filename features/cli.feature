# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT
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
    When I run bin/cobench with "--coder yegor256 --coder Jeff --verbose --dry --to foo"
    Then Stdout contains "XML saved to"
    And Exit code is zero

  Scenario: Simple report through real GitHub API
    When I run bin/cobench with "--coder=yegor256 --include=*/* --days=1 --verbose --delay=5000"
    Then Stdout contains "XML saved to"
    And Exit code is zero

  Scenario: Simple report with defaults
    Given I have a ".cobench" file with content:
    """
    --verbose

    --coder=john
    """
    When I run bin/cobench with "--dry"
    Then Stdout contains "XML saved to"
    And Exit code is zero
