<dashboard>
  <div class="dashboard">
    <div class="dashboard-options mb-5 mt-4">
      <div class="row row-eq-height">
        <div class="col-md-8">
          <h2 class="m-0" id="dashboard-select">

            <!-- update buttons -->
            <a href="#" onclick={ onShouldUpdateName } if={ !this.updating.name && !this.loading.name }>
              <i class="fa fa-update fa-pencil-alt" />
            </a>
            <a href="#" onclick={ onCompleteUpdateName } if={ this.updating.name && !this.loading.name }>
              <i class="fa fa-update fa-check bg-success text-white" />
            </a>
            <span if={ this.loading.name }>
              <i class="fa fa-update fa-spinner fa-spin bg-info text-white" />
            </span>
            <!-- / update buttons -->

            <i if={ !this.dashboard.get('name') && !this.updating.name }>Untitled Dashboard</i>
            <span if={ !this.updating.name || this.loading.name }>{ this.dashboard.get('name') }</span>
            <i contenteditable={ this.updating.name } if={ this.updating.name && !this.loading.name } class="d-inline-block" ref="name" onkeyup={ onUpdateName }></i>

            <div class="dropdown d-inline-block">
              <a href="#" class="ml-3" id="select-dashboard" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fa fa-chevron-down" />
              </a>
              <div class="dropdown-menu dropdown-menu-right" aria-labelledby="select-dashboard">
                <a href="#" each={ dash, i in opts.dashboards || [] } class={ 'dropdown-item' : true, 'active' : dashboard.get('id') === dash.id } onclick={ onDashboard }>
                  <i if={ !(dash.name || '').length }>Untitled Dashboard</i>
                  { dash.name }
                </a>
                <div class="dropdown-divider"></div>
                <a href="#!" class="dropdown-item" onclick={ onAddDashboard }>
                  Create new Dashboard
                </a>
              </div>
            </div>
          </h2>
        </div>
        <div class="col-md-4 text-right d-flex align-items-center">
          <div class="w-100">
            <button class="btn btn-{ this.dashboard.get('public') ? 'success' : 'info' } mr-3" onclick={ onTogglePublic }>
              { this.dashboard.get('public') ? 'Public' : 'Private' }
            </button>
            <button class={ 'btn' : true, 'btn-primary' : !this.isUpdate, 'btn-success' : this.isUpdate } onclick={ onToggleUpdate }>
              { this.isUpdate ? 'Save' : 'Update' }
            </button>
          </div>
        </div>
      </div>
    </div>
    <div data-is="eden-blocks" placement={ Object.assign({}, this.dashboard.get('placement') || {}) } position={ this.dashboard.get('id') } for="dashboard" preview={ !this.isUpdate } blocks={ opts.blocks } type={ opts.type } on-save={ onPlacement } positions={ this.positions } />
  </div>

  <script>
    // do mixins
    this.mixin('model');

    // require uuid
    const uuid = require('uuid');

    // set dashboards
    this.dashboards = (opts.dashboards || []).map((dash) => this.model('dashboard', dash));

    // set update
    this.type       = opts.type;
    this.loading    = {};
    this.isUpdate   = false;
    this.updating   = {};
    this.dashboard  = this.dashboards.length ? this.dashboards[0] : this.model('dashboard', {});
    this.showSelect = false;

    // set placements
    this.positions = opts.positions || [
      {
        'type'     : 'structure.row',
        'uuid'     : uuid(),
        'children' : []
      },
      {
        'type'     : 'structure.row',
        'uuid'     : uuid(),
        'children' : []
      },
      {
        'type'     : 'structure.row',
        'uuid'     : uuid(),
        'children' : []
      },
      {
        'type'     : 'structure.row',
        'uuid'     : uuid(),
        'children' : []
      },
      {
        'type'     : 'structure.row',
        'uuid'     : uuid(),
        'children' : []
      }
    ];

    /**
     * on add dashboard
     *
     * @param  {Event}  e
     */
    async onAddDashboard (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set dashboard
      this.dashboard = this.model('dashboard', {});

      // save dashboard
      await this.saveDashboard(this.dashboard);

      // get dashboard
      this.dashboards.push(this.dashboard);

      // save
      this.update();
    }

    /**
     * on add dashboard
     *
     * @param  {Event}  e
     */
    async onDashboard (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set dashboard
      this.dashboard = this.model('dashboard', e.item.dash);

      // save
      this.update();
    }

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
     * on toggle public
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onTogglePublic (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.loading.public = true;

      // set name
      this.dashboard.set('public', !this.dashboard.get('public'));

      // update
      this.update();

      // do update
      await this.saveDashboard(this.dashboard);

      // set loading
      this.loading.public = false;

      // update
      this.update();
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
     * on update name
     *
     * @param  {Event} e
     */
    onToggleUpdate (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.isUpdate = !this.isUpdate;

      // update
      this.update();
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

      // check type
      if (opts.type !== this.type) {
        // set type
        this.type = opts.type;

        // trigger mount
        this.trigger('mount');
      }

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
      this.dashboards = (opts.dashboards || []).map((dash) => this.model('dashboard', dash));

      // set dashboard
      this.dashboard = this.dashboard && this.dashboard.get('type') === opts.type ? this.dashboard : (this.dashboards.length ? this.dashboards[0] : this.model('dashboard', {}));

    });
  </script>
</dashboard>
