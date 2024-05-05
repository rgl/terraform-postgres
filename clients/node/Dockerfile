# syntax=docker/dockerfile:1.7

FROM node:20-bookworm
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY *.js ./
ENTRYPOINT ["node"]
CMD ["main.js"]
