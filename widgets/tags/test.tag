<or-test>
  <table>
    <thead>
      <tr>
        <th>Name</th>
        <th>Phone number</th>
        <th>Address</th>
        <th>Social</th>
      </tr>
    </thead>
    <tbody>
      <tr each={data}>
        <td>{name}</td>
        <td>{phone}</td>
        <td>{address}</td>
        <td>... twitter, facebook, linkedin ...</td>
      </tr>
    </tbody>
  </table>

  <script type="text/coffee">
    self = this

    self.data = [{"name":"Irving Wisozk","phone":"1-866-177-9870","address":"776 MacGyver Burg"},{"name":"Sandrine Strosin","phone":"734-654-5535 x14539","address":"2068 Jakubowski Ports"},{"name":"Davonte McClure","phone":"(913) 020-6300 x4644","address":"79700 Heller Union"},{"name":"Melyssa Welch","phone":"1-628-173-4705","address":"4210 Romaguera Heights"},{"name":"Ms. Javier Brekke","phone":"(560) 247-0861 x5310","address":"90629 Trenton Row"},{"name":"Rowan Conroy MD","phone":"197-439-2570","address":"92989 Schultz Inlet"},{"name":"Rory Swaniawski","phone":"253-866-0576 x40536","address":"6039 Marco Path"},{"name":"Mrs. Halie Ondricka","phone":"792.136.2115 x741","address":"89601 Lockman Branch"},{"name":"Alfredo Robel","phone":"654.486.8831","address":"1841 Brandt Shoal"},{"name":"Alison Cronin","phone":"154-162-5796 x762","address":"63985 Lorna Villages"}]
  </script>
</or-test>