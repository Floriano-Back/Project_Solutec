import postgres from 'postgres';
import dotenv from 'dotenv';

dotenv.config();

const pool = postgres({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
});

export default pool;
