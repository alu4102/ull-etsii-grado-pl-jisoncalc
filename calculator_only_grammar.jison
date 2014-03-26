/* description: Parses end executes mathematical expressions. */

/* operator associations and precedence */
%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%left '!'
%right '%'
%left UMINUS

%start prog

%% /* language grammar */
prog
    : expressions EOF
    ;

expressions
    : s  
    | expressions ';' s
    ;

s
    : /* empty */
    | e
    ;

e
    : ID '=' e
    | PI '=' e 
    | E '=' e 
    | e '+' e
    | e '-' e
    | e '*' e
    | e '/' e
    | e '^' e
    | e '!'
    | e '%'
    | '-' e %prec UMINUS
    | '(' e ')'
    | NUMBER
    | E
    | PI
    | ID 
    ;

