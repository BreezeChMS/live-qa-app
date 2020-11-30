FROM nginx
RUN apt-get update && apt-get install git -y

ARG BRANCH

COPY repo /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
RUN rm -rf index.html 50x.html
