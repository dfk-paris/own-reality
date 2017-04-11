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
    self = this

    self.journal = -> opts.item._source.journal
    self.volume = -> opts.item._source.volume
    self.label = -> "#{self.journal()}, #{self.volume()}"
  </script>

</or-journal-and-volume>