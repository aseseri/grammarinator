grammar JSON;
json: object | array;
object: '{' (pair (',' pair)*)? '}';
pair: STRING ':' value;
array: '[' (value (',' value)*)? ']';
value: STRING | NUMBER | object | array | 'true' | 'false' | 'null';
STRING: '"' (~'"')* '"';
NUMBER: '-'? INT ('.' INT)? (('e' | 'E') ('+' | '-')? INT)?;
INT: '0' | [1-9][0-9]*;