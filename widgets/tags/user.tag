<or-user>
  <a href="mailto:{user().email}">
    {user().first_name} {user().last_name}
  </a>

  <script type="text/coffee">
    self = this
    self.or = window.or

    self.user = -> self.or.config.server.people[opts.user]
  </script>
</or-user>