(->
  riot.mixin 'ownreality', {'or': ownreality}, true
  $(document).ready -> ownreality.init()
)()
