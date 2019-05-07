# setup middleware.
os=$(uname -s)
if [ $os == "Darwin" ]; then
    NEW_UUID=$((1 + RANDOM % 100))
else
    NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
fi
docker run --rm --name $NEW_UUID"_redis" -d redis

RIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $NEW_UUID"_redis")

docker run -d --rm --env REDIS_HOST=$RIP --name $NEW_UUID"_be" sumanta23/counter:latest node backend.js;
BEIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $NEW_UUID"_be")

docker run -d --rm --env REDIS_HOST=$RIP --env backend=$BEIP:5000 -p 3000:3000  sumanta23/counter:latest node server.js;
