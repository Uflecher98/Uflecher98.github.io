
import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

class Imprimir extends Instruction {
  constructor(line, column, expresion) {
    super();
    this.expresion = expresion;
    this.line = line;
    this.column = column;
  }


  execute(env) {

    console.log("Entrando a imprimir");
    console.log("imprimir/arreglo de expresiones " );
    console.log(this.expresion);
    console.log(this.expresion instanceof Array);

    let resultado = this.expresion;
    for (let i = 0; i < resultado.length; i++) {
      let aux= resultado[i].execute(env);
      
      if (resultado[i] instanceof Error) { //Si la expresion es un error, lo agrega a Tabla de Errores
        console.log("Error imprimir");
        env.agregarError(aux.value);
    } else { //Si no es un error, actualizar la consola con la expresion 

        console.log("Actualiza consola" + aux.value);
      env.actualizarConsola(aux.value);
    }
    }

    
   


}
}

export default Imprimir;

