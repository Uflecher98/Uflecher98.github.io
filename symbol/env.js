import Error from "../exceptions/error.js";

class Environment {
  #tabla_simbolos;
  #tabla_funciones;
  #tabla_errores;
  consola;
  constructor(parent) {
    this.parent = parent;
    this.#tabla_simbolos = new Map();
    this.#tabla_funciones = new Map();
    this.#tabla_errores = new Map();
    this.consola = "";
  }



getFuncion(){

}

encuentraFuncion(id){
  return this.buscarF(id, this);

}

buscarF(id,root){
  if(root === null || root === undefined) {
    return null;
  }

  let current = root.#tabla_funciones;
  for(const element of current) {
    if(element[0] === id) {
      return element[1];
    }
  }

  return this.buscarF(id, root.parent);

}




   getconsola() {
   // console.log("valor consola "+ this.consola);
    return this.consola;
  }
   setconsola(value) {
    this.consola = value;
  }
   actualizaConsola(valor, saltoLinea) {
    if(saltoLinea == 0){
      this.consola = `${this.consola}${valor}`;
    } else if(saltoLinea == 1){
      this.consola = `${this.consola}${valor}\n`;
    }
  }

  actualizarConsola(valor){
  
      this.consola += valor+"\n";
    
  }

  agregarError(error){
    let llave = error.tipo + " Linea: "+error.fila+" Columna: "+error.columna;
    let valor = error.valor;
    this.#tabla_errores.set(llave, valor);
  }

  obtenerTablaErrores(){
    return this.#tabla_errores;
  }

  obtenerTablaSimbolos(){
    return this.#tabla_simbolos;
  }

  add_symbol(symbol) {
    if(this.#find_symbol(symbol.id) === null) {
      this.#tabla_simbolos.set(symbol.id, symbol);
      return "Nuevo";
    } else {
      return "Existe";
    }
  }

  #find_symbol(id) {
    for(const iterator of this.#tabla_simbolos) {
      if(iterator[0] === id) {
       // console.log(iterator[1]);
        return iterator[1];
      }
    }

    return null;
  }

asignavalor(id, expr){
  return this.asignar_valor(id, this, expr);
}

asignar_valor(id, root, expresion){
  if(root === null || root === undefined) {
    return null;
  }


  for(const element of root.#tabla_simbolos) {
    if(element[0] === id) {
     // console.log("element 1 valor: "+element[1].type);
     // console.log("expresion valor: "+expresion.type);

      if(element[1].type == expresion.type){
        element[1].value = expresion.value;
        return ("Modifique variable");
      } else {
        let error = new Error(expresion.line, expresion.column, "Error Semantico", "Tipo no coincide");
        this.agregarError(error);
      }
  
    } else{
    //  console.log(element[0]);
    }
  }

  return this.asignar_valor(id, root.parent, expresion);

}

  buscar_variable(id) {
  //  console.log("buscar_variable ENTORNO:"+this);
    return this.#find_variable(id, this);
    
  }

  #find_variable(id, root) {
    console.log(root instanceof Environment);
    if(root === null || root === undefined) {
      //console.log("env/find_variable: retornando null");
      return null;
    } else{
      let current = root.#tabla_simbolos;
      for(const element of current) {
        //console.log("Ejecutando FOR ");
        ///console.log("element 0:" +element[0]);
        //console.log("id:" +id);
        if(element[0] === id) {
         // console.log("element"+element[1].value);
          return element[1];
        }
      }
    }
  

    return this.#find_variable(id, root.parent);
  }

  setFuncion(funcion){
    if(this.buscarFuncion(funcion.id) === null) {
      this.#tabla_funciones.set(funcion.id, funcion);
      return 1;
    } else{
      return 0;
  
    }
  }
  
  buscarFuncion(nombre){
    for(const iterator of this.#tabla_funciones) {
      if(iterator[0] === nombre) {
        console.log(iterator[1]);
        return iterator[1];
      }
    }
  
    return null;
  }



}

export default Environment;