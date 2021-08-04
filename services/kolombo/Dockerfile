FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY src/ src/
COPY web/ web/
COPY tsconfig.json .

RUN npm run build

EXPOSE 80

CMD ["npm", "start"]
