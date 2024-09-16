import Instruction from "../abstract/instruction.js";
import symbol from "../symbol/symbol.js";
import Error from "../exceptions/error.js";

class Declaracion extends Instruction {
  constructor(line, column, nombre, tipo, expresion) {
    super();
    this.nombre = nombre;
    this.tipo = tipo;
    this.expresion = expresion;
    this.line = line;
    this.column = column;
  }

  /*INT: "INT",
  FLOAT: "FLOAT",
  STRING: "STRING",
  BOOLEAN: "BOOLEAN",
  CHAR: "CHAR",*/

  execute(env) {
    console.log("Declaracion de variable");

    if (this.expresion == null) {
      console.log(this.tipo);

      
      switch (this.tipo) {
        case "INT":
          console.log("Entrando a INT");
          let simbolo = new symbol(this.nombre, 0, this.tipo);
          console.log("añadiendo Simbolo INT: " + this.nombre);
          let resp = env.add_symbol(simbolo);
           if(resp == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           } 
          break;
        case "FLOAT":
          console.log("Entrando a FLOAT");
          let simbolo_f = new symbol(this.nombre, 0.0, this.tipo);
          console.log("añadiendo Simbolo FLOAT: " + this.nombre);
          let respf = env.add_symbol(simbolo_f);
          if(respf == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           } 
          break;
        case "STRING":
          console.log("Entrando a STRING");
          let simbolo_s = new symbol(this.nombre, "", this.tipo);
          console.log("añadiendo Simbolo STRING: " + this.nombre);
          let resps = env.add_symbol(simbolo_s);
          if(resps == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           } 
          break;
        case "BOOLEAN":
          console.log("Entrando a BOOLEAN");
          let simbolo_b = new symbol(this.nombre, true, this.tipo);
          console.log("añadiendo Simbolo BOOLEAN: " + this.nombre);
          let respb = env.add_symbol(simbolo_b);
          console.log("resp: "+respb);
          if(respb == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           } 
          break;
        case "CHAR":
          console.log("Entrando a CHAR");
          let simbolo_c = new symbol(this.nombre, '', this.tipo);
          console.log("añadiendo Simbolo CHAR: " + this.nombre);
          let respc = env.add_symbol(simbolo_c);
          if(respc == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           } 
          break;

      }
   

    } else if(this.tipo == null){
      const result = this.expresion.execute(env);
      if (result instanceof Error) {
        env.agregarError(result);
      } else {
        let simbolo = new symbol(this.nombre, result.value, result.type);
        console.log("Agregando Simbolo: " + result.value);
        let resp = env.add_symbol(simbolo);
          if(resp == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           }

      }

    } else {
      const result = this.expresion.execute(env);
      if (result instanceof Error) {
        env.agregarError(result);
      } else {
        if (this.tipo == result.type) {
          let simbolo = new symbol(this.nombre, result.value, this.tipo);
          console.log("Simbolo: " + result.value);
          let resp = env.add_symbol(simbolo);
          if(resp == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           }
        } else if(this.tipo == "FLOAT" && result.type=="INT"){

          let simbolo = new symbol(this.nombre, parseFloat(result.value), this.tipo);
          console.log("Simbolo: " + result.value);
          let resp = env.add_symbol(simbolo);
          if(resp == "Existe"){
            let error = new Error(this.line, this.column, "Error Semantico", "Variable ya existente: "+this.nombre);
            env.agregarError(error);
           }

        } else {
          let error = new Error(this.line, this.column, "Error Semantico", "Tipo invalido");
          env.agregarError(error);
        }
      }
    }


  }
}

export default Declaracion;