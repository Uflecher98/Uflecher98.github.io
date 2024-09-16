
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
    console.log("imprimir/expresion "+ this.expresion);
    let resultado = this.expresion.execute(env);
    if (resultado instanceof Error) { //Si la expresion es un error, lo agrega a Tabla de Errores
        console.log("Error imprimir");
        env.agregarError(resultado);
    } else { //Si no es un error, actualizar la consola con la expresion 
        console.log("Actualiza consola" + resultado.value);
      env.actualizarConsola(resultado.value);
    }


}
}

export default Imprimir;

