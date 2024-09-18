import Instruction from "../abstract/instruction.js";

import Type from "../symbol/type.js";



class For extends Instruction {
  constructor(line, column, inicio, fin, paso, instrucciones) {
    super();
    this.line = line;
    this.column = column;
    this.inicio = inicio;
    this.fin = fin;
    this.paso = paso;
    this.instrucciones = instrucciones; 
}


  execute(env) {


    this.inicio.execute(env);


    let finFor = this.fin.execute(env);

    console.log(finFor.type);
  
    if(finFor.type == Type.BOOLEAN){

        while(this.fin.execute(env).value==true){
            this.instrucciones.forEach(element => {
                element.execute(env);
            });
            this.paso.execute(env);
        }
    } else {
        let nuevoerror = new Error(this.linea, this.columna, "Error Semantico", "Fin de for no es una expresion logica");
        env.agregarError(nuevoerror);
    }

}
}

export default For;