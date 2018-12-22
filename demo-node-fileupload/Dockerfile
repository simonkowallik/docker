FROM node:10-alpine

COPY app /
WORKDIR /app
RUN npm install

EXPOSE 80

CMD [ "npm", "start" ]
