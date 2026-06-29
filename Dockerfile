FROM node:20-alpine

WORKDIR /app

RUN apk update && apk upgrade --no-cache

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

RUN mkdir -p public/images && chown -R node:node /app

EXPOSE 3000

USER node

CMD ["npm", "start"]