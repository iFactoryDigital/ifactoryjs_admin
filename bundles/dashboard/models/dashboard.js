
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
  async sanitise (req) {
    // return dashboard
    return {
      'id'        : this.get('_id') ? this.get('_id').toString() : null,
      'type'      : this.get('type'),
      'name'      : this.get('name'),
      'placement' : await this.get('placement') ? await (await this.get('placement')).sanitise(req) : null
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Dashboard;
