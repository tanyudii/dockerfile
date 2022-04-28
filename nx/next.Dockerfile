# build deps
FROM node:16-alpine AS builder
RUN apk add --no-cache git libc6-compat
WORKDIR /app
COPY . .
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile
RUN pnpm nx build cms

# build runner
FROM node:16-alpine AS runner
RUN apk add --no-cache curl
WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
COPY --from=builder /app/dist/apps/cms .
RUN npm i -g pnpm
RUN pnpm install

EXPOSE 80
ENV PORT 80
CMD ["pnpm", "start"]