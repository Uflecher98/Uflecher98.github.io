
import Instruction from "../abstract/instruction.js";
import Error from "../exceptions/error.js";
import Type from "../symbol/type.js";

class If extends Instruction {
  constructor(line, column, condicion, expresion) {
    super();
    this.condicion = condicion;
    this.instrucciones = expresion;
    this.line = line;
    this.column = column;
  }


  execute(env) {

    let cd = this.condicion.execute(env);

    if(cd.type == Type.BOOLEAN){

        if (this.condicion.execute(env).value){
            this.instrucciones.forEach(element => {
                element.execute(env);
            });
        }


    } else {
        let nuevoerror = new Error(this.linea, this.columna, "Error Semantico", "La condicion no es de tipo booleana");
        env.agregarError(nuevoerror);
    }


}
}

export default If;