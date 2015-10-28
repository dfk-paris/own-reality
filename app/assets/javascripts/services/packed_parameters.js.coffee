app.service "packed_parameters", [
  "$state",
  (state) ->
    service = {
      pack: (object) ->
        json = angular.toJson(object)
        atob(json)
      unpack: (object) ->
        json = btoa(object)
        angular.fromJson(json)
      get: ->
        service.unpack(state.params.q)
      set: (object) ->
        state.params.q = pack(object)
      update: (object) ->
        result = service.get()
        angular.extend(result, object)
        service.set(result)
    }
]