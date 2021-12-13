#!/bin/bash

DELAY_TTL=10000
DELAY=10

# Definition of delay_exchange
docker exec rabbitmq rabbitmqadmin declare exchange name=delay_exchange type=direct

# Definition of router_exchange
docker exec rabbitmq rabbitmqadmin declare exchange name=router_exchange type=direct

# Definition of DLX and TTL in queue
docker exec rabbitmq rabbitmqadmin declare queue name=delay_queue arguments='{"x-dead-letter-exchange":"router_exchange", "x-message-ttl":'$DELAY_TTL', "x-dead-letter-routing-key":"dead_letter_key"}'

# Definition of binding delay_exchange with delay_queue and routing_key
docker exec rabbitmq rabbitmqadmin declare binding source=delay_exchange destination=delay_queue  routing_key=dead_letter_key

# Definition of destination queue - destination_queue
docker exec rabbitmq rabbitmqadmin declare queue name=destination_queue

# Binding definition between router_exchange and destination_queue
docker exec rabbitmq rabbitmqadmin declare binding source=router_exchange destination=destination_queue  routing_key=dead_letter_key

# Message publication to delay_exchange
docker exec rabbitmq rabbitmqadmin publish exchange=delay_exchange routing_key=dead_letter_key payload="first message"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
echo "$DELAY seconds pause"
sleep $DELAY
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
sleep $DELAY
echo "$DELAY seconds pause"
docker exec rabbitmq rabbitmqadmin publish exchange=delay_exchange routing_key=dead_letter_key payload="second message"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
sleep $DELAY
echo "$DELAY seconds pause"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20