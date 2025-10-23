// This is the "rule" file (an ANTLR v4 grammar) that
// we feed to grammarinator. It defines the "language"
// of our tiny calculator.

grammar tiny_calc_logic;

// 'start' is the entry point. A valid program is
// one expression ('expr') followed by the End-of-File marker.
start: expr EOF;

// 'expr' handles LOW precedence (addition/subtraction)
expr: m_expr (('+' | '-') m_expr)*;

// 'm_expr' handles HIGH precedence (multiplication/division)
m_expr: atom (('*' | '/') atom)*;

// 'atom' is the new base rule (what 'term' used to be)
atom: INT;

// Define what an Integer ('INT') looks like:
INT: '0' | [1-9][0-9]*;

// Define Whitespace ('WS') and tell the parser to 'skip' it.
WS: [ \t\r\n]+ -> skip;