import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

/*
CONTINUE: 0,
 BREAK: 1,
 RETURN: 2 
 */

class Transferencia extends Instruction {

  constructor(line, column, tipo, expresion) {
    super();
    this.line = line;
    this.column = column;
    this.tipo = tipo;
    this.expresion = expresion;
  }

  execute(env) {
    console.log("=========================Sentencia de transferencia===================");

    if(this.expresion == null){
        if(this.tipo == 0){ // CONTINUE
            console.log("Continue");
        } else if(this.tipo == 1){ // BREAK 
            console.log("Break");
        } else if(this.tipo == 2){
            console.log("Return simple");
        }
    } else {
       //RETURN 
    
                console.log("Return con expresion");
                console.log(this.expresion.execute(env));
    
            
        }
    }
    
}
export default Transferencia;