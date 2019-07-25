FROM ubuntu:18.04
LABEL author="Ville Kopio <ville.kopio@gmail.com>"

WORKDIR /app

RUN apt -yq update 
    