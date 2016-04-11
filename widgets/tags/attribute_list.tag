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
  
</or-attribute-list>