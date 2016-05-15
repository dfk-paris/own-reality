<or-journal-and-volume>

  <span>{label()}</span>

  <script type="text/coffee">
    self = this
    

    self.journal = -> opts.item._source.journal
    self.volume = -> opts.item._source.volume
    self.label = -> "#{self.journal()}, #{self.volume()}"
  </script>

</or-journal-and-volume>