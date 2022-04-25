const mysql = require('mysql');

mysql.createPool({
    connectionLimit: 10,
    password: 'password',
    user: 'user',
    database: 'rfid',
    host: 'localhost',
    port: '3030'

})