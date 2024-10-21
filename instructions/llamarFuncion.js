import Instruction from "../abstract/instruction.js";
import Type from "../symbol/type.js";

class LlamarFuncion extends Instruction {
  constructor(line, column, id) {
    super();
    this.line = line;
    this.column = column;
    this.id = id;
}


  execute(env) {
    console.log("ENTRA A EJECUTAR FUNCION");



    }

    


}

export default LlamarFuncion;