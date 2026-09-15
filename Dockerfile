# --- ESTAGIO 1: Bild & e Dependencias ---

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps
# --- ESTAGIO 2: Imagem de Produção Leve ---

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production --legacy-peer-deps
COPY --from=builder /app/server.js ./server.js

USER node
EXPOSE 3000

CMD ["node", "server.js"]
