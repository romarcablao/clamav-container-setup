FROM node:14.15-stretch-slim

# set work directory
WORKDIR /clamav-api

# copy dependency list
COPY package.json ./

# install dependencies
RUN npm install --production

# set permission
RUN chown -R node:node ./

# copy source code
COPY src ./src/
COPY index.js ./

# set user
USER node:node

ENTRYPOINT ["npm", "start"]