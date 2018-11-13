<dashboard>
  <div class="dashboard">
    <div class="dashboard-options my-4">
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
    <div ref="dashboard" class="widget-placements" if={ !this.placing }>
      <div each={ row, x in this.rows } data-row={ x } class="row mb-3 row-eq-height">
        <div each={ widget, i in getWidgets(x) } data-widget={ widget.uuid } if={ getWidgetData(widget) } class="col" data-is="widget-{ getWidgetData(widget).tag }" data={ getWidgetData(widget) } widget={ widget } on-save={ this.onSaveWidget } on-remove={ onRemoveWidget } on-refresh={ this.onRefreshWidget } />
      </div>
    </div>
  </div>

  <dashboard-modal-widget widgets={ (opts.dashboard || {}).widgets } add-widget={ onAddWidget } />

  <script>
    // do mixins
    this.mixin('model');

    // set dashboards
    let dashboards = (opts.dashboard || {}).dashboards;

    // set update
    this.rows      = [1, 2, 3, 4, 5, 6, 7, 8];
    this.type      = opts.type;
    this.widgets   = [];
    this.current   = '';
    this.loading   = {};
    this.updating  = {};
    this.dashboard = dashboards && dashboards.length ? this.model('dashboard', dashboards[0]) : this.model('dashboard', {});

    /**
     * gets widgets
     *
     * @param  {Integer} i
     *
     * @return {*}
     */
    getWidgets (i) {
      // check widgets
      if (!this.dashboard.get('widgets')) return [];
      if (!this.dashboard.get('placements')) return [];

      // check widgets
      let row = [];

      // get placements
      let widgets = this.dashboard.get('placements')[i];

      // check widgets
      if (!widgets) return [];

      // return widgets
      return widgets.map((widget) => {
        // return found
        return this.dashboard.get('widgets').find((w) => w.uuid === widget);
      }).filter((item) => item);
    }

    /**
     * get widget data
     *
     * @param  {Object} widget
     *
     * @return {*}
     */
    getWidgetData (widget) {
      // get found
      let found = this.widgets.find((w) => w.uuid === widget.uuid);

      // gets data for widget
      if (!found) return null;

      // return found
      return found;
    }

    /**
     * on refresh widget
     *
     * @param  {Event}  e
     * @param  {Object} widget
     */
    async onSaveWidget (widget, data, preventUpdate) {
      // prevent update check
      if (!preventUpdate) {
        // set loading
        widget.saving = true;

        // update view
        this.update();
      }

      // log data
      let res = await fetch('/dashboard/' + this.dashboard.get('id') + '/widget/save', {
        'body' : JSON.stringify({
          'data'   : data,
          'widget' : widget
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to dashboard
        data[key] = result.result[key];
      }
      
      // check prevent update
      if (!preventUpdate) {
        // set loading
        delete widget.saving;

        // update view
        this.update();
      }
    }

    /**
     * on refresh widget
     *
     * @param  {Event}  e
     * @param  {Object} widget
     */
    async onRefreshWidget (widget, data) {
      // set loading
      widget.refreshing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/dashboard/' + this.dashboard.get('id') + '/widget/save', {
        'body' : JSON.stringify({
          'data'   : data,
          'widget' : widget
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to dashboard
        data[key] = result.result[key];
      }

      // set loading
      delete widget.refreshing;

      // update view
      this.update();
    }

    /**
     * on refresh widget
     *
     * @param  {Event}  e
     * @param  {Object} widget
     */
    async onRemoveWidget (widget, data) {
      // set loading
      widget.removing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/dashboard/' + this.dashboard.get('id') + '/widget/remove', {
        'body' : JSON.stringify({
          'data'   : data,
          'widget' : widget
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // remove from everywhere
      this.dashboard.set('widgets', this.dashboard.get('widgets').filter((w) => {
        // check found in row
        return widget.uuid !== w.uuid;
      }));

      // set placements
      this.dashboard.set('placements', this.dashboard.get('placements').map((row) => {
        // filter row
        return row.filter((id) => id !== widget.uuid);
      }));

      // save dashboard
      await this.saveDashboard(this.dashboard);

      // set loading
      delete widget.removing;

      // update view
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
      await this.loadWidgets(this.dashboard);
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
     * saves placements
     *
     * @return {Promise}
     */
    async savePlacements () {
      // set placements
      let placements = [];

      // each row
      jQuery('> .row', this.refs.dashboard).each((i, item) => {
        // get row
        let row = [];

        // get each item in row
        jQuery('[data-widget]', item).each((x, widget) => {
          // push to row
          row.push(jQuery(widget).attr('data-widget'));
        });

        // push row to placements
        placements.push(row);
      });

      // set loading
      this.placing = true;
      this.loading.placements = true;

      // update view
      this.update();

      // filter widgets
      this.dashboard.set('widgets', this.dashboard.get('widgets').filter((widget) => {
        // check found in row
        return placements.find((row) => {
          // return id === widget id
          return row.find((id) => id === widget.uuid);
        })
      }));

      // set placements
      this.dashboard.set('placements', placements);

      // set placing
      this.placing = false;

      // update view
      this.update();
      
      // init dragula again
      this.initDragula();

      // save
      await this.saveDashboard(this.dashboard);

      // set loading
      this.loading.placements = false;

      // update view
      this.update();
    }

    /**
     * loads dashboard widgets
     *
     * @param  {Model} dashboard
     *
     * @return {Promise}
     */
    async loadWidgets (dashboard) {
      // set loading
      this.loading.widgets = true;

      // update view
      this.update();

      // check type
      if (!dashboard.type) dashboard.set('type', opts.type);

      // log data
      let res = await fetch('/dashboard/' + this.dashboard.get('id') + '/view', {
        'method'  : 'get',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set widgets
      this.widgets = data.result;

      // set loading
      this.loading.widgets = false;

      // update view
      this.update();
    }
    
    /**
     * init dragula
     */
    initDragula () {
      // require dragula
      const dragula = require('dragula');
      
      // do dragula
      this.dragula = dragula(jQuery('.row', this.refs.dashboard).toArray()).on('drop', (el, target, source, sibling) => {
        // save order
        this.savePlacements();
      }).on('drag', () => {
        // add is dragging
        jQuery(this.refs.dashboard).addClass('is-dragging');
      }).on('dragend', () => {
        // remove is dragging
        jQuery(this.refs.dashboard).removeClass('is-dragging');
      });
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
      
      // init dragula
      if (!this.dragula) this.initDragula();
  
      // set dashboards
      let dashboards = (opts.dashboard || {}).dashboards;
      
      // set dashboard
      this.dashboard = dashboards && dashboards.length ? this.model('dashboard', dashboards[0]) : this.model('dashboard', {});

      // check id
      if (this.dashboard.get('id')) this.loadWidgets(this.dashboard);
      
      // loads widget
      socket.on('dashboard.' + this.dashboard.get('id') + '.widget', (widget) => {
        // get found
        let found = this.widgets.find((w) => w.uuid === widget.uuid);
        
        // check found
        if (!found) {
          // push
          this.widgets.push(widget);
          
          // return update
          return this.update();
        }
        
        // set values
        for (let key in widget) {
          // set value
          found[key] = widget[key];
        }
        
        // update
        this.update();
      });
    });
  </script>
</dashboard>
