<or-paper>
  
  <div class="raw"></div>

  <style type="text/scss">
    or-paper, [riot-tag=or-paper] {
      display: block;
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
    

    self.on 'updated', ->
      if self.opts.item
        if html = self.opts.item._source.html
          $(self.root).find('.raw').html(self.or.i18n.l(html))
        else
          $(self.root).find('.raw').html "NO CONTENT AVAILABLE"
  </script>

</or-paper>