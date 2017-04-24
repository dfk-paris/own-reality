<or-journal-and-volume>

  <span if={!opts.asButton}>{label()}</span>
  <span if={opts.asButton} class="or-list">
    <span class="or-list-element">
      <span
        data-journal-name={opts.item._source.journal}
        class="or-journal"
      >{journal()}</span>
      {volume()}
    </span>
  </span>

  <script type="text/coffee">
    tag = this

    tag.journal = -> tag.opts.item._source.journal
    tag.volume = -> tag.opts.item._source.volume
    tag.label = -> 
      "#{tag.journal()}, #{tag.volume()}"
  </script>

</or-journal-and-volume>