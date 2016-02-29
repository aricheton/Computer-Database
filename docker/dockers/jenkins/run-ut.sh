#!/bin/bash

CONTAINER="docker-ut"
DIRECTORY="logs"
MYSQL="mysql-docker"

#Clean current workspace

# Pull last custom mvn image
docker pull aurelienr/jdk8-mvn:latest

echo "CONTAINER - check $MYSQL is running."
# Detect if mysql container is running
MYSQL_RUNNING=$(docker inspect --format="{{ .State.Running }}" $MYSQL 2> /dev/null)

# Create container if does not exists
if [ $? -eq 1  ] || [ $MYSQL_RUNNING == "false" ] ; then
  echo "CONTAINER - $MYSQL does not exist."
  echo "CONTAINER - create $MYSQL."
  docker run -d --name $MYSQL -e "MYSQL_ROOT_PASSWORD=\"\"" mysql:5.5
fi

# Detect if mvn container is running
echo "CONTAINER - check $CONTAINER is running."
MVN_RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

# Create container if does not exists
if [ $? -eq 1 ]; then
  echo "CONTAINER - $CONTAINER does not exist."
  echo "CONTAINER - Create container: $CONTAINER."
  docker create --name $CONTAINER --link mysql-container:$MYSQL aurelienr/jdk8-mvn:latest
fi

# Copy cloned repo to docker:/webapp
echo "Copy repo to $CONTAINER."
docker cp . $CONTAINER:webapp

# Copy dao properties for JDBC Test connection
echo "Copy dao.properties for testing environment"
cp -rf ./docker/dockers/mysql/dao.properties ./src/test/resources/properties/dao.properties
cp -rf ./docker/dockers/mysql/dao.properties ./src/main/resources/properties/dao.properties

# Start mvn docker
if [ $MVN_RUNNING == "false" ]; then
  echo "CONTAINER - $CONTAINER is not running."
  echo "CONTAINER - start $CONTAINER."
  docker start -a $CONTAINER
fi

STARTED=$(docker inspect --format="{{ .State.StartedAt }}" $CONTAINER)
NETWORK=$(docker inspect --format="{{ .NetworkSettings.IPAddress }}" $CONTAINER)

echo "OK - $CONTAINER is running. IP: $NETWORK, StartedAt: $STARTED"

# Copy logs
if [ ! -d "$DIRECTORY" ]; then
  mkdir logs
fi

echo "Copying logs"
docker cp $CONTAINER:webapp/target/surefire-reports ./logs
docker cp $CONTAINER:webapp/target/failsafe-reports ./logs




# Stop all dockers
docker stop $MYSQL
docker stop $CONTAINER
