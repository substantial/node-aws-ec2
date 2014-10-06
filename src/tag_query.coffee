requiredInstanceFinder = require './instance_finder'

module.exports = class TagQuery

  constructor: (config, InstanceFinder = requiredInstanceFinder) ->
    @instanceFinder = new InstanceFinder(config)

  findByTags: (tags, callback) ->
    filters = []

    filters.push
      Name: "instance-state-name"
      Values: ["running"]

    for tag, value of tags
      filters.push
        Name: "tag:#{tag}"
        Values: [value]

    @instanceFinder.findWithFilters filters, callback
