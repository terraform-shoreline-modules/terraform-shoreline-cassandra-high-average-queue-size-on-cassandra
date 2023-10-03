resource "shoreline_notebook" "high_average_queue_size_on_cassandra" {
  name       = "high_average_queue_size_on_cassandra"
  data       = file("${path.module}/data/high_average_queue_size_on_cassandra.json")
  depends_on = [shoreline_action.invoke_update_cassandra_config]
}

resource "shoreline_file" "update_cassandra_config" {
  name             = "update_cassandra_config"
  input_file       = "${path.module}/data/update_cassandra_config.sh"
  md5              = filemd5("${path.module}/data/update_cassandra_config.sh")
  description      = "Increase the number of nodes in the Cassandra cluster to distribute the workload and reduce the load on individual nodes."
  destination_path = "/agent/scripts/update_cassandra_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_cassandra_config" {
  name        = "invoke_update_cassandra_config"
  description = "Increase the number of nodes in the Cassandra cluster to distribute the workload and reduce the load on individual nodes."
  command     = "`chmod +x /agent/scripts/update_cassandra_config.sh && /agent/scripts/update_cassandra_config.sh`"
  params      = ["NUMBER_OF_NODES","PATH_TO_CASSANDRA_CONFIG_FILE"]
  file_deps   = ["update_cassandra_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_cassandra_config]
}

