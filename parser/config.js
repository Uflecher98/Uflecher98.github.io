
module.exports = {
  format: "es",
  input: "parser.pegjs",
  dependencies: {
    Arithmetic: "../expressions/arithmetic.js",
    Type: "../symbol/type.js",
    Logical: "../expressions/logical.js",
    Relational: "../expressions/relational.js",
    Literal: "../expressions/literal.js",
    Declaracion: "../instructions/declaration.js",
    Asignacion: "../instructions/asignacion.js",
    If: "../instructions/if.js",
    Imprimir: "../instructions/imprimir.js",
    FNativa: "../instructions/fnativa.js",
  },
};