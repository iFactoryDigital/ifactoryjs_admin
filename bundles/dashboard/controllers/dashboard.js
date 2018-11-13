
// require dependencies
const Grid       = require('grid');
const socket     = require('socket');
const Controller = require('controller');

// require models
const Widget    = model('widget');
const Dashboard = model('dashboard');

// require helpers
const ModelHelper     = helper('model');
const DashboardHelper = helper('dashboard');

/**
 * build dashboard controller
 *
 * @mount /dashboard
 */
class DashboardController extends Controller {
  /**
   * construct user DashboardController controller
   */
  constructor () {
    // run super
    super();

    // bind methods
    this.viewAction   = this.viewAction.bind(this);
    this.updateAction = this.updateAction.bind(this);
    this.removeAction = this.removeAction.bind(this);

    // register simple widget
    DashboardHelper.widget('dashboard.notes', {
      'title'       : 'Notes Area',
      'description' : 'Lets you add notes to a widget'
    }, async (req, widget) => {
      // get notes widget from db
      let widgetModel = await Widget.findOne({
        'uuid' : widget.uuid
      }) || new Widget({
        'uuid' : widget.uuid,
        'type' : widget.type
      });

      // return
      return {
        'tag'     : 'notes',
        'title'   : widgetModel.get('title') || '',
        'content' : widgetModel.get('content') || ''
      };
    }, async (req, widget) => {
      // get notes widget from db
      let widgetModel = await Widget.findOne({
        'uuid' : widget.uuid
      }) || new Widget({
        'uuid' : widget.uuid,
        'type' : widget.type
      });

      // set data
      widgetModel.set('title',   req.body.data.title);
      widgetModel.set('content', req.body.data.content);

      // save widget
      await widgetModel.save();
    });
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.listen.dashboard
   * @return {Async}
   */
  async listenAction (id, uuid, opts) {
    // join room
    opts.socket.join('dashboard.' + id);

    // add to room
    return await ModelHelper.listen(opts.sessionID, await Dashboard.findById(id), uuid);
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.deafen.dashboard
   * @return {Async}
   */
  async liveDeafenAction (id, uuid, opts) {
    // add to room
    return await ModelHelper.deafen(opts.sessionID, await Dashboard.findById(id), uuid);
  }

  /**
   * add/edit action
   *
   * @route    {get} /:id/view
   * @layout   admin
   * @priority 12
   */
  async viewAction (req, res) {
    // set website variable
    let create    = true;
    let dashboard = new Dashboard();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      dashboard = await Dashboard.findById(req.params.id);
    }

    // res JSON
    let sanitised = await dashboard.sanitise();

    // return JSON
    res.json({
      'state'  : 'success',
      'result' : (await Promise.all((dashboard.get('widgets') || []).map(async (widget) => {
        // get from register
        let registered = DashboardHelper.widgets().find((w) => w.type === widget.type);

        // check registered
        if (!registered) return null;

        // get data
        let data = await registered.render(req, widget);

        // set uuid
        data.uuid = widget.uuid;

        // return render
        return data;
      }))).filter((w) => w),
      'message' : 'Successfully got widgets'
    });
  }

  /**
   * save widget action
   *
   * @route    {post} /:id/widget/save
   * @layout   admin
   * @priority 12
   */
  async saveWidgetAction (req, res) {
    // set website variable
    let create    = true;
    let dashboard = new Dashboard();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      dashboard = await Dashboard.findById(req.params.id);
    }

    // get widget
    let widgets = dashboard.get('widgets') || [];
    let current = widgets.find((widget) => widget.uuid === req.body.widget.uuid);

    // update
    let registered = DashboardHelper.widgets().find((w) => w.type === current.type);

    // await save
    await registered.save(req, current);

    // get rendered
    let rendered = await registered.render(req, current);

    // set uuid
    rendered.uuid = req.body.widget.uuid;

    // emit
    socket.room('dashboard.' + dashboard.get('_id').toString(), 'dashboard.' + dashboard.get('_id').toString() + '.widget', rendered);

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : rendered,
      'message' : 'Successfully saved widget'
    });
  }

  /**
   * remove widget action
   *
   * @route    {post} /:id/widget/remove
   * @layout   admin
   * @priority 12
   */
  async removeWidgetAction (req, res) {
    // get notes widget from db
    let widgetModel = await Widget.findOne({
      'uuid' : req.body.widget.uuid
    }) || new Widget({
      'uuid' : req.body.widget.uuid,
      'type' : req.body.widget.type
    });

    // remove widget
    if (widgetModel.get('_id')) await widgetModel.remove();

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : null,
      'message' : 'Successfully removed widget'
    });
  }

  /**
   * create submit action
   *
   * @route  {post} /create
   * @layout admin
   */
  createAction () {
    // return update action
    return this.updateAction(...arguments);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route  {post} /:id/update
   * @layout admin
   */
  async updateAction (req, res) {
    // set website variable
    let create    = true;
    let dashboard = new Dashboard();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      dashboard = await Dashboard.findById(req.params.id);
    }

    // update dashboard
    dashboard.set('user',       req.user);
    dashboard.set('type',       req.body.type);
    dashboard.set('name',       req.body.name);
    dashboard.set('widgets',    req.body.widgets);
    dashboard.set('placements', req.body.placements);

    // save dashboard
    await dashboard.save();

    // send alert
    req.alert('success', 'Successfully ' + (create ? 'Created' : 'Updated') + ' dashboard!');

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : await dashboard.sanitise(),
      'message' : 'Successfully updated dashboard'
    });
  }

  /**
   * delete action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/remove
   * @title   Remove dashboard
   * @layout  admin
   */
  async removeAction (req, res) {
    // set website variable
    let dashboard = false;

    // check for website model
    if (req.params.id) {
      // load user
      dashboard = await Dashboard.findById(req.params.id);
    }

    // alert Removed
    req.alert('success', 'Successfully removed ' + (dashboard.get('_id').toString()));

    // delete website
    await dashboard.remove();

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : null,
      'message' : 'Successfully removed dashboard'
    });
  }
}

/**
 * export dashboard controller
 *
 * @type {DashboardController}
 */
module.exports = DashboardController;
