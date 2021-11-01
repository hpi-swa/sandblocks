Class {
	#name : #SBJsGrammar,
	#superclass : #OhmGrammarSmalltalkProxy,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsGrammar class >> example [
	"self example"

	"SBJsGrammar recompile."
	| reader result |
	reader := SBJsGrammar semanticAction: SBJsSemantic new.
	result := reader grammar match: '() => {};' startingFrom: #File.
	result failed ifTrue: [result failure signal].
	SBEditor openFor: (reader value: result)
]

{ #category : #'as yet unclassified' }
SBJsGrammar class >> serializedGrammar [

	" commap op missing "
	^ 'JS <: BuiltInRules {
File = Statement*

Statement = SimpleStatement | lineGap | KeywordBlock | emptyStatement
emptyStatement = ";"
SimpleStatement = (Expression terminateStatement | Declaration terminateStatement)
lineGap = "\n\n"
terminateStatement = "\n" | ";" | end

Expression = SimpleExpression | ExpressionWithBraces
SimpleExpression = ArrowFunction | MethodCall | InfixOp | MemberAccess | name | PrefixOp | PostfixOp | literal | Function
ExpressionWithBraces = "(" SimpleExpression ")"

Declaration = ("let" | "const" | "var") name "=" Expression

Function = "function" "(" ListOf<name,","> ")" KeywordBodyWithBraces
ArrowFunction = "(" ListOf<name,","> ")" "=>" KeywordBody

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
