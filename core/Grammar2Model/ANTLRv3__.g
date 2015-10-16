lexer grammar ANTLRv3;
@header {
	package gts.modernization.parser.antlr;

	import gts.modernization.parser.antlr.*;
}

SCOPE : 'scope' ;
FRAGMENT : 'fragment' ;
TREE_BEGIN : '^(' ;
ROOT : '^' ;
BANG : '!' ;
RANGE : '..' ;
REWRITE : '->' ;
T65 : 'lexer' ;
T66 : 'parser' ;
T67 : 'tree' ;
T68 : 'grammar' ;
T69 : ';' ;
T70 : '}' ;
T71 : '=' ;
T72 : '@' ;
T73 : '::' ;
T74 : '*' ;
T75 : 'protected' ;
T76 : 'public' ;
T77 : 'private' ;
T78 : 'returns' ;
T79 : ':' ;
T80 : 'throws' ;
T81 : ',' ;
T82 : '(' ;
T83 : '|' ;
T84 : ')' ;
T85 : 'catch' ;
T86 : 'finally' ;
T87 : '+=' ;
T88 : '=>' ;
T89 : '~' ;
T90 : '?' ;
T91 : '+' ;
T92 : '.' ;
T93 : '$' ;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 464
SL_COMMENT
 	:	'//'
 	 	(	' $ANTLR ' SRC // src directive
 		|	~('\r'|'\n')*
		)
		'\r'? '\n'
		{$channel=HIDDEN;}
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 473
ML_COMMENT
	:	'/*' {if (input.LA(1)=='*') $type=DOC_COMMENT; else $channel=HIDDEN;} .* '*/'
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 477
CHAR_LITERAL
	:	'\'' LITERAL_CHAR '\''
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 481
STRING_LITERAL
	:	'\'' LITERAL_CHAR LITERAL_CHAR* '\''
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 485
fragment
LITERAL_CHAR
	:	ESC
	|	~('\''|'\\')
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 491
DOUBLE_QUOTE_STRING_LITERAL
	:	'"' LITERAL_CHAR* '"'
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 495
DOUBLE_ANGLE_STRING_LITERAL
	:	'<<' .* '>>'
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 499
fragment
ESC	:	'\\'
		(	'n'
		|	'r'
		|	't'
		|	'b'
		|	'f'
		|	'"'
		|	'\''
		|	'\\'
		|	'>'
		|	'u' XDIGIT XDIGIT XDIGIT XDIGIT
		|	. // unknown, leave as it is
		)
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 515
fragment
XDIGIT :
		'0' .. '9'
	|	'a' .. 'f'
	|	'A' .. 'F'
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 522
INT	:	'0'..'9'+
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 525
ARG_ACTION
	:	NESTED_ARG_ACTION
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 529
fragment
NESTED_ARG_ACTION :
	'['
	(	options {greedy=false; k=1;}
	:	NESTED_ARG_ACTION
	|	ACTION_STRING_LITERAL
	|	ACTION_CHAR_LITERAL
	|	.
	)*
	']'
	{setText(getText().substring(1, getText().length()-1));}
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 542
ACTION
	:	NESTED_ACTION ( '?' {$type = SEMPRED;} )?
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 546
fragment
NESTED_ACTION :
	'{'
	(	options {greedy=false; k=3;}
	:	NESTED_ACTION
	|	SL_COMMENT
	|	ML_COMMENT
	|	ACTION_STRING_LITERAL
	|	ACTION_CHAR_LITERAL
	|	.
	)*
	'}'
	{$channel = DEFAULT_TOKEN_CHANNEL;}
   ;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 561
fragment
ACTION_CHAR_LITERAL
	:	'\'' (ACTION_ESC|~('\\'|'\'')) '\''
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 566
fragment
ACTION_STRING_LITERAL
	:	'"' (ACTION_ESC|~('\\'|'"'))+ '"'
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 571
fragment
ACTION_ESC
	:	'\\\''
	|	'\\"'
	|	'\\' ~('\''|'"')
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 578
TOKEN_REF
	:	'A'..'Z' ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 582
RULE_REF
	:	'a'..'z' ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 586
/** Match the start of an options section.  Don't allow normal
 *  action processing on the {...} as it's not a action.
 */
OPTIONS
	:	'options' WS_LOOP '{' {$channel=DEFAULT_TOKEN_CHANNEL;} // WS_LOOP sets channel
	;
	
// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 593
TOKENS
	:	'tokens' WS_LOOP '{' {$channel=DEFAULT_TOKEN_CHANNEL;}
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 597
/** Reset the file and line information; useful when the grammar
 *  has been generated so that errors are shown relative to the
 *  original file like the old C preprocessor used to do.
 */
fragment
SRC	:	'src' ' ' file=ACTION_STRING_LITERAL ' ' line=INT {$channel=HIDDEN;}
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 605
WS	:	(	' '
		|	'\t'
		|	'\r'? '\n'
		)+
		{$channel=HIDDEN;}
	;

// $ANTLR src "C:\Users\martyn.ellison\git\gra2mol\core\Grammar2Model\src\ANTLRv3.g3" 612
fragment
WS_LOOP
	:	(	WS
		|	SL_COMMENT
		|	ML_COMMENT
		)*
		{$channel=HIDDEN;}
	;

