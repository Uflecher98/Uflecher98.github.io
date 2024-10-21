import Instruction from "../abstract/instruction.js";
import Error from "../exceptions/error.js";
import Type from "../symbol/type.js";

class FArray extends Instruction {
    constructor(linea, columna, expresion, tipo) {
        super();
        this.tipo = tipo; 
        this.expresion = expresion;
        this.linea = linea;
        this.columna = columna;
    }

    execute(env) {
        console.log("Funcion de Arreglo");

            let resultado = this.expresion.execute(env);
            return  resultado;
        

    

    }

}

export default FArray;