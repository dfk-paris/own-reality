<or-interview>
  
  <div class="raw"></div>

  <style type="text/scss">
    or-interview, [riot-tag=or-interview] {
      padding: 1rem;
      height: 500px;
      overflow: scroll;

      h2 {
        margin-bottom: 1.5rem;
      }

      #ariane, h2.publiParente, div.type {
        display: none;
      }

      h3 {
        font-weight: inherit;

        .sousTitre {
          font-style: italic;
        }
      }

      div#texte {
        p {
          text-align: justify;

          span.paranumber {
            display: block;
            float: left;
            margin-left: -2em;
            color: #aea79f;
          }

          a.footnotecall {
            vertical-align: super;
            font-size: 0.7em;
          }

          img {
            max-width: 100%;
          }
        }
      }
    }
  </style>
  
  <script type="text/coffee">
    self = this
    self.or = window.or

    self.on 'mount', ->
      if self.opts.item
        self.cache_attributes()
      else
        $.ajax(
          type: 'GET'
          url: "#{self.or.config.api_url}/api/items/interviews/#{self.opts.id}"
          success: (data) ->
            console.log data
            self.opts.item = data
            self.cache_attributes()
            self.update()
        )

    self.cache_attributes = ->
      self.or.cache_attributes(self.opts.item._source.attrs.ids[6][43])

    self.on 'updated', ->
      if self.opts.item
        $(self.root).find('.raw').html(
          self.or.filters.l(self.opts.item._source.html)
        )
  </script>

</or-interview>