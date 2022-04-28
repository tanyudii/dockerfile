# build stage
FROM node:16-alpine AS build
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package*.json ./
RUN npm install -g pnpm
RUN pnpm i
COPY . .
RUN pnpm run build

# production stage
FROM nginx:stable-alpine as production
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]