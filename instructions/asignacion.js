import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

class Asignacion extends Instruction {
  constructor(line, column, nombre, expresion) {
    super();
    this.nombre = nombre;
    this.expresion = expresion;
    this.line = line;
    this.column = column;
  }

  execute(env) {
    console.log("Asignacion de variable======================================================================");

    let resultado = this.expresion.execute(env);
    if (resultado instanceof Error) {
      env.agregarError(resultado);
    } else {
    // console.log("Asignacion/this.nombre:"+this.nombre);
     let prueba = env.buscar_variable(this.nombre);
     //console.log("Asignacion/env.buscar_variable:"+prueba);
      if( prueba === null ){
        let error = new Error(this.line, this.column, "Error Semantico", "Variable no existente: "+this.nombre);
        env.agregarError(error);
      } else { //Asigna el valor
        let vari = env.asignavalor(this.nombre, resultado);
        //console.log(vari);

      }


    }

  }
}
export default Asignacion;