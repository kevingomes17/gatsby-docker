FROM mhart/alpine-node:13.10
EXPOSE 9000
COPY ./public ./code/public
COPY ./node_modules ./code/node_modules
COPY ./package.json ./code/package.json
COPY ./gatsby-config.js ./code/gatsby-config.js
COPY ./.cache ./code/.cache

WORKDIR /code
CMD ["node_modules/.bin/gatsby", "serve", "--host=0.0.0.0"]