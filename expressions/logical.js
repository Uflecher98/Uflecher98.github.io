import Expression from "../abstract/expression.js";
import Type from "../symbol/type.js";
import Literal from "./literal.js";

class Logica extends Expression {
  constructor(line, column, left, right, op) {
    super();
    this.line = line;
    this.column = column;
    this.left = left;
    this.right = right;
    this.op = op;
  }

  /*   AND: 0,
    OR: 1,
    NOT: 2 */

  execute(env) {
    
    console.log("Expresion logica");

   if (this.left == null){
    const derecho = this.right.execute(env);
    if (derecho instanceof Error) {
      env.agregarError(derecho);
      return null;
    } else if (derecho.type == Type.BOOLEAN) {
      let booleano = !derecho.value;
      console.log("Logica igual a " + booleano);
      let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
      return respuesta;
    }

   } else {
    const izquierdo = this.left.execute(env);
    const derecho = this.right.execute(env);

    if (izquierdo instanceof Error) {
      env.agregarError(izquierdo);
      return null;
    } else if (derecho instanceof Error) {
      env.agregarError(derecho);
      return null;
    } else {
      if (izquierdo.type == Type.BOOLEAN && derecho.type == Type.BOOLEAN){

        if(this.op==0){     //========================================================================== AND &&
          let booleano = izquierdo.value && derecho.value;
            console.log("Logica igual a " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
        } else if (this.op==1){ //========================================================================== OR ||
          let booleano = izquierdo.value || derecho.value;
            console.log("Logica igual a " + booleano);
            let respuesta = new Literal(this.line, this.column, booleano, Type.BOOLEAN);
            return respuesta;
        } 

      } else {
        let error = new Error(this.line, this.column, "Error semantico", "Tipo no valido Operacion Logica");
       return error;
      }
    }
   }
   let error = new Error(this.line, this.column, "Error semantico", " Operacion Logica no se puede realizar");
   return error;

    
  }
}

export default Logica;