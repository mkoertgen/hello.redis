FROM node:10.7.0-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD package.json yarn.lock ./
RUN yarn install

ADD . ./
#RUN yarn coverage

CMD ["yarn", "start"]
