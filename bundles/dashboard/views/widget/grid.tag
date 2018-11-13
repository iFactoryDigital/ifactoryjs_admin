<widget-grid>
  <widget on-refresh={ opts.onRefresh } on-remove={ opts.onRemove } widget={ opts.widget } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-grid-state={ onGridState } on-update-content={ onUpdateContent } ref="widget" class="widget-notes">
    <yield to="header">
      
      <!-- update buttons -->
      <a href="#!" onclick={ opts.onShouldUpdateTitle } if={ !this.updating.title && !this.loading.title }>
        <i class="fa fa-update fa-pencil" />
      </a>
      <a href="#!" onclick={ opts.onCompleteUpdateTitle } if={ this.updating.title && !this.loading.title }>
        <i class="fa fa-update fa-check bg-success text-white" />
      </a>
      <span if={ this.loading.title }>
        <i class="fa fa-update fa-spinner fa-spin bg-info text-white" />
      </span>
      <!-- / update buttons -->

      <i if={ !opts.data.title && !this.updating.title }>Untitled { opts.data.name }</i>
      <span if={ !this.updating.title || this.loading.title }>{ opts.data.title }</span>
      <i contenteditable={ this.updating.title } if={ this.updating.title && !this.loading.title } class="d-inline-block px-2" ref="name" onkeyup={ opts.onUpdateTitle }>{ opts.data.title }</i>

    </yield>
    <yield to="body">
      <div class="card-body">
        <grid ref="grid" grid={ opts.data.grid } table-class="table table-bordered table-striped" title={ opts.data.title || opts.widget.title } on-state={ opts.onGridState } />
      </div>
    </yield>
  </widget>

  <script>
  
    /**
     * on grid state
     *
     * @param  {Object} state
     */
    async onGridState (state) {
      // set name
      opts.data.state = state;

      // do update
      await opts.onSave(opts.widget, opts.data, true);
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onUpdateTitle (e) {
      // on enter
      let keycode = (event.keyCode ? event.keyCode : event.which);

      // check if enter
      if (parseInt(keycode) === 13) {
        // return on complete update
        return this.onCompleteUpdateTitle(e);
      }

      // set update
      opts.data.title = jQuery(e.target).val();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onCompleteUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.widget.loading.title = true;
      this.refs.widget.updating.title = false;

      // set name
      opts.data.title = jQuery('[ref="name"]', this.root).text();

      // update
      this.refs.widget.update();

      // do update
      await opts.onSave(opts.widget, opts.data);

      // set loading
      this.refs.widget.loading.title = false;

      // update
      this.refs.widget.update();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onShouldUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.widget.updating.title = !this.refs.widget.updating.title;

      // update
      this.refs.widget.update();

      // set inner test
      jQuery('[ref="name"]', this.root).focus();
    }

  </script>
</widget-grid>
