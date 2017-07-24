<or-attribute-list>

  <span class="or-badge-list">
    <span each={key in opts.keys} class="or-item-wrapper">
      <or-attribute key={key} onclick={clickAttribute} class="or-item" />
    </span>
  </span>

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      if tag.opts.keys
        wApp.cache.attributes(tag.opts.keys)
    
    tag.on 'updated', ->
      list = $(tag.root).find('.or-list')
      items = list.children()
      items.detach().sort (x, y) -> 
        xt = $(x).text()
        yt = $(y).text()
        if xt < yt
          -1
        else
          if xt == yt then 0 else 1
      list.append(items)

    tag.clickAttribute = (event) ->
      console.log 'al', event
      h(event) if h = tag.opts.onClickAttribute

  </script>
  
</or-attribute-list>