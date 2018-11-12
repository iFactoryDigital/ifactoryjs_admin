
// require dependencies
const Helper = require('helper');

// require models
const Dashboard = model('dashboard');

/**
 * build dashboard helper
 */
class DashboardHelper extends Helper {
  /**
   * construct dashboard helper
   */
  constructor () {
    // run super
    super();

    // bind methods
    this.build = this.build.bind(this);

    // run build method
    this.build();
  }

  /**
   * builds dashboard helper
   */
  build () {
    // build dashboard helper
    this.__widgets = [];

  }

  /**
   * register widget
   *
   * @param  {String}   type
   * @param  {Object}   opts
   * @param  {Function} render
   *
   * @return {*}
   */
  widget (type, opts, render) {
    // check found
    let found = this.__widgets.find((widget) => widget.type === type);

    // push widget
    if (!found) {
      // check found
      this.__widgets.push({
        'type'   : type,
        'opts'   : opts,
        'render' : render
      });
    } else {
      // set on found
      found.type   = type;
      found.opts   = opts;
      found.render = render;
    }
  }

  /**
   * returns dashboard list
   *
   * @param  {User}    user
   * @param  {String}  type
   *
   * @return {Promise}
   */
  async render (type, user) {
    // return object
    return {
      'widgets' : this.__widgets.map((widget) => {
        // return widget
        return {
          'type' : widget.type,
          'opts' : widget.opts
        };
      }),
      'dashboards' : await Promise.all((await Dashboard.find({
        'type'    : type,
        'user.id' : user.get('_id').toString()
      })).map((dashboard) => dashboard.sanitise()))
    };
  }
}

/**
 * export new dashboardHelper class
 *
 * @return {dashboardHelper}
 */
module.exports = new DashboardHelper();
