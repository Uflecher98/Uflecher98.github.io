{


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

  const FARRAY ={
    INDEXOF: 1,
    JOIN: 2,
    LENGHT: 3,
    ACCES: 4,
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

  const TRANS = {
    CONTINUE: 0,
    BREAK: 1,
    RETURN: 2
  };

  let tipoDecla=0;
}

S 
=ins:instrucciones 
//= prueba

prueba 
= i:item l:listaP { if(l!=undefined){
 return [i, ...l];
}else{ return [i, l];}}

listaP 
= prueba 
/ epsilon 

item 
= reservada _

instrucciones
  = inst:instruccion    insts:instruccionesp  { 
    if(insts!=undefined){
        return [inst, ...insts];
    } else { 
        return [inst];
    }
}

instruccionesp
  = insts:instrucciones 
  / epsilon2 

instruccion
  =   inst:declaracion 
  / inst: asignacion
  / inst:MultiComment 
  / inst:SimpleComment
  /inst:InstruccionFor
  /inst:imprimir
  /inst:llamarFuncion
  /inst:funcion
  /inst:InstruccionSwitch
  /inst:inst_if
  /inst:InstruccionWhile
  /inst:declaracionArray
  /inst:Transfer


// ================================================================================= SENTENCIAS DE TRANFERENCIA

Transfer
= breakToken tknPuntoyComa {
   const loc = location()?.start;
    return new Transferencia(loc?.line, loc?.column, TRANS.BREAK, null);
}
/ continueToken tknPuntoyComa {
   const loc = location()?.start;
    return new Transferencia(loc?.line, loc?.column, TRANS.CONTINUE, null);
}
/ breakToken tknPuntoyComa {
   const loc = location()?.start;
    return new Transferencia(loc?.line, loc?.column, TRANS.BREAK, null);
}
/ returnToken tknPuntoyComa {
   const loc = location()?.start;
    return new Transferencia(loc?.line, loc?.column, TRANS.RETURN, null);
}
/ returnToken exp:expresion tknPuntoyComa {
   const loc = location()?.start;
    return new Transferencia(loc?.line, loc?.column, TRANS.RETURN, exp);
}


// ================================================================================= IMPRIMIR

imprimir 
  = imprimirToken parIzq expr:imprimible parDer tknPuntoyComa {  // Colocar en lugar de expresion un imprimible?
   
    const loc = location()?.start;
    return new Imprimir(loc?.line, loc?.column, expr);
  }


imprimible
= exp:expresion list:imprimiblep { 
  if(list!=undefined){
    return [exp, ...list];
  }else{
    return [exp, list];
    }
    }

imprimiblep
= "," list:imprimible {return list;}
/ epsilon2


// ================================================================================= DECLARACION DE ARRAYS
//  tipoDecla

declaracionArray
= type:tipo corcheteIzq corcheteDer _ id:ID _ tknIgual info:TDArrays
{
   const loc = location()?.start;
    return new DeclaracionArray(loc?.line, loc?.column, id, type, info, tipoDecla);
}

TDArrays
= llaveIzq val:valores llaveDer tknPuntoyComa {tipoDecla = 1; return val;}   
/ newToken tipo:tipo corcheteIzq valor:INTEGER corcheteDer tknPuntoyComa {tipoDecla = 2; return [tipo, valor];} 
/ _ id:ID _ tknPuntoyComa {tipoDecla = 3; return id;}  


// ================================================================================= DECLARACION  

declaracion
  =  type:tipo _ id:ID _ tknIgual expr:expresion tknPuntoyComa  {
   
    const loc = location()?.start;
    console.log("************************* TIPO ");
    console.log(type);
    return new Declaracion(loc?.line, loc?.column, id, type, expr);
  }
  / type:tipo _ id:ID _ tknPuntoyComa {
  
  const loc = location()?.start;
  return new Declaracion(loc?.line, loc?.column, id, type, null);
}
/ _ "var" _  id:ID _ tknIgual  expr:expresion  tknPuntoyComa {
  
    const loc = location()?.start;
    return new Declaracion(loc?.line, loc?.column, id, null, expr);
  }




// ================================================================================= ASIGNACION
asignacion
  =  id:ID  tknIgual  expr:expresion tknPuntoyComa  {
  
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr, -1);
  }
  / id:ID corcheteIzq i:INTEGER corcheteDer tknIgual  expr:expresion tknPuntoyComa {
  
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr, i);
  }

// ======================================================================================================================= FOR 
InstruccionFor 
=  forToken parIzq inicio:inicioFor  fin:expresion tknPuntoyComa paso:asignacionFor parDer llaveIzq  instfor:instrucciones llaveDer {
  const loc = location()?.start;
  return new For(loc?.line, loc?.column, inicio, fin, paso, instfor);
}

inicioFor 
= d:declaracion {return d;}
/ a:asignacion {return a;}

asignacionFor
  = _ id:ID  tknIgual expr:expresion  _ {
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr);
  }

// ================================================================================= FUNCION

/*La funcion puede declarse de las siguientes maneras:
tipo  identificador 
"void" identificador 

identificador identificador          */

funcion
  =  type:tipo id:ID params:f_params llaveIzq inst:instrucciones llaveDer {  
    const loc = location()?.start;
   
      return new Funcion(loc?.line, loc?.column, id, type, params, inst);
    
    }


  
f_params
  = _ parIzq l:l_params parDer {return l;}

l_params              //          LISTA DE PARAMETROS 
  = _ p:param list:l_paramsp   { if(list!=undefined){
 return [p, ...list];
}else{ return [p, list];}}

l_paramsp
  = _ "," _ list:l_params {return list;}
  / epsilon2

param
  = _ type:tipo id:ID  {
    const loc = location()?.start;
    return new Declaracion(loc?.line, loc?.column, id, type, null);}
  / epsilon2 

  llamarFuncion 
=  id:ID parIzq valores parDer tknPuntoyComa  {
  const loc = location()?.start;
    return new LlamarFuncion(loc?.line, loc?.column, id);
}

valores
= imprimible
/ epsilon2

// ================================================================================= IF
/*IF SIMPLE*/

inst_if

= ifToken parDer expr:expresion parDer llaveIzq instruIf:instrucciones llaveDer {
 const loc = location()?.start;
  
  return new If(loc?.line, loc?.column, expr, instruIf);
}

// =========================================================================================== SWITCH

/* expresion izquierda a comparar

    Arreglo de arreglos de instrucciones
    Arreglo de expresiones derechas a comparar 

    instrucciones default */


InstruccionSwitch 
=  switchToken parIzq expr:expresion parDer llaveIzq l:listaCases def:produDefault  llaveDer {
  const loc = location()?.start;
  return new Switch(loc?.line, loc?.column, expr, l, def);
}

listaCases				   	
  =  i:elemCase l:listaPrima 	{ if(l!=undefined){
 return [i, ...l];
}else{ return [i, l];}}
 
listaPrima 
  =  listaCases
  / epsilon2 

elemCase 
= caseToken exp:expresion ":" ins:instrucciones  breakToken tknPuntoyComa{
  return new Case(exp, ins);
}

produDefault 
= defaultToken ":" i:instrucciones{return i;} 
/ epsilon2

// ===========================================================================================  WHILE
/*while (true) {
//sentencias
}*/

InstruccionWhile 
= whileToken parIzq expr:expresion parDer llaveIzq instruWhile:instrucciones llaveDer {
  const loc = location()?.start;

  return new While(loc?.line, loc?.column, expr, instruWhile);
}

// ======================================================================================================================= TOKENS 
tknIgual 
= _ "=" _

tknPuntoyComa
=_";"_

ParseInttkn
=_ "parseInt" _

ParseFloattkn
=_ "parsefloat" _

ToStringtkn
=_ "toString" _

toLowertkn
=_ "toLowerCase" _

toUppertkn
=_"toUpperCase" _

typeOftkn
=_"typeof" _

ifToken  = _"if" _

imprimirToken = _"System.out.println"_

tknFalse= _"false"_
tknTrue= _"true"_

nullToken 
= _"null"_
switchToken
= _"switch"_
elseToken
= _"else"_
caseToken
= _"case"_ 
breakToken
= _"break"_
defaultToken
= _"default"_
whileToken
= _"while"_
forToken
= _"for"_
continueToken
= _"continue"_
returnToken
= _"return"_

newToken
= _"new"_

indexofToken
= _"indexOf"_

joinToken
= _"join"_

lenghtToken
= _"lenght"_

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
  = _[0-9]+ _ { return parseInt(text(), 10);}


FLOAT "float"
  = _ INTEGER "." INTEGER _ { return parseFloat(text());}



ID "identificador"
  = !reservada  _ [a-zA-Z]([a-zA-Z]/[0-9]/"_")* _  { return text().trim(); }

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
/newToken
/indexofToken
/joinToken
/lenghtToken



_ "Whitespace"
  = [ \t\n\r]*


epsilon = !. 
epsilon2 = ''

parIzq 
= _"("_

parDer 
= _")"_

llaveIzq 
= _"{"_

llaveDer 
= _"}"_

corcheteIzq
= _"["_

corcheteDer 
= _"]"_



// ================================================================================= COMENTARIOS



MultiComment
  = "/*"[^"*/"]*"*/" {
    const loc = location()?.start;
    return new Comentarios(loc?.line, loc?.column), text();
  }

  SimpleComment
  = "//" (!EndComment .)* EndComment {
    const loc = location()?.start;
    return new Comentarios(loc?.line, loc?.column, text());
  }

EndComment
  = "\r" / "\n" / "\r\n"

// ================================================================================= TIPOS
tipo
  = type:(_("int"/"float"/"string"/"boolean"/"char"/id:ID)_){
    if(type[1] === "int") return Type.INT;
    else if(type[1] === "float") return Type.FLOAT;
    else  if(type[1] === "string") return Type.STRING;
    else if(type[1] === "boolean") return Type.BOOLEAN;
    else if(type[1] === "char") return Type.CHAR;
    else if(type[1] === "void") return Type.VOID;
  }

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
  / e:expresion_relacional {
    return e;
  }
notToken 
= _"!"_
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

  Factor
  = parIzq expr:expresion_numerica parDer { return expr;}
  
  /  ParseInttkn parIzq exp:expresion parDer
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEINT);
  }
   /  ParseFloattkn parIzq exp:expresion  parDer
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEFLOAT);
  }
  /  ToStringtkn parIzq exp:expresion  parDer
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOSTRING);
  }
    /  toLowertkn parIzq exp:expresion  parDer
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOLOWER);
  }
    /  toUppertkn parIzq exp:expresion  parDer
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOUPPER);
  }
  /  typeOftkn   exp:terminal 
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TYPEOF);
  }
//******************************************** FUNCIONES DE ARRAYS ***********************************
  / ID "." indexofToken parIzq exp:expresion parDer
  {
    const loc = location()?.start;
    return new FArray(loc?.line,loc?.column,exp, FARRAY.INDEXOF);
  }
  / ID "." joinToken parIzq parDer
  {
    const loc = location()?.start;
    return new FArray(loc?.line,loc?.column, new Literal(loc?.line, loc?.column, 0, Type.INT), FARRAY.JOIN);
  }
  / ID "." lenghtToken 
  {
    const loc = location()?.start;
    return new FArray(loc?.line,loc?.column,new Literal(loc?.line, loc?.column, 0, Type.INT), FARRAY.LENGHT);
  }
/ ID corcheteIzq i:INTEGER corcheteDer
  {
    const loc = location()?.start;
    return new FArray(loc?.line,loc?.column, new Literal(loc?.line, loc?.column, i , Type.INT), FARRAY.ACCESO);
  }
 
  / _"-"_ expr:expresion_numerica {
    const loc = location()?.start;
    return new Arithmetic(loc?.line, loc?.column, null, expr, ARITHMETIC_OP.MENOS);
  }
  / terminal

// ================================================================================= LITERAL / NATIVO 
terminal
  =  valor:FLOAT{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.FLOAT);
  }
  / valor:INTEGER{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.INT);
  }
    / valor:STRING{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.STRING);
    }
    / valor:CHAR{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.CHAR);
    }
    / valor:BOOLEAN{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.BOOLEAN);
  }
  / valor:ID{
    const loc = location()?.start;
    return new Literal(loc?.line, loc?.column, valor, Type.IDENTIFICADOR);
  }
    /valor:nullToken{
    return null;
  }  
  



