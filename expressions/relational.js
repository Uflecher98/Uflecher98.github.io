import Expression from "../abstract/expression.js";
import Error from "../exceptions/error.js";
import Type from "../symbol/type.js";
import Literal from "./literal.js";
class Relational extends Expression {
  constructor(line, column, left, right, op) {
    super();
    this.left = left;
    this.right = right;
    this.op = op;
    this.line = line;
    this.column = column;
  }

  /* MENOR_QUE: 0,
   MENOR_IGUAL: 1,
   MAYOR_QUE: 2,
   MAYOR_IGUAL: 3,
   IGUAL: 4,
   NO_IGUAL: 5,
   */

  execute(env) {
    console.log("Executing RELATIONAL expression...");

    const resultado_izdo = this.left.execute(env);
    const resultado_derecho = this.right.execute(env);

    if (resultado_izdo instanceof Error) {
      env.agregarError(resultado_izdo);
      return null;
    } else if (resultado_derecho instanceof Error) {
      env.agregarError(resultado_derecho);
      return null;
    } else {
      if (this.op == 4) {
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value == resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.BOOLEAN && resultado_derecho.type == Type.BOOLEAN
          || resultado_izdo.type == Type.STRING && resultado_derecho.type == Type.STRING
          || resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value == resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }

      } else if (this.op == 5) {
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value != resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.BOOLEAN && resultado_derecho.type == Type.BOOLEAN
          || resultado_izdo.type == Type.STRING && resultado_derecho.type == Type.STRING
          || resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value != resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }
      }  else if (this.op == 0) { // =====================================================MENOR QUE
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value < resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value < resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }
      } else if (this.op == 1) { // =====================================================MENOR IGUAL QUE
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value <= resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value <= resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }
      } else if (this.op == 2) { // =====================================================MAYOR QUE
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value > resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value > resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }
      } else if (this.op == 3) {  // =====================================================MAYOR IGUAL QUE
        if (resultado_izdo.type == Type.INT || resultado_izdo.type == Type.FLOAT) {
          if (resultado_derecho.type == Type.INT || resultado_derecho.type == Type.FLOAT) {
            let booleano = resultado_izdo.value >= resultado_derecho.value;
            console.log("Relacional igual " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
          }
        } else if (resultado_izdo.type == Type.CHAR && resultado_derecho.type == Type.CHAR) {
          let booleano = resultado_izdo.value >= resultado_derecho.value;

          console.log("Relacional igual " + booleano);
          let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
          return respuesta;
        }
      }
    }
    let error = new Error(this.line, this.column, "Error semantico", "Operacion relacional invalida");
    return error;

  }
}

export default Relational;