<or-register-results>

  <div>
    <div each={result in data.records}>
      <or-attribute
        if={result._type == 'attribs'}
        attrib={result._source}
      ></or-attribute>
      <or-person
        if={result._type == 'people'}
        person={result._source}
        machine={true}
      ></or-person>
    </div>
  </div>

  <script type="text/coffee">
    self = this

    self.or.bus.on 'register-results', (data) ->
      console.log data
      self.data = data
      self.update()

  </script>

</or-register-results>