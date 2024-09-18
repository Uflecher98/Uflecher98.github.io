import Instruction from "../abstract/instruction.js";
import Type from "../symbol/type.js";

class While extends Instruction {
  constructor(line, column, condicion, instrucciones) {
    super();
    this.line = line;
    this.column = column;
    this.condicion = condicion;
    this.instrucciones = instrucciones; 
}


  execute(env) {

    console.log("Entra a While --------------------------------------------");
    let condicion = this.condicion.execute(env);

    if(condicion.type == Type.BOOLEAN){

        while (this.condicion.execute(env).value==true){
            this.instrucciones.forEach(element => {
                element.execute(env);
            });
        }


    } else {
        let nuevoerror = new Error(this.linea, this.columna, "Error Semantico", "Fin de for no es una expresion logica");
        env.agregarError(nuevoerror);
    }

}
}

export default While;