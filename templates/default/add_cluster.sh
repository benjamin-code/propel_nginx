#!/bin/sh

if rabbitmqctl cluster_status | grep -q @<%= @clustermastr %>
	then
		echo "This node has been in cluster. Will not add it again."
	else
		echo "Will add this node to cluster"
		rabbitmqctl stop_app
		rabbitmqctl join_cluster rabbit@<%= @clustermaster %>
		rabbitmqctl start_app
		rabbitmqctl set_policy ha-all "^propel_cluster"  '{"ha-mode":"all"}'
		rabbitmq-plugins enable rabbitmq_management_agent
fi
