<dashboard>
  <div class="dashboard">
    <div class="dashboard-options mb-5 mt-4">
      <div class="row row-eq-height">
        <div class="col-md-8">
          <h2 class="m-0" id="dashboard-select">

            <!-- update buttons -->
            <a href="#!" onclick={ onShouldUpdateName } if={ !this.updating.name && !this.loading.name }>
              <i class="fa fa-update fa-pencil" />
            </a>
            <a href="#!" onclick={ onCompleteUpdateName } if={ this.updating.name && !this.loading.name }>
              <i class="fa fa-update fa-check bg-success text-white" />
            </a>
            <span if={ this.loading.name }>
              <i class="fa fa-update fa-spinner fa-spin bg-info text-white" />
            </span>
            <!-- / update buttons -->
            
            <i if={ !this.dashboard.get('name') && !this.updating.name }>Untitled Dashboard</i>
            <span if={ !this.updating.name || this.loading.name }>{ this.dashboard.get('name') }</span>
            <i contenteditable={ this.updating.name } if={ this.updating.name && !this.loading.name } class="d-inline-block" ref="name" onkeyup={ onUpdateName }>{ this.dashboard.get('name') }</i>
          </h2>
        </div>
        <div class="col-md-4 text-right d-flex align-items-center">
          <div class="w-100">
            <button class="btn btn-primary" data-toggle="modal" data-target="#block-modal">
              Add Block
            </button>
          </div>
        </div>
      </div>
    </div>
    <editor-update placement={ this.dashboard.get('placement') || {} } for="dashboard" blocks={ opts.blocks } type={ opts.type } on-save={ onPlacement } />
  </div>

  <script>
    // do mixins
    this.mixin('model');

    // set dashboards
    let dashboards = opts.dashboards || [];

    // set update
    this.rows       = [1, 2, 3, 4, 5, 6, 7, 8];
    this.type       = opts.type;
    this.widgets    = [];
    this.current    = '';
    this.loading    = {};
    this.updating   = {};
    this.dashboard  = dashboards && dashboards.length ? this.model('dashboard', dashboards[0]) : this.model('dashboard', {});
    this.showSelect = false;

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onUpdateName (e) {
      // on enter
      let keycode = (event.keyCode ? event.keyCode : event.which);

      // check if enter
      if (parseInt(keycode) === 13) {
        // return on complete update
        return this.onCompleteUpdateName(e);
      }

      // set update
      this.dashboard.set('name', jQuery(e.target).text());
    }
    
    /**
     * set placement
     *
     * @param  {Placement} placement
     */
    async onPlacement (placement) {
      // check id
      if (placement.get('id') !== (this.dashboard.get('placement') || {}).id) {
        // update placement
        this.dashboard.set('placement', placement.get());
        
        // save
        await this.saveDashboard(this.dashboard);
      }
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onCompleteUpdateName (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.loading.name = true;
      this.updating.name = false;

      // set name
      this.dashboard.set('name', jQuery(this.refs.name).text());

      // update
      this.update();

      // do update
      await this.saveDashboard(this.dashboard);

      // set loading
      this.loading.name = false;

      // update
      this.update();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onShouldUpdateName (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.updating.name = !this.updating.name;

      // update
      this.update();

      // set inner test
      jQuery(this.refs.name).text(this.dashboard.get('name')).focus();
    }

    /**
     * saves dashboard
     *
     * @param  {Object}  dashboard
     *
     * @return {Promise}
     */
    async saveDashboard (dashboard) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!dashboard.type) dashboard.set('type', opts.type);

      // log data
      let res = await fetch('/dashboard/' + (dashboard.get('id') ? dashboard.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(this.dashboard.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set logic
      for (let key in data.result) {
        // clone to dashboard
        dashboard.set(key, data.result[key]);
      }

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }
    
    /**
     * on update
     *
     * @type {update}
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;
      
    });

    /**
     * on mount
     *
     * @type {mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;
  
      // set dashboards
      let dashboards = opts.dashboards || [];
      
      // set dashboard
      this.dashboard = dashboards && dashboards.length ? this.model('dashboard', dashboards[0]) : this.model('dashboard', {});
        
    });
  </script>
</dashboard>
