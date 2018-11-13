
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Dashboard extends Model {
  /**
   * construct dashboard model
   */
  constructor () {
    // run super
    super(...arguments);
  }

  /**
   * sanitises dashboard
   *
   * @return {Promise}
   */
  async sanitise () {
    // return dashboard
    return {
      'id'         : this.get('_id') ? this.get('_id').toString() : null,
      'type'       : this.get('type'),
      'name'       : this.get('name'),
      'widgets'    : this.get('widgets')    || [],
      'placements' : this.get('placements') || []
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Dashboard;