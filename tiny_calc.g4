// This is the "rule" file (an ANTLR v4 grammar) that
// we feed to grammarinator. It defines the "language"
// of our tiny calculator.

grammar tiny_calc;

// 'start' is the entry point. A valid program is
// one expression ('expr') followed by the End-of-File marker.
start: expr EOF;

// An 'expr' is a 'term' followed by
// zero or more ('*') instances of a ('+' or '-') and another 'term'.
expr: term (('+' | '-') term)*;

// A 'term' is just an integer.
term: INT;

// Define what an Integer ('INT') looks like:
// one or more ('+') digits from 0-9.
INT: [0-9]+; // Problem
// INT: '0' | [1-9][0-9]*; // Solution

// Define Whitespace ('WS') and tell the parser to 'skip' it.
WS: [ \t\r\n]+ -> skip;