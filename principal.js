
//import { parse } from "./parser/parser.js";
import { parse } from  "./parser/analizador.js";
import Environment from "./symbol/env.js";
import Generator from "./symbol/generador.js"

const input = document.getElementById("Ingreso");
const salida = document.getElementById("Consola");

const btnFuncion = document.getElementById("btn1");

btnFuncion.addEventListener("click", Funcion);



function Funcion() {

  const c = input.value;
  //console.log(c);
  //const result = parse(c);
const codigo = `float resta=7-5; resta="cadena";`;
  //const codigo = `int suma=1+1; int suma2=2.3+2.2;int resta=9-6; int multi=2.3*2; int div=27/9; int modulo=9%2;`;
  console.log("estoy enviando a parsear: " + c);
  const resultado = parse(c);
  const global = new Environment(null);


  const gen = new Generator();

  console.log("main/resultado: " + Array.isArray(resultado));
  console.log("main/tamanio: " + resultado.length);
  console.log(resultado);


  try {
    for (let i = 0; i < resultado.length; i++) {
      if (typeof resultado[i] == "string") {
        continue;
      }
      resultado[i].execute(global, gen);
    }

    console.log(gen.getFinalCode()); // escribirlo en un archivo .s | imprimir en la consola.
  } catch (error) {
    console.error(error);
    return;
  } finally {
    // generar de erores y de TS.
  }


  /*for (let i = 0; i < resultado.length; i++) {
    resultado[i].execute(global, gen);
  }*/



  let tablaSimbolos = global.obtenerTablaSimbolos();
  tablaSimbolos.forEach(function(valor, nombre){
    console.log("id: "+nombre+": "+valor.value);
  })

  let tablaErrores = global.obtenerTablaErrores();
  tablaErrores.forEach(function(valor, error){
    console.log(error +" "+ valor);
  })




  salida.value = global.getconsola();











  /* resultado.forEach((element)  => {
     console.log(element);
     
     element.execute(global);
   }); */

  // resultado[0].execute(global);


  // console.log(resultado);
  //salida.innerHTML = result;
}