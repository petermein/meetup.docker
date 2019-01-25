FROM crunchgeek/composer:7.2 as composer
ARG TOKEN
ENV TOKEN ${TOKEN}

COPY . /src
WORKDIR /src

ENV COMPOSER_ALLOW_SUPERUSER 1
#RUN echo "{\"github-oauth\": {\"github.com\": \"$TOKEN\"}}" > /tmp/auth.json
RUN composer install --no-interaction --no-dev --prefer-dist


### compile js & css assets
FROM node:8.15 as node
WORKDIR /node
COPY --from=composer /src /node
RUN npm i && \
		npm run production
RUN rm -rf /node/node_modules


### build app container
FROM alpine:3.5
WORKDIR /app
COPY .kubernetes/infrastructure /config
COPY --from=node /node /app

# set requirement privileges
RUN chown -R 9000:9000 storage && \
	chown -R 9000:9000 bootstrap/cache && \
	chmod -R ug+rwx    bootstrap/cache && \
	chgrp -R 9000      bootstrap/cache && \
	chmod +x artisan && \
	chmod +x /config/provision.sh

# create init script
RUN echo '#!/bin/sh'                   > /init.sh && \
	echo 'echo "app init started!"'   >> /init.sh && \
	echo 'cp -rp /app/*    /src'      >> /init.sh && \
	echo 'cp -rp /config/* /cfg'   	  >> /init.sh && \
    echo 'touch db/database.sqlite'   >> /init.sh && \
	echo 'echo "app init completed!"' >> /init.sh && \
	chmod +x /init.sh

CMD [ "sh", "-c", "/init.sh" ]