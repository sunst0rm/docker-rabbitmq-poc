#!/bin/bash

DELAY_TTL=10000
DELAY=10

# definicja delay_exchange
docker exec rabbitmq rabbitmqadmin declare exchange name=delay_exchange type=direct        

# definicja router_exchange
docker exec rabbitmq rabbitmqadmin declare exchange name=router_exchange type=direct 

#definicja DLX i TTL w kolejce delay_queue
docker exec rabbitmq rabbitmqadmin declare queue name=delay_queue arguments='{"x-dead-letter-exchange":"router_exchange", "x-message-ttl":'$DELAY_TTL', "x-dead-letter-routing-key":"dead_letter_key"}'

#definicja binding delay_exchange z delay_queue oraz routing_key
docker exec rabbitmq rabbitmqadmin declare binding source=delay_exchange destination=delay_queue  routing_key=dead_letter_key

#definicje kolejki docelowej - destination_queue
docker exec rabbitmq rabbitmqadmin declare queue name=destination_queue

#defnicja binding miedzy router_exchange a destination_queue
docker exec rabbitmq rabbitmqadmin declare binding source=router_exchange destination=destination_queue  routing_key=dead_letter_key

# publikacja wiadomosci do delay_exchange
docker exec rabbitmq rabbitmqadmin publish exchange=delay_exchange routing_key=dead_letter_key payload="first message"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
echo "Przerwa $DELAY sekund"
sleep $DELAY
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
sleep $DELAY
echo "Przerwa $DELAY sekund"
docker exec rabbitmq rabbitmqadmin publish exchange=delay_exchange routing_key=dead_letter_key payload="second message"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20
sleep $DELAY
echo "Przerwa $DELAY sekund"
docker exec rabbitmq rabbitmqadmin get queue=delay_queue
docker exec rabbitmq rabbitmqadmin get queue=destination_queue count=20