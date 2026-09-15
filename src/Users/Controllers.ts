import Repository from "./Repository";
import bcrypt from 'bcrypt';

const Controllers = {
    newUsers: async (Users: string) =>{
        const result = await Repository.create(email, password, role)

    }
}