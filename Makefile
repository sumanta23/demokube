
shelldemostart:
	bash runtest.sh

shelldemostop:
	docker ps -q| xargs docker rm -f

injectsidecar:
	kubectl label namespace default istio-injection=enabled

kubedeploy:
	kubectl apply -f counter.yml

createload:
	loadtest -c 200 --rps 200 http://132.145.245.45/

exposegrafana:
	kubectl -n istio-system port-forward --address 0.0.0.0 $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 30006:3000 &

exposezipkin:
	kubectl -n istio-system port-forward --address 0.0.0.0 $(kubectl -n istio-system get pod -l app=zipkin -o jsonpath='{.its[0].metadata.name}') 9411:9411


