

#!/bin/bash



# Set variables

NODES=${NUMBER_OF_NODES}

CASSANDRA_CONFIG=${PATH_TO_CASSANDRA_CONFIG_FILE}



# Update the Cassandra configuration file

sed -i "s/.*num_tokens.*/num_tokens: $NODES/g" $CASSANDRA_CONFIG



# Restart the Cassandra service

sudo systemctl restart cassandra.service