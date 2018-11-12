<dashboard-modal-widget>
  <div class="modal fade" id="dashboard-modal-widget" tabindex="-1" role="dialog" aria-labelledby="dashboard-modal-widget-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="dashboard-modal-widget-label">
            Select Dashboard Widget
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <ul class="list-group">
            <li each={ widget, i in opts.widgets || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(widget) } onclick={ onWidget }>
              <div class="d-flex w-100 justify-content-between">
                <h5 class="mb-1">
                  { widget.opts.title }
                </h5>
              </div>
              <p class="m-0">{ widget.opts.description }</p>
            </li>
          </ul>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="button" class={ 'btn btn-primary' : true, 'disabled' : !this.type || this.loading } disabled={ !this.type || this.loading } onclick={ onAddWidget }>
            { this.loading ? 'Adding widget...' : (this.type ? 'Add widget' : 'Select widget') }
          </button>
        </div>
      </div>
    </div>
  </div>
  
  <script>
    
    /**
     * on widget
     *
     * @param  {Event} e
     */
    onWidget (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate widget
      this.type = e.item.widget.type;
      
      // update view
      this.update();
    }

    /**
     * on widget
     *
     * @param  {Event} e
     */
    async onAddWidget (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // add widget by type
      await opts.addWidget(this.type);
      
      // set loading
      this.type    = null;
      this.loading = false;
      
      // update view
      this.update();
      
      // close modal
      jQuery('#dashboard-modal-widget').modal('hide');
    }
    
    /**
     * on is active
     *
     * @param  {Object}  widget
     *
     * @return {Boolean}
     */
    isActive (widget) {
      // return type
      return this.type === widget.type;
    }
    
  </script>
</dashboard-modal-widget>
