Feature: Research tool

@javascript
Scenario: Show the research tool
  Given I am on the "front" page
  And I follow "Suche"
  Then I should see "Zeitstrahl UI"
  And I should see some search results