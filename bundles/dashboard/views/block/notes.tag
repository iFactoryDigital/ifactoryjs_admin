<block-notes>
  <block on-refresh={ opts.onRefresh } on-remove={ opts.onRemove } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="block" class="block-notes">
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

      <i if={ !opts.data.title && !this.updating.title }>Untitled Notes</i>
      <span if={ !this.updating.title || this.loading.title }>{ opts.data.title }</span>
      <i contenteditable={ this.updating.title } if={ this.updating.title && !this.loading.title } class="d-inline-block px-2" ref="name" onkeyup={ opts.onUpdateTitle }>{ opts.data.title }</i>

    </yield>
    <yield to="body">
      <div class="card-body p-0">
        <editor content={ opts.data.content } on-update={ opts.onUpdateContent } />
      </div>
    </yield>
  </block>

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
      this.refs.block.loading.title = true;
      this.refs.block.updating.title = false;

      // set name
      opts.data.title = jQuery('[ref="name"]', this.root).text();

      // update
      this.refs.block.update();

      // do update
      await opts.onSave(opts.block, opts.data);

      // set loading
      this.refs.block.loading.title = false;

      // update
      this.refs.block.update();
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
      await opts.onSave(opts.block, opts.data);
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
      this.refs.block.updating.title = !this.refs.block.updating.title;

      // update
      this.refs.block.update();

      // set inner test
      jQuery('[ref="name"]', this.root).focus();
    }

  </script>
</block-notes>