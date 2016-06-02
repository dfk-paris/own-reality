Feature: Research tool

  Background:
    Given I am on the "front" page
    And I select language "deutsch"

  @javascript
  Scenario: Show the research tool
    Then I should see "Quellen" within "or-results"
    And I should see "Zeitschriften" within "or-results"
    And I should see "Interviews" within "or-results"
    And I should see "Aufsätze" within "or-results"
    And I should see 10 search results

  @javascript
  Scenario: Show a source entry within the dialog
    When I click "Notizbuch der Redaktion" within "or-results"
    Then I should see "Bundesrepublik Deutschland" within "or-attribute-list"

  @javascript
  Scenario Outline: Use a person facet
    When I click facet "<facet>"
    Then I should see "<facet>" within the search filters
    And I should not see the facet "<facet>"
    And there should be "<amount>" results
    When I click the search filter "<facet>"
    Then I should not see "<facet>" within the search filters
    And I should see the facet "<facet>"
    And there should be "2565" results

    Examples:
      | facet | amount |
      | Georges Boudaille | 43 |
      | Art press | 225 |
      | Malerei | 780 |

  @javascript
  Scenario: Switch to extended attribute list and search for an attribute
    When I click on "alle anzeigen (> 20)" within category "Länder"
    Then I should see "g (3)"
    When I click on character "g"
    Then I should see "Georgien"
    And I should see "Griechenland"
    And I should see "Guatemala"
    When I select language "englisch"
    Then I should see "g (5)"
    And I should see "Georgia"
    And I should see "German Democratic Republic"
    And I should see "Germany"
    And I should see "Greece"
    And I should see "Guatemala"
    When I click on "Germany"
    Then I should see "Klaus Honnef"
    And I should see "Krypto-Strukturen"



  # @javascript
  # Scenario: Use a journal facet
  #   When I click facet "Art press"
  #   Then I should see "Art press" within the search filters
  #   And I should not see the facet "Art press"
  #   And there should be "43" results
  #   When I click the search filter "Art press"
  #   Then I should not see "Art press" within the search filters
  #   And I should see the facet "Art press"
  #   And there should be "2565" results

  # @javascript
  # Scenario: Use an attribute facet