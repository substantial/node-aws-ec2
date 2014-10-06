InstanceFinder = require("../src/instance_finder")

describe 'InstanceFinder', ->

  subject = null
  stubAWS = null
  stubEc2 = null
  stubData =
    Reservations: [
      {
        Instances: [
          "instance_1"
        ]
      },
      {
        Instances: [
          "instance_2"
        ]
      }
    ]
  stubCredentials =
    creds: "aws_creds"
  stubConfig =
    accessKeyId: "access_key_id"
    region: "aws_region"
    secretAccessKey: "secret_access_key"

  describe "construction", ->
    beforeEach ->
      stubEc2 =
        describeInstances: sinon.stub().withArgs('filters').yields(null, stubData)
      stubAWS =
        Credentials: sinon.stub().withArgs('access_key_id', 'secret_access_key').returns(stubCredentials)
        config: {}
        EC2: sinon.stub().returns(stubEc2)

      subject = new InstanceFinder(stubConfig, stubAWS)

    it "should apply the config's AWS credentials", ->
      stubAWS.config.credentials.should.eql stubCredentials

    it "should apply the config's AWS region", ->
      stubAWS.config.region.should.eql 'aws_region'
