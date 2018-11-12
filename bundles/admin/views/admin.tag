<admin-page>
  <section class="jumbotron jumbotron-welcome text-center">
    <h1 class="jumbotron-heading">Welcome back, { this.user.username }!</h1>
  </section>
  
  <div data-is="dashboard" dashboard={ opts.dashboard } class="container-fluid container-dashboard" type="admin.home" name="Admin Home" />
  
  <script>
    // do mixins
    this.mixin('user');
    
  </script>
</admin-page>
