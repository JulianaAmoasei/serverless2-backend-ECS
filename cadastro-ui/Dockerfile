FROM node:18-alpine
ADD . /app
WORKDIR /app
COPY package.json ./
RUN npm install
EXPOSE 80
COPY . .