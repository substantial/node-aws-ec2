lodash = require "lodash"
TagQuery = require "../src/tag_query"

describe "TagQuery", ->

  subject = null
  stubInstanceFinder = null
  stubInstanceFinderInstance = null
  stubConfig = "config"
  expectedFilters = null
  callback = null

  describe "construction", ->
    beforeEach ->
      stubInstanceFinder = sinon.stub()

      subject = new TagQuery(stubConfig, stubInstanceFinder)

    it "makes a new instance finder with the config", ->
      stubInstanceFinder.should.have.been.calledWith stubConfig

  describe "#findByTags", ->
    beforeEach ->
      stubInstanceFinderInstance =
        findWithFilters: sinon.stub()
      stubInstanceFinder = sinon.stub().withArgs(stubConfig).returns(stubInstanceFinderInstance)

      callback = sinon.stub()

      tags =
        environment: "acceptance"
        Primary: "true"
        socket_bridge: "true"

      expectedFilters = [
        {
          Name: "tag:socket_bridge",
          Values: ["true"]
        },
        {
          Name: "tag:environment",
          Values: ["acceptance"]
        },
        {
          Name: "tag:Primary",
          Values: ["true"]
        },
        {
          Name: "instance-state-name",
          Values: ["running"]
        }
      ]

      subject = new TagQuery(stubConfig, stubInstanceFinder)
      subject.findByTags tags, callback

    it "queries the instance finder with the correct filters", ->
      stub = stubInstanceFinderInstance.findWithFilters
      stub.callCount.should.eql 1

      actualFilters = stub.firstCall.args[0]
      actualFilters.length.should.eql 4

      for filter in expectedFilters
        actualFilters.should.contain filter
