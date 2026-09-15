class Suppliers{
    private _id: number;
    private _name: string;
    private _email: string;
    private _password: string;
    private _cnpj: number;
    private _phone: number;
    private _address: string;

    constructor(id: number, name: string, email: string, password: string, cnpj: number, phone: number, address: string){
        this._id = id;
        this._name = name;
        this._email = email;
        this._password = password;
        this._cnpj = cnpj;
        this._phone = phone;
        this._address = address;
    }

    get id(): number{
        return this._id;
    }

    get name(): string{
        return this._name;
    }

    set name(value: string){
        this._name = value;
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

    get cnpj(): number{
        return this._cnpj;
    }

    set cnpj(value: number){
        this._cnpj = value;
    }

    get phone(): number{
        return this._phone;
    }

    set phone(value: number){
        this._phone = value;
    }

    get address(): number{
        return this.address;
    }

    set address(value: string){
        this._address = value;
    }
};

export default Suppliers;