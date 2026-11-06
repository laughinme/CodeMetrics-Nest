# Production image of the web app for the home server: static build behind nginx, which also proxies the API.
# Build context is the repository root.
FROM node:24-alpine AS frontend-builder
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci --silent --no-audit --no-fund
COPY frontend/ ./
RUN npm run build

FROM nginx:1.29-alpine
COPY deploy/home/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=frontend-builder /app/dist /usr/share/nginx/html
