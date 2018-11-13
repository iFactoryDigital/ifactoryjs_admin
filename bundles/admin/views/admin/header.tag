<admin-header>
  <div class="jumbotron jumbotron-admin mb-3">
    <div class="container-fluid">
      <div class="row row-eq-height">
        <div class="col-md-8 d-flex align-items-center">
          <div class="w-100">
        
            <h1 class="m-0">
              { opts.title }
            </h1>
          
          </div>
        </div>
        <div class="col-md-4 d-flex align-items-center text-right">
          <div class="w-100">
        
            <yield from="right" />
        
          </div>
        </div>
      </div>
    </div>
  </div>
</admin-header>
