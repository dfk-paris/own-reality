<or-journal-and-volume>

  <span if={!opts.asButton}>{label()}</span>
  <span if={opts.asButton} class="or-list">
    <span class="or-list-element">
      <span
        data-journal-name={opts.item._source.journal}
        class="or-journal"
      >
        {label()}
      </span>
    </span>
  </span>

  <style type="text/scss">
    or-journal-and-volume {
      .or-list {
        line-height: 1.5rem;
        
        .or-list-element {
          padding-right: 0.2rem;

          .or-journal {
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
    self = this

    self.journal = -> opts.item._source.journal
    self.volume = -> opts.item._source.volume
    self.label = -> "#{self.journal()}, #{self.volume()}"
  </script>

</or-journal-and-volume>