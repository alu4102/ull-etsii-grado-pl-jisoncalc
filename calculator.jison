/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%{
var reserved_words ={ PI: 'PI', E : 'E'}

function idORrw(x) {
  return (x.toUpperCase() in reserved_words)? x.toUpperCase() : 'ID'
}

%}
%%

\s+                              /* skip whitespace */
\b\d+("."\d*)?([eE][-+]?\d+)?\b  return 'NUMBER'
\b[A-Za-z_]\w*\b                 return idORrw(yytext)
[-*/+^!%=();]                    return yytext;
.                                return 'INVALID'

/lex

%{
var symbol_table = {};

function fact (n) { 
  return n==0 ? 1 : fact(n-1) * n 
}
%}

/* operator associations and precedence */

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start prog

%% /* language grammar */
prog
    : expressions 
        { 
          $$ = $1; 
          console.log($$);
          return [$$, symbol_table];
        }
    ;

expressions
    : e 
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          $$ = [ $1 ]; }
    | expressions ';' e
        { $$ = $1;
          $$.push($3); 
          console.log($$);
        }
    ;

e
    : ID '=' e
        { symbol_table[$1] = $$ = $3; }
    | e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e '/' e
        {$$ = $1/$3;}
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = fact($1);
        }}
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

