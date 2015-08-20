app.directive "orPaper", [
  "$anchorScroll",
  (as) ->
    el = null

    directive = {
      restrict: "C"
      link: (scope, element) ->
        $('body').on "click", (event) ->
          within_popover = $(event.target).parents(".popover").length
          if el && !within_popover
            el.popover("destroy")
            el = null

        element.on "click", "a.footnotecall", (event) ->
          event.preventDefault()

          unless el
            event.stopPropagation()

            el = $(event.currentTarget)
            id = el.attr("id").replace(/^body/, '')
            num = id.replace(/^ftn/, '')
            text = $("a##{id}").parent().text().replace(/^\d* /, '')
            el.popover(
              title: "Footnote #{num}"
              content: text
              container: 'body'
              trigger: "manual"
            )
            el.popover("show")

        element.on "click", "a", (event) ->
          link = $(event.currentTarget)
          href = link.attr('href')
          if !link.hasClass("footnotecall") && href.match(/^#/)
            event.preventDefault()
            as(href.replace /^#/, '')

    }
]