
import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

class If extends Instruction {
  constructor(line, column, expresion) {
    super();
    this.expresion = expresion;
    this.line = line;
    this.column = column;
  }


  execute(env) {



}
}

export default If;