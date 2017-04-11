<or-attribute-list>

  <span class="or-list">
    <span each={key in opts.keys} class="or-list-element">
      <or-attribute key={key} />
    </span>
  </span>

  <style type="text/scss">
    or-attribute-list {
      .or-list {
        line-height: 1.5rem;
        
        .or-list-element {
          padding-right: 0.2rem;

          or-attribute {
            font-size: 0.7rem;
            border-radius: 3px;
            padding: 0.2rem;
            background-color: darken(#ffffff, 20%);
            white-space: nowrap;
          }
        }
      }
    }
  </style>

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      if tag.opts.keys
        wApp.cache.attributes(tag.opts.keys).then -> console.log arguments
    
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

  </script>
  
</or-attribute-list>