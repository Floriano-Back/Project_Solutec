class Users{
    private _id: number;
    private _email: string;
    private _password: string;
    private _role: string;

    constructor(id: number, email: string, password: string, role: string){
        this._id = id;
        this._email = email;
        this._password = password;
        this._role = role;
    }

    get id(): number{
        return this._id;
    }

    get email(): string{
        return this._email;
    }

    set email(value: string){
        this._email = value;
    }

    get password(): string{
        return this._password;
    }

    set password(value: string){
        this._password = value;
    }

    get role(): string{
        return this._role;
    }

    set role(value: string){
        this._password = value;
    }
};

export default Users;