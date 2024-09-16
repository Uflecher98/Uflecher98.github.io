import Expression from "../abstract/expression.js";
import Type from "../symbol/type.js";
import Error from "../exceptions/error.js";

class Literal extends Expression {
  constructor(line, column, value, type) {
    super();
    this.line = line;
    this.column = column;
    this.value = value;
    this.type = type;
  }

  execute(env) {
    console.log("Entre execute literal");

    let temp = new Literal(this.line, this.column, this.value, this.type);
    switch (this.type) {
      case Type.STRING:
        
        temp.value = temp.value.toString().replace(/"/g, "");
        console.log("LITERAL/valor string: "+temp.value);
        break;
      case Type.INT:
        temp.value = parseInt(temp.value, 10);
        break;
      case Type.CHAR:
        temp.value = temp.value.toString().charAt(1);
        break;
      case Type.FLOAT:
        temp.value = parseFloat(temp.value, 10);
        break;
      case Type.BOOLEAN:
        temp.value = (temp.value === "true" ? true : false);
        break;
      case Type.IDENTIFICADOR:
        // tiene que ir a buscar a la TS
        let symbol = env.buscar_variable(this.value);
        if (symbol === null) {
          let error = new Error(temp.line, temp.column, "Error Semantico", "Variable no existe");
          env.agregarError(error);
          console.log('error semantico. la variable no existe');
          return;
        }
        temp.value = symbol.value;
        temp.type = symbol.type;
        break;
    }
    return temp;
  }
}

export default Literal;