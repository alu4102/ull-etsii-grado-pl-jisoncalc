/* description: Parses end executes mathematical expressions. */

%{                                              //codigo de soporte
var symbol_table = {};

function fact (n) { 
  return n==0 ? 1 : fact(n-1) * n 
}
%}

/* operator associations and precedence */      //Direcctivas

%right '='                                     
%left '+' '-'         //En el caso de 2+3-2 elegimos el arbol de la izquierda (left) Cuando el + y el - se "pelean" coge el arbol hundido a izquiedas 
%left '*' '/'         //En el caso de 2*1/3 elegimos el arbol de la izquierda (left)
%left '^'             //El * tiene mas prioridad que el + y el -
%right '%'            //Cuanto mas abajo este una directiva mas prioridad tiene
%left UMINUS          
%left '!'             

%start prog                                                 //simbolo de arranque

%% /* language grammar */
prog                                                          
    : expressions EOF
        { 
          $$ = $1; 
          console.log($$);
          return [$$, symbol_table];
        }
    ;                                                       //fin de las reglas de prog

expressions
    : s  
        { $$ = (typeof $1 === 'undefined')? [] : [ $1 ]; }
    | expressions ';' s
        { $$ = $1;
          if ($3) $$.push($3); 
          console.log($$);
        }
    ;

s
    : /* empty */
    | e
    ;

e
    : ID '=' e
        { symbol_table[$1] = $$ = $3; }
    | PI '=' e 
        { throw new Error("Can't assign to constant 'π'"); }
    | E '=' e 
        { throw new Error("Can't assign to math constant 'e'"); }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {
          if ($3 == 0) throw new Error("Division by zero, error!");
          $$ = $1/$3;
        }
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {
          if ($1 % 1 !== 0) 
             throw "Error! Attempt to compute the factorial of "+
                   "a floating point number "+$1;
          $$ = fact($1);
        }
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID 
        { $$ = symbol_table[yytext] || 0; }
    ;

