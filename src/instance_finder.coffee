requiredAWS = require 'aws-sdk'
lodash = require 'lodash'

module.exports = class InstanceFinder

  constructor: (
    config,
    AWS = requiredAWS
  ) ->
    AWS.config.region = config.region
    AWS.config.credentials = new AWS.Credentials(config.access_key_id,
                                                 config.secret_access_key)
    @ec2 = new AWS.EC2

  findWithFilters: (filters, callback) ->
    @ec2.describeInstances { Filters: filters }, (err, data) ->
      return callback(err) if err?

      retrievedInstances = lodash.map(data.Reservations, ((result) -> result.Instances))

      callback null, lodash.flatten(retrievedInstances)
