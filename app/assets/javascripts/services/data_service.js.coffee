app.service "data_service", [
  "$http", "utils",
  (http, u) ->
    service = {
      search: (params = {}) ->
        http(
          method: "post"
          url: "/api/entities/search",
          data: {criteria: params}
        )
      show: (id) ->
        http(
          method: "post"
          url: "/api/entities/#{id}"
        )
      lookup: (ids = []) ->
        http(
          method: "post"
          url: "/api/entities/lookup",
          data: {ids: ids}
        )
      lookup_for: (data, form) ->
        ids = []
        for akey, aggregation of data.aggregations
          for bucket in aggregation.buckets
            ids.push(bucket.key)
        for ref in form.refs
          ids.push ref
        service.lookup(ids)
      init: ->
        http(
          method: "get"
          url: "/api/translations"
        ).success (data) -> 
          service.translations = data
          service.grouped_people = u.in_groups_of(service.people, 3)
          service.grouped_journals = u.in_groups_of(service.journals, 3)
          
        http(
          method: "get"
          url: "/api/misc"
        ).success (data) -> service.misc = data
      
      people: ["Maxie Kautzer", "Lurline Quigley", "Chadd Boyle", "Lexie Runolfsdottir", "Maybelle Schultz", "Vinnie Renner", "Beau Armstrong", "Brando Auer", "Eulalia Russel", "Doug Zulauf", "Meta Braun", "Winfield Zulauf", "Ross Jast", "Silas Kautzer", "Regan Reynolds", "Ford Oberbrunner", "Elmira Heaney", "Gabe Pfannerstill", "Keyshawn Wolf", "Maxie Zulauf", "Carlee Bosco", "Polly Bahringer", "Federico Green", "Beaulah Huel", "Zena Rodriguez", "Gracie Mohr", "Coy Leffler", "Amie Donnelly", "Reece Schmitt", "Nelda Ferry", "Norwood Boyer", "Brendon Hudson", "Tyrese Carter", "Mabel Parisian", "Elena Luettgen", "Elmira Morar", "Susie Murazik", "Palma Kuphal", "Kobe Ernser", "Milo Walker", "Gerard Denesik", "Pink Gutkowski", "Rhett Carter", "Arely Schmitt", "Hardy Ortiz", "Anissa Walsh", "Amelie Nader", "Constantin Rosenbaum", "Austen Turcotte", "Emile Langworth", "Hobart Rogahn", "Benedict Kerluke", "Conner Swift", "Edgardo Bartell", "Aniyah Harvey", "Stevie Torp", "Anya Jacobson", "Carlotta Stracke", "Marina Witting", "Edwina Blick", "Eryn Hilpert", "Darryl Davis", "Melyssa Schowalter", "Eldora Metz", "Isidro D'Amore", "Dallas Effertz", "Rosa Schoen", "Maximillian Barrows", "Mitchell Mayert", "Zoie Altenwerth", "Judd Boyle", "Ansley Schultz", "Electa Keeling", "Elna Klein", "Danyka Johnston", "Melany Brakus", "Mittie Champlin", "Rossie Johnson", "Dylan Lind", "Okey Barton", "Malcolm Towne", "Jeramy Dooley", "Lester Blanda", "Shanie Green", "Rene Cole", "Kaylah Kirlin", "Bernie Luettgen", "Laura Feil", "Tess Runte", "Anastacio Batz", "Leora Walker", "Felton Johnston", "Krystel Corwin", "Lilian Kiehn", "Yasmine Emmerich", "Myriam Cole", "Tyrel Schulist", "Edd Gottlieb", "Raheem Bartell", "Sebastian Marks"],
      journals: ["Wolff, Cummerata and Nitzsche", "Keebler-Ortiz", "O'Kon-Willms", "Terry LLC", "Ledner and Sons", "Deckow, Fisher and Lang", "Larkin-Corkery", "Cole-Muller", "Herman, Cummerata and Paucek", "Medhurst-Tromp", "Huels-Medhurst", "Olson Inc", "Ziemann-Gleason", "Treutel LLC", "Reynolds Group", "Mann-Hauck", "Schimmel, Pouros and Kshlerin", "Prosacco-Towne", "Stark Inc", "Abernathy-Windler", "Roberts, Bogan and Cummings", "Kerluke LLC", "Streich-Medhurst", "Gibson-Kihn", "Schumm, Connelly and Konopelski", "Runolfsson-Klocko", "Murray-Lemke", "Pagac and Sons", "Kautzer-Baumbach", "Leuschke, Graham and Heaney"],
      locales: {
        "de": "deutsch"
        "fr": "français"
      }
    }

    service.init()

    service
]