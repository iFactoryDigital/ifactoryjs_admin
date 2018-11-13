<widget>
  <div class="card h-100">
  
    <div class="card-header">
      <div class="row row-eq-height">
        <div class="col-8 d-flex align-items-center">
          <div class="w-100">
            <yield from="header" />
          </div>
        </div>
        <div class="col-4 d-flex align-items-center">
          <div class="w-100">
            <button class="btn btn-sm btn-primary float-right" onclick={ onRefresh }>
              <i class={ 'fa fa-sync' : true, 'fa-spin' : this.refreshing } />
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <yield from="body" />
    
    <yield from="footer" />
  </div>
  
  <script>
    // set variables
    this.loading = {};
    this.updating = {};
  
    /**
     * on refresh
     *
     * @param  {Event} e
     */
    async onRefresh (e) {
      // set refreshing
      this.refreshing = true;
      
      // update view
      this.update();

      // run opts
      if (opts.onRefresh) await opts.onRefresh(e, opts.widget);
      
      // set refreshing
      this.refreshing = false;
      
      // update view
      this.update();
    }
    
  </script>
</widget>
