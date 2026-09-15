import pool from "../config/database";

const Repository = {
    create: async (email: string, password: string, role: string) =>{
        const sql = "INSERT INTO users (email, password, role) VALUES (?, ?, ?);";
        const [result]:any = await pool.query(sql, [email, password, role]);
        return result.rows[0];
    },
  
    select: async () => {
        const sql = "SELECT * FROM users;";
        const [result]:any = await pool.query(sql);
        return result;      
    },

    selectId: async (id: number) =>{
        const sql = "SELECT * FROM users WHERE id = ?;";
        const [result]:any = await pool.query(sql, [id]);
        return result;
    },

    //update: async () =>
}

export default Repository;