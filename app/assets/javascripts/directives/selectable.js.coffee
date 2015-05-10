app.directive "orSelectable", [
  ->
    directive = {
      restrict: "EAC"
      link: (scope, element, attrs) ->
        state = false

        element.on "mouseover", -> element.addClass("bg-info")
        element.on "mouseout", -> element.removeClass("bg-info")
        element.on "click", -> element.toggleClass("bg-primary")
    }
]