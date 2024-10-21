import Instruction from "../abstract/instruction.js";
import Environment from "../symbol/env.js";
import Declaracion from "./declaration.js";
import Imprimir from "./imprimir.js";
class Funcion extends Instruction {
    constructor(linea, columna, id, tipo, parametros, instrucciones) {
        super();
        this.parametros = parametros;
        this.instrucciones = instrucciones;
        this.id = id;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }


    execute(env) {
   
            console.log("Entre a funcion");

            let Funcion = this;
             let valor = env.setFuncion(Funcion);

             console.log(this.parametros);

             this.parametros.forEach((par)  => {
                 console.log(par.nombre);
                //console.log(ins);
              });

            if(valor == 1){
                console.log("Se añadio funcion");
            } else {
                let error = new Error(this.line, this.column, "Error Semantico", "No se pudo agregar funcion");
                env.agregarError(error);
            }

    }

}

export default Funcion;