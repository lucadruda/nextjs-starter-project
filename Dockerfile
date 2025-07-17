# Use Node.js as the base image for building the app
FROM node:18 AS builder
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Use a smaller image for production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json .
COPY --from=builder /app/next.config.js .
COPY --from=builder /app/.env.production .env.production

CMD ["npm", "start"]