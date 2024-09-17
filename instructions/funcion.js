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
        console.log("Es arreglo instrucciones: " + Array.isArray(this.instrucciones));
        console.log("tamanio del arreglo: " + this.instrucciones.length);

        if(this.parametros==null){
            console.log("Sin parametros");
        } else {
            console.log("Es arreglo parametros: " + Array.isArray(this.parametros));
            console.log("tamanio del arreglo de parametros : " + this.parametros.length);

            for (let i = 0; i < this.parametros.length; i++) {
                this.parametros[i].execute(env);
                 
              }

        }
       

        let resultado = this.instrucciones;

            for (let i = 0; i < this.instrucciones.length; i++) {
            resultado[i].execute(env);
    
          }


    }

}

export default Funcion;