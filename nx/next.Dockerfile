# build deps
FROM node:16-alpine AS builder
RUN apk add --no-cache libc6-compat
RUN npm install -g pnpm
WORKDIR /app
COPY package*.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm nx build cms

# build runner
FROM node:16-alpine AS runner
RUN apk add --no-cache curl
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
COPY --from=builder /app/dist/apps/cms .
RUN npm i -g pnpm
RUN pnpm install; exit 0

EXPOSE 80
ENV PORT 80
CMD ["pnpm", "start"]