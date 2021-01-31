require('dotenv').config();
const config = require('./src/config');
const { makeServer } = require('./src/server');

makeServer(config);
