
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

USER root

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN chown -R nginx:nginx /etc/nginx/conf.d/

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
