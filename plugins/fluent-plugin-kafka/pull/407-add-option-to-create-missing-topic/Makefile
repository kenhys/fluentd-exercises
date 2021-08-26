clone:
	git clone https://github.com/fpytloun/fluent-plugin-kafka
	cd fluent-plugin-kafka && git checkout -b topic-creation origin/topic-creation

run:
	docker-compose up

maketopic:
	docker exec -it zookeeper kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
