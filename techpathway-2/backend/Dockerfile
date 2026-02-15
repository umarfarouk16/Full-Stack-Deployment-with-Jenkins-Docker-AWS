FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 8080
CMD ["npm", "start"]