<or-journal-and-volume>

  <span if={!opts.asButton}>
    <span class="journal">{journal()}</span><!-- 
    --><span class="volume" if={volume()}>, {volume()}</span>
  </span>
  <span if={opts.asButton} class="or-list">
    <span class="or-list-element">
      <span data-journal-name={opts.item._source.journal}>
        <span class="journal">{journal()}</span>
        <span class="volume" if={hasVolume()}>, {volume()}</span>
      </span>
    </span>
  </span>

  <script type="text/coffee">
    tag = this

    tag.journal = -> tag.opts.item._source.journal
    tag.volume = -> tag.opts.item._source.volume
  </script>

</or-journal-and-volume>