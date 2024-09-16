

{

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



ID "identificador"
  = !reservada[a-zA-Z]([a-zA-Z]/[0-9]/"_")* _ { return text(); }

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

S
  =instrucciones 
instrucciones
  = inst:instruccion   insts:instruccionesp 

instruccionesp
  = insts:instrucciones 
  / epsilon

instruccion
  = inst:declaracion 
  / inst:asignacion
  / inst:imprimir 
  / inst:funcion



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
/ _ "var" id:ID "=" expr:expresion _ ";"_ {
    const loc = location()?.start;
    return new Declaracion(loc?.line, loc?.column, id, null, expr);
  }

// ================================================================================= ASIGNACION
asignacion
  = _ id:ID "=" _ expr:expresion ";" _ {
    const loc = location()?.start;
    return new Asignacion(loc?.line, loc?.column, id, expr);
  }

// ================================================================================= IMPRIMIR
imprimir 
  = _ imprimirToken "(" expr:expresion ");"_ {  // Colocar en lugar de expresion un imprimible?
    console.log("Entra produccion imprimir");
    const loc = location()?.start;
    return new Imprimir(loc?.line, loc?.column, expr);
  }

imprimibles
= inst:imprimible list:imprimiblep

imprimiblep
= list:imprimibles ","
/ ''

imprimible
= expresion


// ================================================================================= FUNCION
funcion
  = type:tipo id:ID params:f_params "{" _ inst:instruccionesf _ "}"


f_params
  = "(" l_params ")"

l_params
  = p:param list:l_paramsp  

l_paramsp
  = "," list:l_params
  / epsilon

param
  = type:tipo id:ID   


instruccionesf 
  = inst:instruccionf list:instruccionesfp

instruccionesfp
  = instruccionesf instruccionesfp
  / epsilon

instruccionf
  = declaracion
  / asignacion
  / inst_if

// ================================================================================= IF 
inst_if
  = "if" "(" expr:expresion ")" "{" inst:instruccionesf "}" r_if

r_if
  = b_else+
  / epsilon

b_else
  = "else" else_if

else_if
  = "{" inst:instruccionesf "}" 
  / inst_if 
  

// ================================================================================= EXPRESIONES
expresion
  = e:expresion_logica {return e;}

expresion_logica
  = e:expresion_relacional op:(_("&&"/"||") _ expresion_relacional )*   {
    console.log("expresion logica");
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
    console.log("expresion relacional op");
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
    console.log("expresion numerica");
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
  
  / _ ParseInttkn "(" _ exp:expresion _ ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEINT);
  }
   / _ ParseFloattkn "(" _ exp:expresion _ ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.PARSEFLOAT);
  }
  / _ ToStringtkn "(" _ exp:expresion _ ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOSTRING);
  }
    / _ toLowertkn "(" _ exp:expresion _ ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOLOWER);
  }
    / _ toUppertkn "(" _ exp:expresion _ ")"
  {
    const loc = location()?.start;
    return new FNativa(loc?.line,loc?.column,exp, FNATIVA_T.TOUPPER);
  }
  / _ typeOftkn  _ exp:terminal _ 
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



_ "Whitespace"
  = [ \t\n\r]*

epsilon = !.

ifToken  = "if" 

imprimirToken = "System.out.println"

tknFalse= _ "false"_
tknTrue= _ "true"_

