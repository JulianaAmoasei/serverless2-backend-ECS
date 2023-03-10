FROM node:18-alpine
ADD . /server
WORKDIR /server
COPY ./package.json .
RUN npm install
COPY ./servidor ./servidor
EXPOSE 3000
CMD cd /server && npm start
