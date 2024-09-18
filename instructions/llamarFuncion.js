import Instruction from "../abstract/instruction.js";
import Type from "../symbol/type.js";

class LlamarFuncion extends Instruction {
  constructor(line, column, id) {
    super();
    this.line = line;
    this.column = column;
    this.id = id;
}


  execute(env) {
    console.log("   ENTRA A EJECUTAR FUNCION");

    let encontrar = env.encuentraFuncion(this.id)

    if(encontrar == null){
        let error = new Error(this.line, this.column, "Error Semantico", "Funcion no existente");
        env.agregarError(error);
    } else{
        console.log("Es arreglo instrucciones: " + Array.isArray(encontrar.instrucciones));
        console.log("tamanio del arreglo: " + encontrar.instrucciones.length);
    
        if(encontrar.parametros==null){
            console.log("Sin parametros");
        } else {
            console.log("Es arreglo parametros: " + Array.isArray(encontrar.parametros));
            console.log("tamanio del arreglo de parametros : " + encontrar.parametros.length);
    
            for (let i = 0; i < encontrar.parametros.length; i++) {
                encontrar.parametros[i].execute(env);
                 
              }
    
        }
       
    
        let resultado = encontrar.instrucciones;
    
            for (let i = 0; i < encontrar.instrucciones.length; i++) {
            resultado[i].execute(env);
    
          }
        }
    }

    


}

export default LlamarFuncion;