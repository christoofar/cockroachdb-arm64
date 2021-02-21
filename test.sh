docker service create --replicas 1 --name cockroachdb-1 --hostname cockroachdb-1 --network proxy \
                --mount type=bind,source=/var/lib/cockroach/data,target=/cockroach/cockroach-data \
                --mount type=bind,source=/var/lib/cockroach/backup,target=/cockroach/backup --stop-grace-period 60s \
                --publish 8090:8080 --publish 26257:26257 christoofar/cockroachdb-arm64 start-single-node \
                --storage-engine=pebble --external-io-dir=/cockroach/backup --cache=.20 --max-sql-memory=.20 --logtostderr \
                --insecure
