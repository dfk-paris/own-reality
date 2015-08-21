Feature: Chronology

@javascript
Scenario: Show the chronology
  When I am on the "front" page
  And I follow "Chronologie"
  Then I should see "Werner Schmidt"

@javascript
Scenario: Click an element on the chronology
  When I am on the "chronology" page
  And I click on chronology item "21153"
  Then I should see "Werner Schmidt, Leiter des Kupferstich-Kabinetts Dresden, reist nach Paris" within ".or-meta"