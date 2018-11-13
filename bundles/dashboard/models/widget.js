
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Widget extends Model {
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
      'id'   : this.get('_id') ? this.get('_id').toString() : null,
      'type' : this.get('type')
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Widget;
