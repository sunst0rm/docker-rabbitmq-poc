RABBITMQ - DLX with TTL messages - PROOF OF CONCEPT

1. `docker-compose up -d` to run container

2. Once container is up, launch in terminal either  `./queue.sh` or `./message.sh`

3. `queue.sh` --> Creates two queues, two exchanges, two bindings and publishes a message. Then it checks state of both queues, waits given time, checks again. DLX and TTL parameters are included in source queue.


4. `message.sh` --> Does same as above, however DLX parameters refers only to source queue and TTL refers to published messages only.

