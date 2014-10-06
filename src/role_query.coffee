requiredInstanceFinder = require './instance_finder'

module.exports = class RoleQuery

  constructor: (config, InstanceFinder = requiredInstanceFinder) ->
    @instanceFinder = new InstanceFinder(config)

  findByRoles: (roles, callback) ->
    filters = []

    filters.push
      Name: "instance-state-name"
      Values: ["running"]

    for tag, value of roles
      filters.push
        Name: "tag:#{tag}"
        Values: [value]

    @instanceFinder.findWithFilters filters, callback
