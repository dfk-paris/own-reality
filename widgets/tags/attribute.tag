<or-attribute title={desc()}>

  <span if={data()}>{short()}</span>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.data = ->
      tag.opts.attrib || wApp.cache.data.attrs[tag.opts.key]
    tag.full = -> 
      tag.lv(tag.data().name)
    tag.short = ->
      amount = tag.opts.shortenTo || 30
      result = tag.full()
      if result.length > amount
        result.substr(0, amount - 1) + '…'
      else
        result
    tag.desc = ->
      if tag.data()
        "#{tag.data().id}: #{tag.full()}"
      else
        null
  </script>

</or-attribute>