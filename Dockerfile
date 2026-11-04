# Imagen oficial ligera de Node.js 22 Alpine (soporte nativo de WebSockets exigido por @supabase/supabase-js)
FROM node:22-alpine

# Directorio de trabajo
WORKDIR /app

# Copiar manifiestos de dependencias
COPY package*.json ./

# Instalación limpia de dependencias de producción
RUN npm ci --omit=dev

# Copiar el código fuente
COPY src/ ./src/

# Puerto expuesto por defecto (alineado al Gateway backendticketU: http://catalogo-service:3000)
EXPOSE 3000

# Variable de entorno por defecto
ENV PORT=3000
ENV NODE_ENV=production

# Comando de arranque
CMD ["node", "src/index.js"]
