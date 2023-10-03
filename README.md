
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Average Queue Size on Cassandra
---

This incident type refers to a situation where the average queue size on a Cassandra database exceeds a certain threshold. A queue is a data structure that holds incoming requests until they can be processed. When the average queue size is too high, it can indicate that the database is struggling to keep up with incoming requests, which can result in slower response times and potential service disruptions. This type of incident requires investigation and resolution to ensure the database can handle the incoming workload efficiently.

### Parameters
```shell
export NODETOOL_PARAMETERS="PLACEHOLDER"

export NETSTAT_PARAMETERS="PLACEHOLDER"

export CASSANDRA_PORT="PLACEHOLDER"

export STATUS="PLACEHOLDER"

export NUMBER_OF_NODES="PLACEHOLDER"

export PATH_TO_CASSANDRA_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check the current queue size
```shell
nodetool -- ${NODETOOL_PARAMETERS} tpstats | grep -A1 "ReadStage" | tail -n1
```

### Check the number of requests per second
```shell
nodetool -- ${NODETOOL_PARAMETERS} tpstats | grep -A1 "ReadStage" | tail -n1 | awk '{print $2}'
```

### Check the number of active connections
```shell
netstat -- ${NETSTAT_PARAMETERS} | grep "${CASSANDRA_PORT}" | wc -l
```

### Check the number of pending connections
```shell
netstat -- ${NETSTAT_PARAMETERS} | grep "${CASSANDRA_PORT}" | grep "${STATUS}" | wc -l
```

### Check the system load average
```shell
uptime
```

### Check the disk usage
```shell
df -h
```

## Repair

### Increase the number of nodes in the Cassandra cluster to distribute the workload and reduce the load on individual nodes.
```shell


#!/bin/bash



# Set variables

NODES=${NUMBER_OF_NODES}

CASSANDRA_CONFIG=${PATH_TO_CASSANDRA_CONFIG_FILE}



# Update the Cassandra configuration file

sed -i "s/.*num_tokens.*/num_tokens: $NODES/g" $CASSANDRA_CONFIG



# Restart the Cassandra service

sudo systemctl restart cassandra.service


```