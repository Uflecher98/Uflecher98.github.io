

{

let arrIns = new Array();
let paramFunciones = new Array();
let llevaParametro;

let InstFor = new Array();
let InstWhile = new Array();
let InsIf = new Array();

const INTERMEDIA ={
    IF: 1,
    SWITCH: 2,
    FOR: 3,  
    WHILE: 4,
  };

  const FNATIVA_T ={
    PARSEINT: 1,
    PARSEFLOAT: 2,
    TOSTRING: 3,
    TYPEOF: 4,
    TOUPPER: 5, 
    TOLOWER: 6,
  };

  const ARITHMETIC_OP = {
    MAS: 0,
    MENOS: 1,
    MULTIPLICAR: 2,
    DIVIDIR: 3,
    MODULO: 4,
  };

  const RELATIONAL_OP = {
    MENOR_QUE: 0,
    MENOR_IGUAL: 1,
    MAYOR_QUE: 2,
    MAYOR_IGUAL: 3,
    IGUAL: 4,
    NO_IGUAL: 5,
  };

  const LOGICAL_OP = {
    AND: 0,
    OR: 1,
    NOT: 2
  };
}





S
  =instrucciones 

instrucciones
  = inst:instruccion   insts:instruccionesp 

instruccionesp
  = insts:instrucciones 
  / epsilon

instruccion
  =   inst:asignacion
  / inst:imprimir 
  / inst:funcion
  /inst:declaracion
  /inst:llamarFuncion
  /SimpleComment

llamarFuncion 
= _ id:ID "(" _ ")" ";"  {
  const loc = location()?.start;
    return new LlamarFuncion(loc?.line, loc?.column, id);
}

// ================================================================================= DECLARACION
declaracion
  = _ type:tipo id:ID _"=" expr:expresion ";" _ {
   
    const loc = location()?.start;
    return new Declaracion(loc?.line, loc?.column, id, type, expr);
  }
/_  type:tipo id:ID _ ";" _ {
  
  const loc = location()?.start;
  return new Declaracion(loc?.line, loc?.column, id, type, null);
}
/ _ "var" _  id:ID _ "="  expr:expresion  ";"_ {
  
    const loc = location()?.start;
    return new Declaracion(loc?.line, loc?.column, id, null, expr);
  }

// ================================================================================= ASIGNACION
asignacion
  = _ id:ID _ "=" _ expr:expresion ";" _ {
  
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr);
  }

// ================================================================================= IMPRIMIR
imprimir 
  = _ imprimirToken "(" expr:expresion _ ");"_ {  // Colocar en lugar de expresion un imprimible?
   
    const loc = location()?.start;
    return new Imprimir(loc?.line, loc?.column, expr);
  }


imprimible
= exp:expresion list:imprimiblep

imprimiblep
= "," list:imprimiblep 
/ epsilon2



  
// ================================================================================= FUNCION

/*La funcion puede declarse de las siguientes maneras:
tipo  identificador 
"void" identificador 

identificador identificador 





instrucciones
  = inst:instruccion   insts:instruccionesp 

instruccionesp
  = insts:instrucciones 
  / epsilon

instruccion
  = inst:declaracion               */

funcion
  = _ type:tipo id:ID _params:f_params "{" _ inst:instruccionesf _ "}" {  
    const loc = location()?.start;
    let aux = arrIns;
    arrIns = [];
    let auxParam = paramFunciones;
    paramFunciones = [];
    if (llevaParametro==0){
      return new Funcion(loc?.line, loc?.column, id, type, null, aux);
    } else if(llevaParametro==1){
      return new Funcion(loc?.line, loc?.column, id, type, auxParam, aux);
    }
    }
  
f_params
  = _ "(" l_params ")"

l_params
  = _ p:param list:l_paramsp  

l_paramsp
  = _ "," list:l_params 
  / epsilon2

param
  = _ type:tipo id:ID  {
    llevaParametro = 1; 
    const loc = location()?.start;
    paramFunciones.push(new Declaracion(loc?.line, loc?.column, id, type, null));}
  / epsilon2 {llevaParametro = 0;}


instruccionesf 
  = inst:instruccionf list:instruccionesfp 

instruccionesfp
  = ins:instruccionesf  
  / epsilon2

instruccionf
  = d:declaracion {  arrIns.push(d);}
  / a:asignacion { arrIns.push(a);}
  / ifIns:inst_if { arrIns.push(ifIns);}
  / switchIns:InstruccionSwitch { arrIns.push(switchIns);}
  / whileIns:InstruccionWhile { arrIns.push(whileIns);}
  / forIns:InstruccionFor { arrIns.push(forIns);}
  / i:imprimir {  arrIns.push(i);}
  / ll:llamarFuncion {  arrIns.push(ll);}
    /SimpleComment



// ================================================================================= IF 
  
/*IF SIMPLE*/
inst_if
=_ ifToken "(" expr:expresion ")" _ "{" _ instruccionesIf _ "}" {
 const loc = location()?.start;
  let instruIf = InsIf;
    InsIf = [];
  return new If(loc?.line, loc?.column, expr, instruIf);
}

  instruccionesIf 
  = inst:instruccionIf list:instruccionesIfp 

instruccionesIfp
  = ins:instruccionesIf  
  / epsilon2

instruccionIf
  = d:declaracion {  InsIf.push(d);}
  / a:asignacion { InsIf.push(a);}
  / ifIns:inst_if { InsIf.push(ifIns);}
  / switchIns:InstruccionSwitch { InsIf.push(switchIns);}
  / whileIns:InstruccionWhile { InsIf.push(whileIns);}
  / forIns:InstruccionFor { InsIf.push(forIns);}
  / i:imprimir {  InsIf.push(i);}
   / ll:llamarFuncion {  InsIf.push(ll);}
     /SimpleComment


// =========================================================================================== SWITCH

InstruccionSwitch 
= _ switchToken "(" expr:expresion ")" _ "{" _ cuerpoSwitch _ "}"

cuerpoSwitch 
= listaCases produDefault

listaCases				   	
  = caseToken elemCase listaPrima 	
 
listaPrima 
  = caseToken listaPrima 
  / epsilon2 

elemCase 
=  expresion ":" instruccionesf  breakToken ";"

produDefault 
= defaultToken ":" instruccionesf 
/ epsilon2

// =========================================================================================== FOR arreglo InstFor

/*
for (int i = 1; i <= 5; i++) {
System.out.println(i);
}
*/

InstruccionFor 
= _ forToken _ "(" _  inicio:inicioFor  fin:expresion ";" paso:asignacionFor ")" _ "{" _   instruccionesfor _ "}" _ {
  const loc = location()?.start;
  let instruccionesFor = InstFor;
    InstFor = [];
  return new For(loc?.line, loc?.column, inicio, fin, paso, instruccionesFor);
}

inicioFor 
= d:declaracion {return d;}
/ a:asignacion {return a;}

asignacionFor
  = _ id:ID "=" _ expr:expresion  _ {
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr);
  }

  instruccionesfor 
  = inst:instruccionfor list:instruccionesforp 

instruccionesforp
  = ins:instruccionesfor  
  / epsilon2

instruccionfor
  = d:declaracion {  InstFor.push(d);}
  / a:asignacion { InstFor.push(a);}
  / ifIns:inst_if { InstFor.push(ifIns);}
  / switchIns:InstruccionSwitch { InstFor.push(switchIns);}
  / whileIns:InstruccionWhile { InstFor.push(whileIns);}
  / forIns:InstruccionFor { InstFor.push(forIns);}
  / i:imprimir {  InstFor.push(i);}
   / ll:llamarFuncion {  InstFor.push(ll);}
     /SimpleComment


// ===========================================================================================  WHILE
/*while (true) {
//sentencias
}*/

InstruccionWhile 
= whileToken "(" expr:expresion ")" "{" instruccionesWhile "}" {
  const loc = location()?.start;
  let instruWhile = InstWhile;
    InstWhile = [];
  return new While(loc?.line, loc?.column, expr, instruWhile);
}

  instruccionesWhile 
  = inst:instruccionWhile list:instruccionesWhilep 

instruccionesWhilep
  = ins:instruccionesWhile  
  / epsilon2

instruccionWhile
  = d:declaracion {  InstWhile.push(d);}
  / a:asignacion { InstWhile.push(a);}
  / ifIns:inst_if { InstWhile.push(ifIns);}
  / switchIns:InstruccionSwitch { InstWhile.push(switchIns);}
  / whileIns:InstruccionWhile { InstWhile.push(whileIns);}
  / forIns:InstruccionFor { InstWhile.push(forIns);}
  / i:imprimir {  InstWhile.push(i);}
    / ll:llamarFuncion {  InstWhile.push(ll);}
      /SimpleComment

// ================================================================================= EXPRESIONES
expresion
  = e:expresion_logica {return e;}

expresion_logica
  = e:expresion_relacional op:(_("&&"/"||") _ expresion_relacional )*   {
    
    return op.reduce(function(result, element){
      const loc = location()?.start;
      if(element[1] === "&&") return new Logical(loc?.line, loc?.column, result, element[3], LOGICAL_OP.AND);
      else if(element[1] === "||") return new Logical(loc?.line, loc?.column, result, element[3], LOGICAL_OP.OR);
    }, e);
  }
  / notToken exp:expresion_relacional {
    const loc = location()?.start;
    return new Logical(loc?.line, loc?.column, null, exp, LOGICAL_OP.NOT);
  }
  / e:expresion_relacional {console.log("expresion relacional sola");
    return e;
  }
notToken 
= "!"
/* MENOR_QUE: 0,
    MENOR_IGUAL: 1,
    MAYOR_QUE: 2,
    MAYOR_IGUAL: 3,
    IGUAL: 4,
    NO_IGUAL: 5,*/


expresion_relacional
  = e:expresion_numerica op:(_(">="/"<="/">"/"<"/"=="/"!=")_ expresion_numerica)* {
   
    return op.reduce(function(result, element){
      const loc = location()?.start;
      if(element[1] === ">") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.MAYOR_QUE);
      else if(element[1] === "<") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.MENOR_QUE);
      else if(element[1] === ">=") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.MAYOR_IGUAL);
      else if(element[1] === "<=") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.MENOR_IGUAL);
      else if(element[1] === "==") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.IGUAL);
      else if(element[1] === "!=") return new Relational(loc?.line,loc?.column, result, element[3], RELATIONAL_OP.NO_IGUAL);
    }, e);
  }
  / e:expresion_numerica {console.log("expresion numerica sola");}

expresion_numerica
  = head:Term tail:(_("+"/"-")_ Term)* {
    
    return tail.reduce(function(result, element) {
      const loc = location()?.start;
        if (element[1] === "+") { return new Arithmetic(loc?.line,loc?.column, result, element[3], ARITHMETIC_OP.MAS);  }
        if (element[1] === "-") { return new Arithmetic(loc?.line,loc?.column, result, element[3], ARITHMETIC_OP.MENOS); }
    }, head);
  }

Term
  = head:Factor tail:(_("*"/"/"/"%")_ Factor)*
  {
    return tail.reduce(function(result, element) {
        const loc = location()?.start;
        if (element[1] === "*") { return new Arithmetic(loc?.line,loc?.column, result, element[3], ARITHMETIC_OP.MULTIPLICAR); }
        if (element[1] === "/") { return new Arithmetic(loc?.line,loc?.column, result, element[3], ARITHMETIC_OP.DIVIDIR); }
        if (element[1] === "%") { return new Arithmetic(loc?.line,loc?.column, result, element[3], ARITHMETIC_OP.MODULO); }   
     }, head);
  }
// boolean resultado = 2 + 3 > 4 && (1+1 < 3 || 2 + 2 > 1);
ParseInttkn
=_ "parseInt"

ParseFloattkn
=_ "parsefloat"

ToStringtkn
=_ "toString"

toLowertkn
=_ "toLowerCase"

toUppertkn
=_ "toUpperCase"

typeOftkn
=_ "typeof"

//============================================================================ FUNCIONES NATIVAS
/*
PARSEINT
    PARSEFLOAT
    TOSTRING
    TYPEOF
    TOUPPER
    TOLOWER
*/
Factor
  = _ "(" _ expr:expresion_numerica ")" { return expr;}
  
  / _ ParseInttkn "(" _ exp:expresion ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEINT);
  }
   / _ ParseFloattkn "(" _ exp:expresion  ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEFLOAT);
  }
  / _ ToStringtkn "(" _ exp:expresion  ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOSTRING);
  }
    / _ toLowertkn "(" _ exp:expresion  ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOLOWER);
  }
    / _ toUppertkn "(" _ exp:expresion  ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOUPPER);
  }
  / _ typeOftkn  _ exp:terminal 
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TYPEOF);
  }
  / terminal
  /_ "-" expr:expresion_numerica {
    const loc = location()?.start;
    return new Aritmetica(loc?.line, loc?.column, null, expr, ARITHMETIC_OP.MENOS);
  }

// ================================================================================= LITERAL / NATIVO 
terminal
  =  valor:FLOAT {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.FLOAT);
  }
  / valor:INTEGER {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.INT);
  }
    / valor:STRING {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.STRING);
    }
    / valor:CHAR {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.CHAR);
    }
    / valor:BOOLEAN {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.BOOLEAN);
  }
  / valor:ID {
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.IDENTIFICADOR);
  }
    /valor:nullToken{
    return null;
  }  
  
// ================================================================================= TIPOS
tipo
  = type:(_("int"/"float"/"string"/id:ID/"boolean"/"char")_){
    if(type[1] === "int") return Type.INT;
    else if(type[1] === "float") return Type.FLOAT;
    else  if(type[1] === "string") return Type.STRING;
    else if(type[1] === "boolean") return Type.BOOLEAN;
    else if(type[1] === "char") return Type.CHAR;
    else if(type[1] === "void") return Type.VOID;
  }




STRING "string"
  = _"\"" chars:[^\"]* "\"" _ 
  {
    return text();
  }

BOOLEAN "boolean"
  = _ tknFalse _ { return text(); }
  / _ tknTrue _ { return text(); }

CHAR "char"
 =  _"'"[^"'"]"'" _  { return text(); }

// expresiones regulares literal,terminal,primitivo


INTEGER "integer"
  = _[0-9]+ { return parseInt(text(), 10);}


FLOAT "float"
  = INTEGER "." INTEGER { return parseFloat(text());}

// ================================================================================= COMENTARIOS
SimpleComment
  = "//" (!EndComment .)* EndComment

EndComment
  = "\r" / "\n" / "\r\n"

ID "identificador"
  = !reservada  [a-zA-Z]([a-zA-Z]/[0-9]/"_")*  { return text(); }

reservada 
=  ParseInttkn 
/ParseFloattkn
/ToStringtkn
/toLowertkn
/toUppertkn
/typeOftkn
/ifToken 
/imprimirToken 
/tknFalse
/tknTrue
/nullToken 
/switchToken
/elseToken
/caseToken 
/breakToken
/defaultToken
/whileToken
/forToken
/continueToken
/returnToken



nullToken 
= "null"
switchToken
= "switch"
elseToken
= "else"
caseToken
= "case" 
breakToken
= "break"
defaultToken
= "default"
whileToken
= "while"
forToken
= "for"
continueToken
= "continue"
returnToken
= "return"

_ "Whitespace"
  = [ \t\n\r]*


epsilon = !. 
epsilon2 = ''



ifToken  = "if" 

imprimirToken = "System.out.println"

tknFalse= _ "false"_
tknTrue= _ "true"_

