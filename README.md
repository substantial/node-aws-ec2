aws-sdk-ec2
===========

Simplifies interaction with the
[node aws-sdk](https://github.com/aws/aws-sdk-js).

## Querying Instances

`TagQuery` will filter running instances to
those that match the tag key and value pairs passed to it.

```Javascript

var awsConfig = {
  accessKeyId: 'Your aws key',
  secretAccessKey: 'secret access key',
  region: 'us-west'
};

var tags = {
  tagKey: 'tagValue'
};

var tagQuery = new AWSEC2.TagQuery(awsConfig);

tagQuery.findByTags(tags, function(err, instances) {
  console.log(instances);
});

```

The same query using filters, as described in the [aws-sdk documentation](http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/EC2.html#describeInstances-property):

```Javascript

var AWSEC2 = require("node-aws-ec2");
var instanceFinder = new AWSEC2.InstanceFinder(awsConfig);

var filters = [
  {
     Name: "tag:tagKey",
     Values: ["tagValue"]
   },
   {
     Name: "instance-state-name",
     Values: ["running"]
   }
];

instanceFinder.findWithFilters(filters, function(err, instances) {
  console.log(instances);
});

```
