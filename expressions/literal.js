
import Error from "../exceptions/error.js";
import Expression from "../abstract/expression.js";
import Type from "../symbol/type.js";
import Value from "../symbol/Value.js";

class Literal extends Expression {
  constructor(line, column, value, type) {
    super();
    this.line = line;
    this.column = column;
    this.value = value;
    this.type = type;
  }

  execute(env, gen) {
    let temp = gen.newTemp();
    switch (this.type) {
      case Type.STRING:
        throw new Error("not implemented yet");
      case Type.INT:
        gen.addBr();
        gen.comment("Agregando un Literal de tipo INTEGER");
        gen.addLi("t0", this.value.toString());
        return new Value("t0", true, this.type, [], [], []);
      case Type.FLOAT:
        // ....
        break;
    }
    return temp;
  }
}

export default Literal;