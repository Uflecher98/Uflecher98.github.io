
import { parse } from "./parser/parser.js";
import Environment from "./symbol/env.js";

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


  console.log("main/resultado: " + Array.isArray(resultado));
  console.log("main/tamanio: " + resultado.length);






  /*for (let i = 0; i < resultado.length; i++) {
    resultado[i].execute(global);
  }*/




  function recorrido(resul) {

    try {
      resul[0].execute(global);
      let aux = resul[1];
      recorrido(aux);
    } catch (error) {
      console.log("Error en principal.js: "+ error);
    }


  }

  recorrido(resultado);

  let tablaSimbolos = global.obtenerTablaSimbolos();
  tablaSimbolos.forEach(function(valor, nombre){
    console.log("id: "+nombre+": "+valor.value);
  })

  let tablaErrores = global.obtenerTablaErrores();
  tablaErrores.forEach(function(valor, error){
    console.log(error +" "+ valor);
  })




  salida.value = global.getconsola();


 /* resultado[0].execute(global);
  let resultado2 = resultado[1];

  resultado2[0].execute(global);
  let resultado3 = resultado2[1];

  resultado3[0].execute(global);
  let resultado4 = resultado3[1];

  resultado4[0].execute(global);
*/









  /* resultado.forEach((element)  => {
     console.log(element);
     
     element.execute(global);
   }); */

  // resultado[0].execute(global);


  // console.log(resultado);
  //salida.innerHTML = result;
}