import Instruction from "../abstract/instruction.js";

class Comentarios extends Instruction {
  constructor(line, column, text) {
    super();
    this.line = line;
    this.column = column;
    this.text = text;

}


  execute(env, gen) {

console.log("Comentario en: "+this.line+', '+this.column);

gen.comment(`${this.text}`);

}
}

export default Comentarios;