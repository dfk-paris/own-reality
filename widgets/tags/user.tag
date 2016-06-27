<or-user>
  <a
    href={or.i18n.l(user().url)}
    target="_blank"
  >{user().first_name} {user().last_name}</a>

  <script type="text/coffee">
    self = this

    self.user = -> self.or.config.server.people[opts.user]
  </script>
</or-user>