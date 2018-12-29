const noobishRoutes = require('./noobish_routes');

module.exports = function(app, db) {
  noobishRoutes(app, db);
  // Other route groups could go here, in the future
};