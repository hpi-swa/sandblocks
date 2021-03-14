Class {
	#name : #SBJsGrammar,
	#superclass : #OhmGrammarSmalltalkProxy,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsGrammar class >> serializedGrammar [

	^ 'JS <: BuiltInRules {
File = Statement*

Statement = SimpleStatement | lineGap | KeywordBlock | emptyStatement
emptyStatement = ";"
SimpleStatement = (Expression terminateStatement | Declaration terminateStatement)
lineGap = "\n\n"
terminateStatement = "\n" | ";" | end

Expression = SimpleExpression | ExpressionWithBraces
SimpleExpression = MethodCall | InfixOp | MemberAccess | name | PrefixOp | PostfixOp | literal | Function
ExpressionWithBraces = "(" SimpleExpression ")"

Declaration = ("let" | "const" | "var") name "=" Expression

Function = "function" "(" ListOf<name,","> ")" KeywordBodyWithBraces

KeywordBlock = keyword "(" ListOf<Expression,";"> ")" KeywordBody
KeywordBody = KeywordBodyWithBraces | Statement
KeywordBodyWithBraces = "{" Statement* "}"
keyword = "if" | "else" | "while" | "else if" | "for"

MethodCall = Expression "(" ListOf<Expression,","> ")"

PrefixOp = prefixOperator Expression
prefixOperator = "new" | "delete" | "++" | "--" | "await" | "yield" | "yield*" | "return"

MemberAccess = DirectMemberAccess | ComputedMemberAccess
DirectMemberAccess = Expression "." name
ComputedMemberAccess = Expression "[" Expression "]"

InfixOp = Expression infixOperator Expression
infixOperator = "+" | "-" | "/" | "*" | "%" | "**"
	| "in" | "instanceof" | "<" | ">" | "<=" | ">="
	| "==" | "!=" | "===" | "!=="
	| "<<" | ">>" | ">>>"
	| "&" | "|" | "^"
	| "&&" | "||" | "??"
	| "?."
	| "=" | "*=" | "**=" | "/=" | "%=" | "+=" | "-=" | "<<=" | ">>=" | ">>>=" | "&=" | "^=" | "|=" | "&&=" | "||=" | "??="
	| ","

PostfixOp = Expression postfixOperator
postfixOperator = "++" | "--"

literal = number | string
number = "-"? digit+ ("." digit+)?
string = "\"" letter* "\"" | "''" letter* "''"

name = ~reservedWord actualName
actualName = (letter (letter | digit)*)
reservedWord = "break"    | "do"        | "instanceof" | "typeof"
          | "case"     | "else"      | "new"        | "var"
          | "catch"    | "finally"   | "return"     | "void"
          | "continue" | "for"       | "switch"     | "while"
          | "debugger" | "function"  | "this"       | "with"
          | "default"  | "if"        | "throw"      | "const"
          | "delete"   | "in"        | "try"        | "let"

}'
]
