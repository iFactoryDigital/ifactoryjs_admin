<widget-notes>
  <widget on-refresh={ opts.onRefresh } on-remove={ opts.onRemove } widget={ opts.widget } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="widget" class="widget-notes">
    <yield to="header">

      <i if={ !opts.data.title && !this.updating.title }>Untitled Notes</i>
      <span if={ !this.updating.title || this.loading.title }>{ opts.data.title }</span>
      <i contenteditable={ this.updating.title } if={ this.updating.title && !this.loading.title } class="d-inline-block px-2" ref="name" onkeyup={ opts.onUpdateTitle } />

      <!-- update buttons -->
      <a href="#!" onclick={ opts.onShouldUpdateTitle } if={ !this.updating.title && !this.loading.title }>
        <small>
          <i class="fa fa-pencil ml-3 text-primary" />
        </small>
      </a>
      <a href="#!" onclick={ opts.onCompleteUpdateTitle } if={ this.updating.title && !this.loading.title }>
        <small>
          <i class="fa fa-check ml-3 text-success" />
        </small>
      </a>
      <span if={ this.loading.title }>
        <small>
          <i class="fa fa-spinner fa-spin ml-3" />
        </small>
      </span>
      <!-- / update buttons -->

    </yield>
    <yield to="body">
      <div class="card-body p-0">
        <editor content={ opts.data.content } on-update={ opts.onUpdateContent } />
      </div>
    </yield>
  </widget>

  <script>

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
    async onUpdateContent (content) {
      // set name
      opts.data.content = content;

      // do update
      await opts.onSave(opts.widget, opts.data);
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
</widget-notes>
