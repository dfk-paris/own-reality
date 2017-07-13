<or-user>
  <a
    href={lv(user().url)}
    target="_blank"
  >{user().first_name} {user().last_name}</a>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.user = -> wApp.config.server.people[opts.user]
  </script>
</or-user>