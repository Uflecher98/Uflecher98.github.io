import Instruction from "../abstract/instruction.js";
import Type from "../symbol/type.js";
import Case from "./case.js";

class Switch extends Instruction {
    /* 
    int numero = 2;
    switch (numero) {
    case 1:
        System.out.println("Uno");
        break;
    case 2:
        System.out.println("Dos");
        break;
    case 3:
         System.out.println("Tres");
        break;
    default:
        System.out.println("Invalid day");
}
    
    Se necesita:
    expresion izquierda a comparar

    Arreglo de arreglos de instrucciones
    Arreglo de expresiones derechas a comparar 

    instrucciones default 

    */
    constructor(line, column, CondicionI, cases, insDefault) {
        super();
        this.line = line;
        this.column = column;
        this.CondicionIzq = CondicionI;
        this.cases = cases;
        this.instruccionesDefault = insDefault;
    }


    execute(env) {

        console.log("Entra a Switch --------------------------------------------");
console.log(this.CondicionIzq);
console.log(this.cases);     

this.cases.forEach((element)  => {     // recorrer el array de cases 
    console.log(element.expresion.value);    // expresion a comparar 
   // console.log(element.instrucciones);     // array de instrucciones del case

    let arrIns = element.instrucciones;  // recorrido del array de instrucciones 
    arrIns.forEach((ins)  => {
        //console.log(ins.execute(env));
        console.log(ins);
      });


  });
  console.log("Instrucciones default: ");
  console.log(this.instruccionesDefault);
 

    }
}

export default Switch;