<admin-page>
  <section class="jumbotron jumbotron-admin text-center" if={ opts.jumbotron }>
    <h1 class="jumbotron-heading">{ opts.jumbotron }</h1>
  </section>
  
  <div data-is="dashboard" dashboard={ opts.dashboard } class="container-fluid container-dashboard" type={ opts.type || 'admin.home' } name={ opts.name || 'Admin Home' } />
  
  <script>
    // do mixins
    this.mixin('user');
    
  </script>
</admin-page>
