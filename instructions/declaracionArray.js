import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

class DeclaracionArray extends Instruction {
  constructor(line, column, nombre, tipo, expresion, tipoD) {
    super();
    this.nombre = nombre;
    this.tipo = tipo;
    this.expresion = expresion;
    this.line = line;
    this.column = column;
    this.tipoD = tipoD;
  }

  execute(env) {
    console.log("Declaracion de Array");
    console.log(this.tipoD);
    switch(this.tipoD){
        case 1:
            console.log(this.expresion); //verificar que el tipo coincida con los valores del arreglo 
            break;
        case 2:
            console.log(this.expresion[1]); //tipo en 0 y valor en 1, crear el arreglo con los valores por defecto
            break;  
        case 3:
            console.log(this.expresion); //buscar el id, del valor a igualar 

            break;  
    }



  }
}

export default DeclaracionArray;