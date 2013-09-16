Feature: Full Text Search
  As a researcher
  In order to find relevant objects
  I want to be able to search for text

  Background:
    Given an empty search index
    And the following spaces
      | name | description    | meta |
      | A    | lindelof thing | {}   |
    And the following properties
      | name | description | meta                                       |
      | P    | hausdorff   | { tags: ['separation'], aliases: ['T_2'] } |
      | Q    | regular     | { tags: ['separation'], aliases: ['T_3'] } |
      | R    | lindelof    | { tags: ['compactness'] }                  |
    Given that the indices have synced
    When I go to the search page

  Scenario: in descriptions
    When I search for "thing"
    Then I should see 1 result: "A"

  Scenario: in tags
    When I search for "separation"
    Then I should see 2 results: "P" and "Q"

  Scenario: in aliases
    When I search for "T_2"
    Then I should see 1 result: "P"

  Scenario: accross types
    When I search for "lindelof"
    Then I should see 2 results: "A" and "R"
