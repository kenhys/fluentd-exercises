
docker pull fluent/fluentd:v1.11
docker run -it -d --name=fluent-test -e TZ=Asia/Shanghai -p 24224:24224 -v /etc/localtime:/etc/localtime fluent/fluentd:v1.11
docker exec -it fluent-test date
#% docker exec -it fluent-test date
#Fri Aug 27 05:01:54 UTC 2021

8ずれているってことなので Shanghaiは+8。おそらくそのことを言っている。
alpineのイメージについてか。だから/bin/bashないのか。


docker run -it -d --name=fluent-test -e TZ=Asia/Shanghai -p 24224:24224 fluent/fluentd:v1.11
% docker exec -it 5ce2e14af42d /bin/ash
/ $ date
Fri Aug 27 05:15:56 UTC 2021

docker run -it -d --name=fluent-test -p 24224:24224 fluent/fluentd:v1.11
% docker exec -it f0c32fa30f32 date
Fri Aug 27 05:17:00 UTC 2021

/etc/localtimeないのか。 zoneinfoもない。

docker run -it -d --name=fluent-test -e TZ=Asia/Shanghai -p 24224:24224 -v /etc/localtime:/etc/localtime tmp
% docker exec -it dcc8733201b4 date
Fri Aug 27 13:31:02 CST 2021

やっぱりtzdataがインストールされていないからだ。

TZを指定しないとJSTになった。期待通り

docker run -it -d -p 24224:24224 -v /etc/localtime:/etc/localtime tmp
% docker exec -it 1b2c2d711d67 date
Fri Aug 27 14:32:34 JST 2021

-eさえ指定しておけばいいのか。

docker run -it -d --name=fluent-test -e TZ=Asia/Shanghai -p 24224:24224 tmp
% docker exec -it d3bae295444a date
Fri Aug 27 13:33:48 CST 2021

