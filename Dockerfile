# --- ESTÁGIO 1: Build & Dependências ---
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

# --- ESTÁGIO 2: Imagem de Produção Leve ---
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

# Mudamos de 'npm ci' para 'npm install' com a flag de produção, que aceita o legacy-peer-deps perfeitamente
RUN npm install --omit=dev --legacy-peer-deps

COPY --from=builder /app/server.js ./server.js

USER node
EXPOSE 3000

CMD ["node", "server.js"]
