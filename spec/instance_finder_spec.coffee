InstanceFinder = require("../src/instance_finder")

describe 'InstanceFinder', ->

  subject = null
  stubAWS = null
  stubEc2 = null
  callback = null
  filters = 'filters'
  stubData =
    Reservations: [
      {
        Instances: [
          "instance_1"
        ]
      },
      {
        Instances: [
          "instance_2",
          "instance_3"
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

  describe "#findWithFilters", ->
    context "it succeeds", ->
      beforeEach ->
        callback = sinon.stub()
        stubEc2 =
          describeInstances: sinon.stub().withArgs('filters').yields(null, stubData)
        stubAWS =
          Credentials: sinon.stub().withArgs('access_key_id', 'secret_access_key').returns(stubCredentials)
          config: {}
          EC2: sinon.stub().returns(stubEc2)

        subject = new InstanceFinder(stubConfig, stubAWS)
        subject.findWithFilters filters, callback

      it 'calls the callback with the retrieved instances', ->
        callback.should.have.been.calledWith null, ['instance_1', 'instance_2', 'instance_3']

    context "there is an error", ->
      beforeEach ->
        callback = sinon.stub()
        stubEc2 =
          describeInstances: sinon.stub().withArgs('filters').yields('error')
        stubAWS =
          Credentials: sinon.stub().withArgs('access_key_id', 'secret_access_key').returns(stubCredentials)
          config: {}
          EC2: sinon.stub().returns(stubEc2)

        subject = new InstanceFinder(stubConfig, stubAWS)
        subject.findWithFilters filters, callback

      it 'calls the callback with the error', ->
        callback.should.have.been.calledWith 'error'
