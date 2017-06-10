<or-item-list>

  <or-pagination total={opts.total} per-page={opts.perPage} />

  <div class="or-list" if={opts.type != 'chronology'}>
    <or-list-item
      each={item in opts.items}
      item={item}
    />
  </div>

  <or-filtered-chronology
    if={opts.type == 'chronology'}
    items={opts.items}
  />

  <script type="text/coffee">
    tag = this

    tag.on 'mount', ->
      console.log tag.opts

      # probably not needed anymore
      # if tag.opts.type
      #   $.ajax(
      #     type: 'post'
      #     url: "#{wApp.api_url()}/api/entities/search"
      #     data: JSON.stringify(
      #       type: tag.opts.type
      #       per_page: 100
      #     )
      #     success: (data) ->
      #       # console.log data
      #       tag.opts.items = data.records
      #       tag.update()
      #   )
  </script>

</or-item-list>