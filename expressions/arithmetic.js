import Expression from "../abstract/expression.js";
import Type from "../symbol/type.js";
import Literal from "./literal.js";
import Error from "../exceptions/error.js";

class Arithmetic extends Expression {
  constructor(line, column, left, right, op) {
    super();
    this.left = left;
    this.right = right;
    this.op = op;
    this.line = line;
    this.column = column;
  }

  execute(env) {

    console.log("op: " + this.op);
    switch (this.op) {
      case 0: //SUMA
        console.log("Expresion Aritmetica Suma");
        const resultado_izdo = this.left.execute(env);
        const resultado_derecho = this.right.execute(env);

        if (resultado_izdo.type == Type.INT) {
          if (resultado_derecho.type == Type.INT) {
            return new Literal(this.line, this.column, resultado_izdo.value + resultado_derecho.value, Type.INT);
          } else if (resultado_derecho.type == Type.FLOAT) {
            return new Literal(this.line, this.column, resultado_izdo.value + resultado_derecho.value, Type.FLOAT);
          }
        } else if (resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT) {
            return new Literal(this.line, this.column, resultado_izdo.value + resultado_derecho.value, Type.FLOAT);
          } else if (resultado_derecho.type == Type.FLOAT) {
            return new Literal(this.line, this.column, resultado_izdo.value + resultado_derecho.value, Type.FLOAT);
          }
        } else if (resultado_izdo.type == Type.STRING) {
          if (resultado_derecho.type == Type.STRING) {
            //quitar comillas
            return new Literal(this.line, this.column, resultado_izdo.value + resultado_derecho.value, Type.STRING);
          }
        }


      case 1: //RESTA 
        console.log("Expresion Aritmetica Resta");


        if (this.left == null) {
          const resultado_derecho_resta = this.right.execute(env);
          if (resultado_derecho_resta.type == Type.INT) {
            return new Literal(this.line, this.column, - resultado_derecho_resta.value, Type.INT);
          } else if (resultado_derecho_resta.type == Type.FLOAT) {
            return new Literal(this.line, this.column, - resultado_derecho_resta.value, Type.FLOAT);
          }

        } else {
          const resultado_izdo_resta = this.left.execute(env);
          const resultado_derecho_resta = this.right.execute(env);
          if (resultado_izdo_resta.type == Type.INT) {
            if (resultado_derecho_resta.type == Type.INT) {
              return new Literal(this.line, this.column, resultado_izdo_resta.value - resultado_derecho_resta.value, Type.INT);
            } else if (resultado_derecho_resta.type == Type.FLOAT) {
              return new Literal(this.line, this.column, resultado_izdo_resta.value - resultado_derecho_resta.value, Type.FLOAT);
            }
          } else if (resultado_izdo_resta.type == Type.FLOAT) {
            if (resultado_derecho_resta.type == Type.INT) {
              return new Literal(this.line, this.column, resultado_izdo_resta.value - resultado_derecho_resta.value, Type.FLOAT);
            } else if (resultado_derecho_resta.type == Type.FLOAT) {
              return new Literal(this.line, this.column, resultado_izdo_resta.value - resultado_derecho_resta.value, Type.FLOAT);
            }
          }

        }


      case 2: //MULTIPLICACION
        console.log("Expresion Aritmetica Multiplicacion");
        const izdo_multi = this.left.execute(env);
        const dercho_multi = this.right.execute(env);

        if (izdo_multi.type == Type.INT) {
          if (dercho_multi.type == Type.INT) {
            return new Literal(this.line, this.column, izdo_multi.value * dercho_multi.value, Type.INT);
          } else if (dercho_multi.type == Type.FLOAT) {
            return new Literal(this.line, this.column, izdo_multi.value * dercho_multi.value, Type.FLOAT);
          }
        } else if (izdo_multi.type == Type.FLOAT) {
          if (dercho_multi.type == Type.INT) {
            return new Literal(this.line, this.column, izdo_multi.value * dercho_multi.value, Type.FLOAT);
          } else if (dercho_multi.type == Type.FLOAT) {
            return new Literal(this.line, this.column, izdo_multi.value * dercho_multi.value, Type.FLOAT);
          }
        }
      case 3:
        console.log("Expresion Aritmetica Division");
        const izdo_div = this.left.execute(env);
        const dercho_divi = this.right.execute(env);

        if (izdo_div.type == Type.INT) {
          if (dercho_divi.type == Type.INT) {
            return new Literal(this.line, this.column, izdo_div.value / dercho_divi.value, Type.INT);
          } else if (dercho_divi.type == Type.FLOAT) {
            return new Literal(this.line, this.column, izdo_div.value / dercho_divi.value, Type.FLOAT);
          }
        } else if (izdo_div.type == Type.FLOAT) {
          if (dercho_divi.type == Type.INT) {
            return new Literal(this.line, this.column, izdo_div.value / dercho_divi.value, Type.FLOAT);
          } else if (dercho_divi.type == Type.FLOAT) {
            return new Literal(this.line, this.column, izdo_div.value / dercho_divi.value, Type.FLOAT);
          }
        }
      case 4:
        console.log("Expresion Aritmetica Modulo");
        const izdo_modulo = this.left.execute(env);
        const dercho_modulo = this.right.execute(env);

        if (izdo_modulo.type == Type.INT) {
          if (dercho_modulo.type == Type.INT) {
            return new Literal(this.line, this.column, izdo_modulo.value % dercho_modulo.value, Type.INT);
          }
        }
      default:
        let error = new Error(this.line, this.column, "Error semantico", "Operacion invalida");
        return error;
    }



  }

}

export default Arithmetic;