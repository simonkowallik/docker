FROM node:10-alpine

RUN mkdir /app
ADD app/* /app/
WORKDIR /app
RUN npm install

EXPOSE 80

CMD [ "npm", "start" ]
