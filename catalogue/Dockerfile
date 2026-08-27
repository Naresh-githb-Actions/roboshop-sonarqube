#FROM node:20
#WORKDIR /opt/server
#COPY package.json .
#COPY *.js .
#RUN npm install
#ENV MONGO=true
#ENV MONGO_URL=mongodb://mongodb:27017/catalogue
#CMD ["node","server.js"]


# ---------- Stage 1: Builder ----------
    
FROM node:20-alpine3.21 AS builder
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

# ---------- Stage 2: Runtime ----------
FROM node:20-alpine3.21
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
WORKDIR /opt/server
USER roboshop
COPY --from=builder /opt/server /opt/server
CMD ["node","server.js"]

