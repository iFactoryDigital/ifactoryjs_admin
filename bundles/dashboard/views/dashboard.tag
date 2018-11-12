<dashboard>
  <div class="dashboard">
    <div class="dashboard-options">
      <div class="row row-eq-height">
        <div class="col-md-8">
          <h2 class="m-0">
            <i if={ !this.dashboard.get('name') && !this.updating.name }>Untitled Dashboard</i>
            <span if={ !this.updating.name || this.loading.name }>{ this.dashboard.get('name') }</span>
            <i contenteditable={ this.updating.name } if={ this.updating.name && !this.loading.name } class="d-inline-block px-2" ref="name" onkeyup={ onUpdateName } />

            <!-- update buttons -->
            <a href="#!" onclick={ onShouldUpdateName } if={ !this.updating.name && !this.loading.name }>
              <small>
                <i class="fa fa-pencil ml-3 text-primary" />
              </small>
            </a>
            <a href="#!" onclick={ onCompleteUpdateName } if={ this.updating.name && !this.loading.name }>
              <small>
                <i class="fa fa-check ml-3 text-success" />
              </small>
            </a>
            <span if={ this.loading.name }>
              <small>
                <i class="fa fa-spinner fa-spin ml-3" />
              </small>
            </span>
            <!-- / update buttons -->

          </h2>
        </div>
        <div class="col-md-4 text-right d-flex align-items-center">
          <div class="w-100">
            <button class="btn btn-primary" data-toggle="modal" data-target="#dashboard-modal-widget">
              Add Widget
            </button>
          </div>
        </div>
      </div>
    </div>
    <div ref="dashboard">
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
      <div class="row" />
    </div>
  </div>

  <dashboard-modal-widget widgets={ (opts.dashboard || {}).widgets } add-widget={ onAddWidget } />

  <script>
    // do mixins
    this.mixin('model');

    // set dashboards
    let dashboards = (opts.dashboard || {}).dashboards;

    // set update
    this.current   = '';
    this.loading   = {};
    this.updating  = {};
    this.dashboard = dashboards && dashboards.length ? this.model('dashboard', dashboards[0]) : this.model('dashboard', {});

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
     * adds widget by type
     *
     * @param  {String} type
     *
     * @return {*}
     */
    async onAddWidget (type) {
      // get uuid
      const uuid = require('uuid');

      // add widget to first row
      if (!this.dashboard.get('widgets')) this.dashboard.set('widgets', []);
      if (!this.dashboard.get('placements')) this.dashboard.set('placements', []);

      // get placements/widgets
      let widgets    = this.dashboard.get('widgets')    || [];
      let placements = this.dashboard.get('placements') || [];

      // check placements
      if (!placements.length) placements.push([]);

      // create widget
      let widget = {
        'uuid' : uuid(),
        'type' : type
      };

      // push to widgets
      widgets.push(widget);
      placements[0].unshift(widget.uuid);

      // set
      this.dashboard.set('widgets',    widgets);
      this.dashboard.set('placements', placements);

      // save dashboard
      await this.saveDashboard(this.dashboard);
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
        dashboard.set(key, data[key]);
      }

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }

    /**
     * on mount
     *
     * @type {Mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // require dragula
      const dragula = require('dragula');

      // do dragula
      if (!this.dragula) this.dragula = dragula(jQuery('.row', this.refs.dashboard).toArray());
    });
  </script>
</dashboard>
