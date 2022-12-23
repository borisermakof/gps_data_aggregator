# GPS data aggregator

The idea behind this solution is pretty simple. Some devices sends its GPS data to the AWS cloud via simple HTTP post request. AWS Kinesis aggregates data and triggers special lambda `processor` to calculate in which region this point(or gps location) belongs to and do that for the configured tumbling window `60 sec by default`. Region radius can be reconfigured, by default its `100 km`. After that all data goes to the DynamoDB.
Data also can be fetched back by `area_name` where you can check how many GPS  
As a final solution you can deploy some simple WEB to display a heat map for the set of regions.

Solution has 2 Api Gateway endpoints:

`/add_point` - POST. Data format JSON. Example: `{'user_id': <int>, 'loc_x': <float>, 'loc_y': <float>}`

`/get_regions_data` - GET. Only 1 query param: `area_name=<area_name>` . Returns list of objects.

# AWS Architecture

![AWS](/assets/aws.jpg)

# How to

Everything can be deployed with Terraform
All provider settings are configured in `provider.tf` do not forget to change your s3 backend setting or disable it at all

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

To push data you can use script from `./scripts/run.py`

```

```

### What could be done

- [ ] Labmda `api`. Send to Kinesis stream using SQS, not using boto3
- [ ] Use KMS
- [ ] Terraform: Get rid of hardcoded values
