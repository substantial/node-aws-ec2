InstanceFinder = require("../src/instance_finder")

describe 'InstanceFinder', ->

  subject = null
  stubAWS = null
  stubEc2 = null
  callback = null
  roles = null
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

  beforeEach ->
    callback = sinon.stub()
    stubEc2 =
      describeInstances: sinon.stub().withArgs('filters').yields(null, stubData)
    stubAWS =
      Credentials: sinon.stub().withArgs('access_key_id', 'secret_access_key').returns(stubCredentials)
      config: {}
      EC2: sinon.stub().returns(stubEc2)

  describe "construction", ->
    beforeEach ->
      subject = new InstanceFinder(stubConfig, stubAWS)

    it "should apply the config's AWS credentials", ->
      stubAWS.Credentials.firstCall.args[0].should.equal 'access_key_id'
      stubAWS.Credentials.firstCall.args[1].should.equal 'secret_access_key'
      stubAWS.config.credentials.should.eql stubCredentials

    it "should apply the config's AWS region", ->
      stubAWS.config.region.should.eql 'aws_region'

  describe "#findWithFilters", ->
    context "it succeeds", ->
      beforeEach ->
        subject = new InstanceFinder(stubConfig, stubAWS)
        subject.findWithFilters filters, callback

      it 'calls the callback with the retrieved instances', ->
        callback.should.have.been.calledWith null, ['instance_1', 'instance_2', 'instance_3']

      it 'should set the aws credentials', ->
        stubAWS.config.credentials.should.equal stubCredentials

    context "there is an error", ->
      beforeEach ->
        stubEc2.describeInstances.withArgs('filters').yields('error')

        subject = new InstanceFinder(stubConfig, stubAWS)
        subject.findWithFilters filters, callback

      it 'calls the callback with the error', ->
        callback.should.have.been.calledWith 'error'
