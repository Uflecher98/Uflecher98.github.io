import Instruction from "../abstract/instruction.js";
import Error from "../exceptions/error.js";
import Type from "../symbol/type.js";

class FNativa extends Instruction {
    constructor(linea, columna, expresion, tipo) {
        super();
        this.tipo = tipo; /* 

            PARSEINT: 1,
            PARSEFLOAT: 2,
            TOSTRING: 3,
            TYPEOF: 4,
            TOUPPER: 5, 
            TOLOWER: 6,
*/
        this.expresion = expresion;
        this.linea = linea;
        this.columna = columna;
    }

    execute(env) {
        console.log("Funcion Nativa");

        let resultado = this.expresion.execute(env);


        if (resultado instanceof Error) {
            env.agregarError(resultado);
            console.log("resultado: " + resultado.type );
        } else {
            if (this.tipo == 1) {
                if (resultado.type  == Type.STRING) {
                    let qcom = resultado.value.replace(/"/g, "");
                    let parseado = parseInt(qcom, 10);
                    console.log("valor mod: " + parseado);

                    if (isNaN(parseado)) {
                        let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede parsear a Int");
                        env.agregarError(nerror);
                    } else {
                        resultado.type  = Type.INT;
                        resultado.value = parseado;
                        return resultado;
                    }

                } else {
                    let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede parsear este TIPO a Int");
                    env.agregarError(nerror);
                }

            } else if (this.tipo == 2) {
                if (resultado.type  == Type.STRING) {
                    let qcom = resultado.value.replace(/"/g, "");
                    let parseado = parseFloat(qcom);
                    console.log("valor mod: " + parseado);

                    if (isNaN(parseado)) {
                        let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede parsear a Float");
                        env.agregarError(nerror);
                    } else {
                        resultado.type  = Type.FLOAT;
                        resultado.value = parseado;
                        return resultado;
                    }

                } else {
                    let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede parsear este TIPO a Float");
                    env.agregarError(nerror);
                }

            } else if (this.tipo == 3) {
                let parseado;
                if (resultado.type  == Type.STRING) {
                    let qcom = resultado.value.replace(/"/g, "");
                     parseado = String(qcom);
                } else {
                     parseado = String(resultado.value);

                }
                console.log("valor mod: " + parseado);
                resultado.type  = Type.STRING;
                resultado.value = parseado;
                return resultado;

            }else if (this.tipo == 6) {
                if (resultado.type  == Type.STRING) {
                    let qcom = resultado.value.replace(/"/g, "");
                    let parseado = qcom.toLowerCase();
                    console.log("valor mod: " + parseado);

                   
                        resultado.type  = Type.FLOAT;
                        resultado.value = parseado;
                        return resultado;
                    }else {
                    let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede aplicar toLowerCase a este tipo de dato");
                    env.agregarError(nerror);
                }

            }else if (this.tipo == 5) {
                if (resultado.type  == Type.STRING) {
                    let qcom = resultado.value.replace(/"/g, "");
                    let parseado = qcom.toUpperCase();
                    console.log("valor mod: " + parseado);

                   
                        resultado.type  = Type.FLOAT;
                        resultado.value = parseado;
                        return resultado;
                    }else {
                    let nerror = new Error(this.linea, this.columna, "Error Semantico", "No se puede aplicar toUpperCase a este tipo de dato");
                    env.agregarError(nerror);
                }

            }else if (this.tipo == 4) {
                resultado.value = resultado.type ;
                resultado.type  = Type.STRING;
                
                return resultado;

            }



        }


    }

}

export default FNativa;