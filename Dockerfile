# --- ESTÁGIO 1: Build & Dependências ---
FROM node:20-alpine AS builder

WORKDIR /app

# Copia os arquivos de configuração de pacotes
COPY package*.json ./

# Instala todas as dependências (incluindo as de desenvolvimento)
RUN npm install --legacy-peer-deps

# COPIA O RESTO DO CÓDIGO FONTE (Faltava isso para o server.js existir no builder!)
COPY . .

# --- ESTÁGIO 2: Imagem de Produção Leve ---
FROM node:20-alpine

WORKDIR /app

# Copia apenas os arquivos necessários para instalar dependências de produção
COPY package*.json ./

# Instala apenas dependências de produção de forma limpa
RUN npm ci --only=production --legacy-peer-deps

# Copia o código já buildado/preparado do estágio anterior
COPY --from=builder /app/server.js ./server.js

# Define o usuário padrão do Node por segurança (evita rodar como root)
USER node

# Informa a porta que o container vai expor
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["node", "server.js"]