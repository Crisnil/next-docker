FROM node:lts as dependencies
WORKDIR /next-practice
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:lts as builder
WORKDIR /next-practice
COPY . .
COPY --from=dependencies /next-practice/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /next-practice
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /next-practice/public ./public
COPY --from=builder /next-practice/.next ./.next
COPY --from=builder /next-practice/node_modules ./node_modules
COPY --from=builder /next-practice/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]