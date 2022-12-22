resource "aws_dynamodb_table" "aggregated_data" {
  name           = local.dymano_table_name
  billing_mode   = "PROVISIONED"
  hash_key       = "area_name"
  range_key      = "window_start"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "area_name"
    type = "S"
  }

  #attribute {
  #  name = "loc_x"
  #  type = "S"
  #}
  #
  #attribute {
  #  name = "loc_y"
  #  type = "S"
  #}
  #
  #attribute {
  #  name = "radius"
  #  type = "N"
  #}
  #
  #attribute {
  #  name = "visits"
  #  type = "N"
  #}

  attribute {
    name = "window_start"
    type = "S"
  }
  #
  #attribute {
  #  name = "windows_end"
  #  type = "S"
  #}
  #
  #attribute {
  #  name = "window_range"
  #  type = "N"
  #}
}
