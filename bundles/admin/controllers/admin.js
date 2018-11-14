// Require local class dependencies
const Controller = require('controller');

// require models
const Dashboard = model('dashboard');

// get helpers
const BlockHelper = helper('cms/block');

/**
 * Create Admin Controller class. Only visible to people with the 'admin.view' role
 *
 * @acl   admin.view
 * @fail  /
 *
 * @mount /admin
 */
class AdminController extends Controller {

  /**
   * Construct Admin Controller class
   */
  constructor () {
    // Run super
    super();

    // Bind public methods
    this.indexAction = this.indexAction.bind(this);
  }

  /**
   * Admin index action
   *
   * @param    {Request}  req Express request
   * @param    {Response} res Express response
   *
   * @menu     {MAIN}  Admin
   * @menu     {ADMIN} Admin Home
   * @icon     fa fa-lock
   * @view     admin
   * @route    {get}   /
   * @layout   admin
   * @priority 100
   */
  async indexAction (req, res) {
    // get dashboards
    let dashboards = await Dashboard.where({
      'type' : 'admin.home'
    }).or({
      'user.id' : req.user.get('_id').toString()
    }, {
      'public' : true
    }).find();

    // Render admin page
    res.render('admin', {
      'name'       : 'Admin Home',
      'type'       : 'admin.home',
      'blocks'     : BlockHelper.renderBlocks(),
      'jumbotron'  : 'Welcome back, ' + req.user.get('username') + '!',
      'dashboards' : await Promise.all(dashboards.map(async (dashboard) => dashboard.sanitise()))
    });
  }

}

/**
 * Exports Admin Controller class
 *
 * @type {AdminController}
 */
exports = module.exports = AdminController;
