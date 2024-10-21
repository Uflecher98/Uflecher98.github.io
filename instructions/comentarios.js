import Instruction from "../abstract/instruction.js";

class Comentarios extends Instruction {
  constructor(line, column) {
    super();
    this.line = line;
    this.column = column;

}


  execute(env) {

console.log("Comentario en: "+this.line+', '+this.column);



}
}

export default Comentarios;