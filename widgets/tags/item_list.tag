<!-- remove this? -->

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
  </script>

</or-item-list>