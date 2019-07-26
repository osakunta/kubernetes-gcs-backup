NAME   := osakunta/kubernetes-gcs-backup
TAG    := $$(git log -1 --pretty=%h)
IMAGE  := ${NAME}:${TAG}
LATEST := ${NAME}:latest
EXEC   := kubernetes-gcs-backup

docker-build:
	sudo docker build -t ${IMAGE} .
	sudo docker tag ${IMAGE} ${LATEST}
 
docker-run:
	sudo docker run -it --name ${EXEC} --publish 8080:8080 --mount type=bind,source="$$(pwd)"/key.json,target=/app/key.json ${LATEST}

docker-rm:
	sudo docker rm ${EXEC}

docker-push:
	sudo docker push ${NAME}
