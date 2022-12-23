# GPS data aggregator

The idea behind this solution is pretty simple. Some devices sends its GPS data to the AWS cloud via simple HTTP post request. AWS Kinesis aggregates data and triggers special lambda `processor` to calculate in which region this point(or gps location) belongs to and do that for the configured tumbling window `60 sec by default`. Region radius can be reconfigured, by default its `100 km`. After that all data goes to the DynamoDB.
Data also can be fetched back by `area_name` where you can check how many GPS  
As a final solution you can deploy some simple WEB to display a heat map for the set of regions.

Solution has 2 Api Gateway endpoints:

`/add_point` - POST. Data format JSON. Example: `{'user_id': <int>, 'loc_x': <float>, 'loc_y': <float>}`

`/get_regions_data` - GET. Only 1 query param: `area_name=<area_name>` . Returns list of objects.

Its a test project, there is a plenty room for improvements actually :)

# Architecture

![AWS](/assets/aws.jpg)
![Regions](/assets/regions.jpg)

`radius` is configurable. So we can change the check area if we need.

# How to

Everything can be deployed with Terraform
All provider settings are configured in `provider.tf` do not forget to change your s3 backend setting or disable it at all
Also you need a valid IAM user with admin access(ofc i would do some role asssume with maximum restrictions, but...)

Go to the root location and run:

```
terraform init
terraform apply
```

`terraform apply` will spin up VPC, SG, public\private subnets, NG, AG ,3 lamndas and 1 DynamoDB table

To get Api Gateway endpoint run

```
terraform output -raw api_gw_endpoint
```

To push data you can use script from `./scripts/run.py`.

```
pip install shapely requests
python .\scripts\run.py --url $(terraform output -raw api_gw_endpoint) --points 10
```

### What could be done better

- [ ] Labmda `api`. Send to Kinesis stream using SQS, not using boto3
- [ ] Integrate auth, right now everyone can access AG endpoints
- [ ] Use KMS
- [ ] Terraform: Get rid of hardcoded values
- [ ] Send an SNS/SQS notification if kinesis or lambda fails
- [ ] Logs monitoring also would be nice
