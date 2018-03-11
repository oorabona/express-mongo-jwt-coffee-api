FROM node:carbon

# Create app directory
WORKDIR /app

# Environment variables
ENV SECRETS_PATH=/app/secrets \
    MONGO_CONNECT_URL=mongodb://db:27017/pat \
    SECRET_KEY=secretkey

# Bundle app source
COPY app .
COPY ./docker-entrypoint.sh /

RUN ssh-keygen -t rsa -b 4096 -f jwtRS256.key && \
  openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.pub && \
  echo $SECRET_KEY > $SECRETS_PATH/secret.key

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

EXPOSE 3000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "start", "coffee" ]
