Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBStMethodSubstitution,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'example grammars' }
SBGrammarTransformer class >> all [
	"broken"

	SBGrammarTransformer grammarTinyJava simplifyAndOpen.
	"working"
	SBGrammarTransformer grammarStatemachine simplifyAndOpen.
	SBGrammarTransformer grammarSonificationBlocks simplifyAndOpen.
	SBGrammarTransformer grammarQL simplifyAndOpen.
	SBGrammarTransformer grammarRascalJava18 simplifyAndOpen.
	SBGrammarTransformer grammarMath simplifyAndOpen.
	SBGrammarTransformer grammarIki simplifyAndOpen.
	SBGrammarTransformer grammarRascalJavascript simplifyAndOpen.
	SBGrammarTransformer grammarMiniJava simplifyAndOpen.
	^ SBGrammarTransformer grammarCloudLang simplifyAndOpen
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> connectorsOf: rule on: aStream original: anOriginalGrammar [

	| usages |
	usages := (self originalRuleFor: rule in: rule parentSandblock from: anOriginalGrammar) allUsages.
	usages ifNotEmpty: [
		(usages anySatisfy: [:identifier | identifier parentSandblock isRepeatQuantifier not or: [identifier isPrimitive]])
			ifTrue: [aStream nextPutAll: 'this.setOutput(true, null);']
			ifFalse: [
				aStream
					nextPutAll: 'this.setPreviousStatement(true, null);';
					nextPutAll: 'this.setNextStatement(true, null);']]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> disassemblePrecedenceLists: g [

	| ops |
	" disassemble list-like precedence constructs, e.g.
 A ('+' A)*"
	ops := OrderedCollection new.
	g allBlocksDo: [:b |
		(b isSequence and: [
			b childSandblocks size = 2 and: [
				b childSandblocks first isIdentifier and: [ | q |
					q := b childSandblocks second.
					q isQuantifier and: [ | seq |
						seq := q expression.
						seq isSequence and: [seq childSandblocks size = 2 and: [(self isTerminal: seq childSandblocks first in: g) and: [seq childSandblocks second isIdentifier and: [seq childSandblocks second contents = b childSandblocks first contents]]]]]]]]) ifTrue: [ops add: b]].
	ops do: [:b |
		b childSandblocks second replaceBy: b childSandblocks second expression.
		b mergeRedundantGroups.
		SBWrapCommand new
			inner: b;
			outer: SBOhmList new;
			wrap: [:outer :inner |
				outer
					connect: 'OR'
					expressions: {inner. SBOhmIdentifier new contents: inner childSandblocks first contents}];
			do]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> extractSequencesInQuantifiers: g [

	| seqs extractCounts |
	" extract terminals or seqs of non-primitives inside quantifiers "
	seqs := OrderedCollection new.
	g allBlocksDo: [:b | (b isQuantifier and: [(b expression isSequence and: [b expression childSandblocks anySatisfy: [:c | c isTerminal not or: [c isIdentifier and: [c isPrimitive not]]]]) or: [b expression isTerminal]]) ifTrue: [seqs add: b expression]].
	extractCounts := Dictionary new.
	SBToggledCode comment: '' active: 1 do: {
		[
			seqs do: [:seq | | basename rname |
				basename := seq containingRule name.
				rname := 'GEN', (extractCounts at: basename ifAbsentPut: [1]), basename.
				seq replaceBy: (SBOhmIdentifier new contents: rname).
				g addMorphBack: (SBOhmRule new name: rname alternatives: seq).
				extractCounts at: basename put: (extractCounts at: basename) + 1]]}
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> fieldFor: aPart on: aStream [

	(aPart isAlternative and: [aPart childSandblocks allSatisfy: #isTerminal]) ifTrue: [
		^ aStream
			nextPutAll: '.appendField(new Blockly.FieldDropdown([';
			nextPutAll: ((aPart childSandblocks collect: [:o | '["{1}", "{1}"]' format: {o contents}]) joinSeparatedBy: ', ');
			nextPutAll: ']))'].
	
	aPart isTerminal ifTrue: [
		^ aStream
			nextPutAll: '.appendField("';
			nextPutAll: aPart textContents;
			nextPutAll: '")'].
	
	(aPart isIdentifier and: [aPart isPrimitive]) ifTrue: [^ aStream nextPutAll: '.appendField(new Blockly.FieldTextInput(''''), "NAME")'].
	
	aPart isSequence ifTrue: [^ aPart childSandblocksDo: [:part | self fieldFor: part on: aStream]].
	
	aPart isIdentifier ifTrue: [^ self].
	
	(aPart isQuantifier and: [aPart quantifier = $?]) ifTrue: [^ self fieldFor: aPart expression on: aStream].
	
	(aPart isQuantifier and: [aPart allBlocksDetect: #isIdentifier ifFound: [:b | b isSimple] ifNone: [true]]) ifTrue: [" TODO: could add valid chars list "
	^ aStream nextPutAll: '.appendField(new Blockly.FieldTextInput(''''), "NAME")'].
	
	" handled through the input type "
	aPart isQuantifier ifTrue: [^ self].
	
	^ self error: 'not supported'
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> findPatternFor: aBlock in: aCollection [

	aCollection ifNotEmpty: [
		aCollection do: [:group |
			" TODO: groups of literals! "
			self
				matchTerminalsOf: aBlock
				and: group first
				differenceDo: [:lit1 :lit2 | ^ group add: aBlock]
				noMatch: []]].
	^ aCollection add: (OrderedCollection with: aBlock)
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> flattenOptionals: g [

	g allBlocksDo: [:b | (b isQuantifier and: [b quantifier = $?]) ifTrue: [b replaceBy: b expression]].
	g mergeRedundantGroups
]

{ #category : #'generate helper' }
SBGrammarTransformer class >> grammar: anOhmGrammar steps: aCollection [

	| grammar |
	grammar := anOhmGrammar veryDeepCopy.
	aCollection do: [:block | block value: grammar].
	self openFor: grammar original: anOhmGrammar
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarBibtex [

	^ OhmGrammar new: 'Bibtex {

BibtexDB =
  Comment? CommandsOrEntries*

CommandsOrEntries = 
  CommandOrEntry Comment?

CommandComment =
  "comment" | "Comment"

CommandOrEntry =
  "@" (CommandComment | Preamble | String | Entry)

Comment =
  (~"@" any)+

Entry = 
	identifier ( "{" key EntryBody? "}" | "(" keyParen EntryBody? ")" )

EntryBody = 
 ("," StringBody)* ","?

Preamble =
  "preamble" ("{" "}" | "(" ")")

String = 
  "string" ("{" StringBody "}" | "(" StringBody ")")

StringBody =
  identifier "=" bibValue

balanced =
  "{" balanced+ "}" --brackets
  | (~("{" | "}") any) -- any

bibValue = 
  piece (space* "#" space* piece)*

identifier = 
  ~digit
  ( ~("#" | "=" | "%" | " " | "\"" | "\''" | "," | "{" | "}" | "(" | ")" )
    any )+

key = 
  (~("," | space | "}") any)*

keyParen = 
  (~("," | space | ")") any)*

piece =
  digit+ --number
  | "{" balanced* "}" --brackets
  | "\"" (~"\"" balanced)* "\"" --string
  | identifier --identifier}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarCloudLang [

	^ SBGrammarSimplify new grammar: 'G <: BuiltInRules {
Resources = "resources" "{" Instance* "}"

Instance = "Instance" Image CPU Memory Storage IPV6

Memory = "memory:" integerValue "GB"

Storage = "Storage:" StorageType "size:" integerValue "GB"

StorageType = "ECS" | "SSD"

IPV6 = "IPV6:" booleanValue

CPU = "CPU:" integerValue

Image = "AWS" | "Ubuntu" | "RHEL"

integerValue = digit+

booleanValue = "true" | "false"}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarComplexSmalltalk [

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'OhmExplicitSendsSmalltalk <: BuiltInRules {

ArrayLiteral =
	ByteArrayLiteral
	| ObjectArrayLiteral
	| LiteralArrayLiteral

AssignmentOperation =
	bindableIdentifier assignmentOperator

BinaryMessage =
	binaryMessageSelector BinaryMessageArgument

BinaryMethodHeader =
	binaryMessageSelector bindableIdentifier

BlockArguments =
	blockArgument+ "|"

BlockLiteral =
	"[" BlockArguments? ExecutableCode? "]" -- normal
	| "[" blockArgument+ "]" -- specialEmpty

ByteArrayLiteral =
	"#[" integerLiteral* "]"

CascadedMessages =
	MessageChain (";" MessageChain)+

ExecutableCode =
	LocalVariableDeclarationList? Pragmas? MoreExecutableCode

Expression =
	Operand CascadedMessages -- operandCascade
	| UnaryMessageReceiver CascadedMessages -- unaryCascade
	| BinaryMessageReceiver CascadedMessages -- binaryCascade
	| KeywordMessageSend 
	
BinaryMessageSend =
	BinaryMessageReceiver BinaryMessage?
 
BinaryMessageReceiver =
	BinaryMessageSend ~";"
	| UnaryMessageSend
	| Operand

BinaryMessageArgument =
	UnaryMessageSend

UnaryMessageSend = 
	UnaryMessageReceiver UnaryMessage -- message
	| Operand -- base

UnaryMessageReceiver =
	UnaryMessageSend ~";"
	| Operand

KeywordMessageSend = 
	KeywordMessageReceiver KeywordMessageSegment*

KeywordMessageReceiver = 
	BinaryMessageSend

FinalStatement =
	"^"? Statement "."?

KeywordMessage =
	KeywordMessageSegment+

KeywordMessageArgument =
	BinaryMessageSend

KeywordMessageSegment =
	keyword KeywordMessageArgument

KeywordMethodHeader =
	KeywordMethodHeaderSegment+

KeywordMethodHeaderSegment =
	keyword bindableIdentifier

KeywordPragma =
	pragmaKey pragmaLiteral*

Literal =
	constantReference
	| pseudoVariableReference
	| scaledDecimalLiteral
	| floatingPointLiteral
	| integerLiteral
	| characterLiteral
	| stringLiteral
	| symbolLiteral
	| ArrayLiteral
	| BlockLiteral

LiteralArrayLiteral =
	"#(" literalArrayLiteralElement*  ")"

LiteralArrayLiteralInLiteralArray =
	"#"? "(" literalArrayLiteralElement*  ")"

LocalVariableDeclarationList =
	"|" bindableIdentifier* "|"

MessageChain =
	KeywordMessage
	| BinaryMessage  
	| UnaryMessage 

MethodDeclaration =
	MethodHeader Pragmas ExecutableCode

MethodHeader =
	KeywordMethodHeader
	| BinaryMethodHeader
	| UnaryMethodHeader

MethodReturnOperator =
	"^"

MoreExecutableCode = 
	Statements FinalStatement?

NestedExpression =
	"(" Statement ")"

ObjectArrayLiteral =
	"{" ObjectArrayLiteralElement* "}"

ObjectArrayLiteralElement =
	Statement "." --normal
	| Statement --finalExpression

Operand =
	Literal
	| Reference
	| NestedExpression

Pragma = 
	"<" PragmaValues ">"

PragmaValues =
	KeywordPragma+ | unaryPragma

Pragmas =
	Pragma*

Reference = 
	identifier

Statement =
	AssignmentOperation* Expression

Statements =
	(~MethodReturnOperator Statement? ".")*

UnaryMessage =
	~keyword UnaryMessageSelector
	
UnaryMessageSelector =
	identifier

UnaryMethodHeader =
	UnaryMessageSelector

assignmentOperator =
	":=" | "_"

baseNIntegerLiteral =
	numberSigns? alnum+

binaryMessageSelector =
	binarySelectorChar+

binarySelectorChar =
	"~" | "!" | "@" | "%" | "&" | "*" | "-" | "+" | "=" | "|" | "\\" | "<" | ">" | "," | "?" | "/"

bindableIdentifier =
	~reservedIdentifier identifier

blockArgument =
	":" space* letter alnum*

byteArrayNumber =
	digit -- oneDigit
	| digit digit 	-- twoDigits
	| ("1"|"2") digit digit -- threeDigits

characterLiteral =
	"$" any

comment =
	"\"" (~"\"" any)* "\""

constantReference =
	("true" | "false" | "nil") ~(alnum | "_")

decimalIntegerLiteral =
	numberSigns? digit+

exponent =
	("e" | "d" | "q") decimalIntegerLiteral

floatingPointLiteral =
	radixFloatingPointLiteral
	| normalFloatingPointLiteral

identifier =
	letter (alnum | "_")*

integerLiteral = 
	numberSigns? radix "r" baseNIntegerLiteral --radix
	| numberSigns? digit+ --normal

keyword =
	identifier ":"

literalArrayLiteralElement =
	floatingPointLiteral
	| integerLiteral
	| constantReference
	| stringLiteral
	| ByteArrayLiteral
	| symbolInArrayLiteral
	| symbolLiteral
	| characterLiteral
	| LiteralArrayLiteralInLiteralArray

normalFloatingPointLiteral =
	decimalIntegerLiteral ("." digit+)? exponent --exponent
	| decimalIntegerLiteral "." digit+ --normal

numberSigns =
	"-"

pragmaKey =
	identifier ":"

pragmaLiteral =
	~pragmaKey ~">" literalArrayLiteralElement

pseudoVariableReference = 
	("self" | "super" | "thisContext") ~(alnum | "_")

radix =
	decimalIntegerLiteral

radixFloatingPointLiteral =
	decimalIntegerLiteral "r" normalFloatingPointLiteral

reservedIdentifier =
	constantReference
	| pseudoVariableReference

scaledDecimalLiteral =
	decimalIntegerLiteral ("." digit+)? "s" decimalIntegerLiteral?

space +=
	comment

stringLiteral =
	"\''" (~"\''" any | "\''\''")* "\''"

symbolInArrayLiteral =
	letter (alnum | ":")* --plain
	| binaryMessageSelector --binarySelector
	| (alnum | "." | "," | ":" | "[" | "]" | "|" | "^" | assignmentOperator)+ --code

symbolLiteral =
	"#" space* letter (alnum | ":" | "_")* -- normal
	| "#" space*  stringLiteral -- fromString
	| "#" space*  binaryMessageSelector -- fromBinarySelector
	| "#:" -- colonSymbol

unaryPragma =
	identifier
	
}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarIki [
	" https://cs.lmu.edu/~ray/notes/ohmexamples/ "

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'Iki {
  Program     =  Block
  Block       =  (Stmt ";")+
  Stmt        =  var id ":" Type             -- declaration
              |  Var "=" Exp                 -- assignment
              |  read Var ("," Var)*         -- read
              |  write Exp ("," Exp)*        -- write
              |  while Exp loop Block endw   -- while
  Type        =  int | bool
  Exp         =  Exp or Exp1                 -- binary
              |  Exp1
  Exp1        =  Exp1 and Exp2               -- binary
              |  Exp2
  Exp2        =  Exp3 relop Exp3             -- binary
              |  Exp3
  Exp3        =  Exp3 addop Exp4             -- binary
              |  Exp4
  Exp4        =  Exp4 mulop Exp5             -- binary
              |  Exp5
  Exp5        =  prefixop Exp6               -- unary
              |  Exp6
  Exp6        =  boollit
              |  intlit
              |  Var
              |  "(" Exp ")"                 -- parens
  Var         =  id

  var         =  "var" ~idchar
  read        =  "read" ~idchar
  write       =  "write" ~idchar
  while       =  "while" ~idchar
  loop        =  "loop" ~idchar
  endw        =  "end" ~idchar
  int         =  "int" ~idchar
  bool        =  "bool" ~idchar
  tr        =  "true" ~idchar
  fl       =  "false" ~idchar
  or          =  "or" ~idchar
  and         =  "and" ~idchar
  not         =  "not" ~idchar

  keyword     =  var | int | bool
              |  read | write | while | loop | endw
              |  tr | fl | or | and | not
  id          =  ~keyword letter idchar*
  idchar      =  "_" | alnum
  intlit      =  digit+
  boollit     =  tr | fl
  addop       =  "+" | "-"
  relop       =  "<=" | "<" | "==" | "!=" | ">=" | ">"
  mulop       =  "*" | "/" | "%"
  prefixop    =  ~"--" "-" | not

  space      +=  comment
  comment     =  "--" (~"\n" any)* "\n"
}';
		yourself
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarMath [

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'OhmMath {

Exp
    = AddExp

AddExp
    = AddExp "+" MulExp  -- plus
    | AddExp "-" MulExp  -- minus
    | MulExp

  MulExp
    = MulExp "*" ExpExp  -- times
    | MulExp "/" ExpExp  -- divide
    | ExpExp

  ExpExp
    = PriExp "^" ExpExp  -- power
    | PriExp

  PriExp
    = "(" Exp ")"  -- paren
    | "+" PriExp   -- pos
    | "-" PriExp   -- neg
    | ident
    | number

  ident 
    = letter alnum*

  number 
    = digit* "." digit+  -- fract
    | digit+             -- whole
}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarMiniJava [
	" adapted from https://github.com/cwi-swat/rascal-minijava/blob/master/src/lang/minijava/Syntax.rsc "

	^ SBGrammarSimplify new
		postDo: [:grammar |
			(grammar ruleNamed: 'Statement')
				setProperty: #kogiOutput
				toValue: 'input_statement'.
			SBToggledCode comment: '' active: 0 do: {
				[
					(grammar ruleNamed: 'Type') expression childSandblocks last
						setProperty: #preferredChoice
						toValue: true]}];
		grammar: 'G <: BuiltInRules {
integer = digit+

identifier = letter (letter | digit | "_")*

Expression
	 = Expression "." "length" -- b
	| integer -- a
	| "true" -- c
	| "false" -- d
	| identifier -- e
	| "this" -- f
	| "new" "int" "[" Expression "]" -- g
	| "new" identifier "(" ")" -- h
	| "(" Expression ")" -- i
	| Expression "[" Expression "]" -- j
	| Expression "." identifier "(" ExpressionList? ")" -- k
	| "!" Expression -- l
	| Expression "*" Expression -- m
	| Expression "+" Expression -- n
	| Expression "-" Expression -- o
	| Expression "<" Expression -- p
	| Expression "&&" Expression -- q

ExpressionList = Expression ("," ExpressionList)?

Statement
	 = "{" Statement* "}" -- a
	| "if" "(" Expression ")" Statement "else" Statement -- b
	| "while" "(" Expression ")" Statement -- c
	| "System" "." "out" "." "println" "(" Expression ")" ";" -- d
	| identifier "=" Expression ";" -- e
	| identifier "[" Expression "]" "=" Expression ";" -- f

FormalList = Type identifier ("," FormalList)?

Type
	 = "int" "[" "]" -- a
	| "boolean" -- b
	| "int" -- c
	| identifier -- d

MethodDecl = "public" Type identifier "(" FormalList? ")" "{" VarDecl* Statement* "return" Expression ";" "}"

VarDecl = Type identifier ";"

ClassDecl = "class" identifier ("extends" identifier)? "{" VarDecl* MethodDecl* "}"

MainClass = "class" identifier "{" "public" "static" "void" "main" "(" "String" "[" "]" identifier ")" "{" Statement* "}" "}"}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarOhmJavascript [
	");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'License AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/* (end of original copyright and license) */

NOTE: Heavily shortened to the point of incorrectness to be able to load with an SBOhmGrammar "
	"https://github.com/harc/ohm/blob/master/examples/ecmascript/src/es5.ohm
/*
  This grammar was originally based on Tom Van Cutsem's ES5 parser from the
  es-lab project (https://github.com/tvcutsem/es-lab/blob/master/src/parser/es5parser.ojs),
  and was adapted to Ohm by Tony Garnock-Jones <tonygarnockjones@gmail.com> in 2014.

  The original copyright and license follows:
*/

// Copyright (C) 2009 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'ES5 {

  Program = &(Directive*) SourceElement*

  sourceCharacter = any

  space := whitespace | lineTerminator | comment

  whitespace = "\t"
             | "\x0B"    -- verticalTab
             | "\x0C"    -- formFeed
             | " "
             | "\u00A0"  -- noBreakSpace
             | "\uFEFF"  -- byteOrderMark

  lineTerminator = "\n" | "\r" | "\u2028" | "\u2029"
  lineTerminatorSequence = "\n" | "\r" ~"\n" | "\u2028" | "\u2029" | "\r\n"

  comment = multiLineComment | singleLineComment

  multiLineComment = "/*" (~"*/" sourceCharacter)* "*/"
  singleLineComment = "//" (~lineTerminator sourceCharacter)*

  identifier (an identifier) = ~reservedWord identifierName
  identifierName = identifierStart identifierPart*

  identifierStart = letter | "$" | "_"
  identifierPart = identifierStart
  reservedWord = keyword | futureReservedWord | nullLiteral | booleanLiteral

  keyword = break    | do        | instanceof | typeof
          | case     | else      | new        | var
          | catch    | finally   | return     | void
          | continue | for       | switch     | while
          | debugger | function  | this       | with
          | default  | if        | throw
          | delete   | in        | try

  futureReservedWordLax = class  | enum  | extends
                        | super  | const | export
                        | import

  futureReservedWordStrict = futureReservedWordLax
                           | implements | let     | private   | public
                           | interface  | package | protected | static
                           | yield

  futureReservedWord = futureReservedWordStrict

  literal = nullLiteral | booleanLiteral | numericLiteral
          | stringLiteral | regularExpressionLiteral
  nullLiteral = "null" ~identifierPart
  booleanLiteral = ("true" | "false") ~identifierPart

  numericLiteral = octalIntegerLiteral | hexIntegerLiteral | decimalLiteral

  decimalLiteral = decimalIntegerLiteral "." decimalDigit* exponentPart? -- bothParts
                 |                       "." decimalDigit+ exponentPart? -- decimalsOnly
                 | decimalIntegerLiteral                   exponentPart? -- integerOnly

  decimalIntegerLiteral = nonZeroDigit decimalDigit*  -- nonZero
                        | "0"                         -- zero
  decimalDigit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
  nonZeroDigit = "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

  exponentPart = exponentIndicator signedInteger
  exponentIndicator = "e" | "E"
  signedInteger = "+" decimalDigit* -- positive
                | "-" decimalDigit* -- negative
                |     decimalDigit+ -- noSign

  hexIntegerLiteral = "0x" hexDigit+
                    | "0X" hexDigit+

  octalIntegerLiteral = "0" octalDigit+

  octalDigit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7"

  stringLiteral = "\"" doubleStringCharacter* "\""
                | "''" singleStringCharacter* "''"
  doubleStringCharacter = ~("\"" | "\\" | lineTerminator) sourceCharacter -- nonEscaped
                        | "\\" escapeSequence                             -- escaped
                        | lineContinuation                                -- lineContinuation
  singleStringCharacter = ~("''" | "\\" | lineTerminator) sourceCharacter -- nonEscaped
                        | "\\" escapeSequence                            -- escaped
                        | lineContinuation                               -- lineContinuation
  lineContinuation = "\\" lineTerminatorSequence
  escapeSequence = unicodeEscapeSequence
                 | hexEscapeSequence
                 | octalEscapeSequence
                 | characterEscapeSequence
  characterEscapeSequence = singleEscapeCharacter
                          | nonEscapeCharacter
  singleEscapeCharacter = "''" | "\"" | "\\" | "b" | "f" | "n" | "r" | "t" | "v"
  nonEscapeCharacter = ~(escapeCharacter | lineTerminator) sourceCharacter
  escapeCharacter = singleEscapeCharacter | decimalDigit | "x" | "u"
  octalEscapeSequence = zeroToThree octalDigit octalDigit    -- whole
                      | fourToSeven octalDigit               -- eightTimesfourToSeven
                      | zeroToThree octalDigit ~decimalDigit -- eightTimesZeroToThree
                      | octalDigit ~decimalDigit             -- octal
  hexEscapeSequence = "x" hexDigit hexDigit
  unicodeEscapeSequence = "u" hexDigit hexDigit hexDigit hexDigit

  zeroToThree = "0" | "1" | "2" | "3"
  fourToSeven = "4" | "5" | "6" | "7"

  regularExpressionLiteral = "/" regularExpressionBody "/" regularExpressionFlags
  regularExpressionBody = regularExpressionFirstChar regularExpressionChar*
  regularExpressionFirstChar = ~("*" | "\\" | "/" | "[") regularExpressionNonTerminator
                             | regularExpressionBackslashSequence
                             | regularExpressionClass
  regularExpressionChar = ~("\\" | "/" | "[") regularExpressionNonTerminator
                        | regularExpressionBackslashSequence
                        | regularExpressionClass
  regularExpressionBackslashSequence = "\\" regularExpressionNonTerminator
  regularExpressionNonTerminator = ~(lineTerminator) sourceCharacter
  regularExpressionClass = "[" regularExpressionClassChar* "]"
  regularExpressionClassChar = ~("]" | "\\") regularExpressionNonTerminator
                             | regularExpressionBackslashSequence
  regularExpressionFlags = identifierPart*

  multiLineCommentNoNL = "/*" (~("*/" | lineTerminator) sourceCharacter)* "*/"

  spacesNoNL = (whitespace | singleLineComment | multiLineCommentNoNL)*

  sc = space* (";" | end)
     | spacesNoNL (lineTerminator | ~multiLineCommentNoNL multiLineComment | &"}")

  break = "break" ~identifierPart
  do = "do" ~identifierPart
  instanceof = "instanceof" ~identifierPart
  typeof = "typeof" ~identifierPart
  case = "case" ~identifierPart
  else = "else" ~identifierPart
  new = "new" ~identifierPart
  var = "var" ~identifierPart
  catch = "catch" ~identifierPart
  finally = "finally" ~identifierPart
  return = "return" ~identifierPart
  void = "void" ~identifierPart
  continue = "continue" ~identifierPart
  for = "for" ~identifierPart
  switch = "switch" ~identifierPart
  while = "while" ~identifierPart
  debugger = "debugger" ~identifierPart
  function = "function" ~identifierPart
  this = "this" ~identifierPart
  with = "with" ~identifierPart
  default = "default" ~identifierPart
  if = "if" ~identifierPart
  throw = "throw" ~identifierPart
  delete = "delete" ~identifierPart
  in = "in" ~identifierPart
  try = "try" ~identifierPart
  get = "get" ~identifierPart
  set = "set" ~identifierPart
  class = "class" ~identifierPart
  enum = "enum" ~identifierPart
  extends = "extends" ~identifierPart
  super = "super" ~identifierPart
  const = "const" ~identifierPart
  export = "export" ~identifierPart
  import = "import" ~identifierPart
  implements = "implements" ~identifierPart
  let = "let" ~identifierPart
  private = "private" ~identifierPart
  public = "public" ~identifierPart
  interface = "interface" ~identifierPart
  package = "package" ~identifierPart
  protected = "protected" ~identifierPart
  static = "static" ~identifierPart
  yield = "yield" ~identifierPart
  
  noIn = ~in
  withIn =

  PrimaryExpression = this
                    | identifier
                    | literal
                    | ArrayLiteral
                    | ObjectLiteral
                    | "(" Expression<withIn> ")"  -- parenExpr

  ArrayLiteral = "[" ListOf<AssignmentExpressionOrElision, ","> "]"
  AssignmentExpressionOrElision = AssignmentExpression<withIn>
                                |                       -- elision

  ObjectLiteral = "{" ListOf<PropertyAssignment, ","> "}"              -- noTrailingComma
                | "{" NonemptyListOf<PropertyAssignment, ","> "," "}"  -- trailingComma

  PropertyAssignment = get PropertyName "(" ")" "{" FunctionBody "}"                  -- getter
                     | set PropertyName "(" FormalParameter ")" "{" FunctionBody "}"  -- setter
                     | PropertyName ":" AssignmentExpression<withIn>                  -- simple

  PropertyName = identifierName
               | stringLiteral
               | numericLiteral

  MemberExpression = MemberExpression "[" Expression<withIn> "]"  -- arrayRefExp
                   | MemberExpression "." identifierName  -- propRefExp
                   | new MemberExpression Arguments       -- newExp
                   | FunctionExpression
                   | PrimaryExpression

  NewExpression = MemberExpression
                | new NewExpression -- newExp

  CallExpression = CallExpression "[" Expression<withIn> "]"  -- arrayRefExp
                 | CallExpression "." identifierName  -- propRefExp
                 | CallExpression Arguments           -- callExpExp
                 | MemberExpression Arguments         -- memberExpExp

  Arguments = "(" ListOf<AssignmentExpression<withIn>, ","> ")"

  LeftHandSideExpression = CallExpression
                         | NewExpression

  PostfixExpression = LeftHandSideExpression spacesNoNL "++"  -- postIncrement
                    | LeftHandSideExpression spacesNoNL "--"  -- postDecrement
                    | LeftHandSideExpression

  UnaryExpression = delete UnaryExpression  -- deleteExp
                  | void   UnaryExpression  -- voidExp
                  | typeof UnaryExpression  -- typeofExp
                  | "++"   UnaryExpression  -- preIncrement
                  | "--"   UnaryExpression  -- preDecrement
                  | "+"    UnaryExpression  -- unaryPlus
                  | "-"    UnaryExpression  -- unaryMinus
                  | "~"    UnaryExpression  -- bnot
                  | "!"    UnaryExpression  -- lnot
                  | PostfixExpression

  MultiplicativeExpression = MultiplicativeExpression "*" UnaryExpression -- mul
                           | MultiplicativeExpression "/" UnaryExpression -- div
                           | MultiplicativeExpression "%" UnaryExpression -- mod
                           | UnaryExpression

  AdditiveExpression = AdditiveExpression "+" MultiplicativeExpression -- add
                     | AdditiveExpression "-" MultiplicativeExpression -- sub
                     | MultiplicativeExpression

  ShiftExpression = ShiftExpression "<<" AdditiveExpression  -- lsl
                  | ShiftExpression ">>>" AdditiveExpression -- lsr
                  | ShiftExpression ">>" AdditiveExpression  -- asr
                  | AdditiveExpression

  RelationalExpression<guardIn>
    = RelationalExpression<guardIn> "<" ShiftExpression           -- lt
    | RelationalExpression<guardIn> ">" ShiftExpression           -- gt
    | RelationalExpression<guardIn> "<=" ShiftExpression          -- le
    | RelationalExpression<guardIn> ">=" ShiftExpression          -- ge
    | RelationalExpression<guardIn> "instanceof" ShiftExpression  -- instanceOfExp
    | RelationalExpression<guardIn> guardIn "in" ShiftExpression  -- inExp
    | ShiftExpression

  EqualityExpression<guardIn>
    = EqualityExpression<guardIn> "==" RelationalExpression<guardIn>  -- equal
    | EqualityExpression<guardIn> "!=" RelationalExpression<guardIn>  -- notEqual
    | EqualityExpression<guardIn> "===" RelationalExpression<guardIn> -- eq
    | EqualityExpression<guardIn> "!==" RelationalExpression<guardIn> -- notEq
    | RelationalExpression<guardIn>

  BitwiseANDExpression<guardIn>
    = BitwiseANDExpression<guardIn> "&" EqualityExpression<guardIn> -- band
    | EqualityExpression<guardIn>

  BitwiseXORExpression<guardIn>
    = BitwiseXORExpression<guardIn> "^" BitwiseANDExpression<guardIn> -- bxor
    | BitwiseANDExpression<guardIn>

  BitwiseORExpression<guardIn>
    = BitwiseORExpression<guardIn> "|" BitwiseXORExpression<guardIn> -- bor
    | BitwiseXORExpression<guardIn>

  LogicalANDExpression<guardIn>
    = LogicalANDExpression<guardIn> "&&" BitwiseORExpression<guardIn> -- land
    | BitwiseORExpression<guardIn>

  LogicalORExpression<guardIn>
    = LogicalORExpression<guardIn> "||" LogicalANDExpression<guardIn> -- lor
    | LogicalANDExpression<guardIn>

  ConditionalExpression<guardIn>
    = LogicalORExpression<guardIn> "?" AssignmentExpression<withIn> ":" AssignmentExpression<guardIn> -- conditional
    | LogicalORExpression<guardIn>

  AssignmentExpression<guardIn>
    = LeftHandSideExpression assignmentOperator AssignmentExpression<guardIn> -- assignment
    | ConditionalExpression<guardIn>

  Expression<guardIn> (an expression)
    = Expression<guardIn> "," AssignmentExpression<guardIn> -- commaExp
    | AssignmentExpression<guardIn>

  assignmentOperator = "=" | ">>>=" | "<<=" | ">>="
                     | "*=" | "/=" | "%=" | "+=" | "-=" | "&=" | "^=" | "|="

  Statement
    = Block
    | VariableStatement
    | EmptyStatement
    | ExpressionStatement
    | IfStatement
    | IterationStatement
    | ContinueStatement
    | BreakStatement
    | ReturnStatement
    | WithStatement
    | LabelledStatement
    | SwitchStatement
    | ThrowStatement
    | TryStatement
    | DebuggerStatement

  Block = "{" StatementList "}"

  StatementList = Statement*

  VariableStatement = var VariableDeclarationList<withIn> sc

  VariableDeclarationList<guardIn> = NonemptyListOf<VariableDeclaration<guardIn>, ",">

  VariableDeclaration<guardIn> = identifier Initialiser<guardIn>?

  Initialiser<guardIn> = "=" AssignmentExpression<guardIn>

  EmptyStatement = ";"

  ExpressionStatement = ~("{" | function) Expression<withIn> sc

  IfStatement = if "(" Expression<withIn> ")" Statement (else Statement)?

  IterationStatement = do Statement while "(" Expression<withIn> ")" sc  -- doWhile
                     | while "(" Expression<withIn> ")" Statement           -- whileDo
                     | for "(" Expression<noIn>? ";"
                                 Expression<withIn>? ";"
                                 Expression<withIn>? ")" Statement          -- for3
                     | for "(" var VariableDeclarationList<noIn> ";"
                                 Expression<withIn>? ";"
                                 Expression<withIn>? ")" Statement          -- for3var
                     | for "(" LeftHandSideExpression in
                                 Expression<withIn> ")" Statement           -- forIn
                     | for "(" var VariableDeclaration<noIn> in
                                 Expression<withIn> ")" Statement           -- forInVar

  ContinueStatement = continue (spacesNoNL identifier)? sc

  BreakStatement = break (spacesNoNL identifier)? sc

  ReturnStatement = return (spacesNoNL ~space Expression<withIn>)? sc

  WithStatement = with "(" Expression<withIn> ")" Statement

  SwitchStatement = switch "(" Expression<withIn> ")" CaseBlock

  CaseBlock = "{" CaseClause* DefaultClause CaseClause* "}"  -- withDefault
            | "{"                           CaseClause* "}"  -- withoutDefault

  CaseClause = case Expression<withIn> ":" Statement*

  DefaultClause = default ":" Statement*

  LabelledStatement = identifier ":" Statement

  ThrowStatement = throw Expression<withIn> sc  -- throwExpr

  TryStatement = try Block Catch Finally  -- tryCatchFinally
               | try Block Finally        -- tryFinally
               | try Block Catch          -- tryCatch

  Catch = catch "(" FormalParameter ")" Block

  Finally = finally Block

  DebuggerStatement = debugger sc

  FunctionDeclaration
    = function identifier "(" FormalParameterList ")" "{" FunctionBody "}"

  FunctionExpression
    = function identifier "(" FormalParameterList ")" "{" FunctionBody "}"  -- named
    | function "(" FormalParameterList ")" "{" FunctionBody "}"             -- anonymous

  FormalParameterList = ListOf<FormalParameter, ",">

  FormalParameter = identifier

  FunctionBody = &(Directive*) SourceElement*

  SourceElement = Declaration | Statement

  Declaration = FunctionDeclaration

  Directive = stringLiteral sc
}';
		yourself
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarQL [
	" https://github.com/cwi-swat/kogi/blob/master/src/kogi/demo/ql/Syntax.rsc "

	^ SBGrammarSimplify new
		postDo: [:g |
			SBToggledCode
				comment: ''
				active: 1
				do: {[(g ruleNamed: 'Question') setProperty: #kogiOutput toValue: 'input_statement']}];
		grammar: 'G <: BuiltInRules {
Form = "form" id "{" Question* "}"

qType
  = "boolean" 
  | "string" 
  | "integer"
  | "money"


Question
  = Label id ":" qType
  | Label id ":" qType "=" Expr
  | "if" "(" Expr ")" Question ()
  | "if" "(" Expr ")" Question "else" Question
  | "{" Question* "}"

Expr
  = id
  | integerValue
  | stringValue
  | floatValue
  | "true"
  | "false"
  | "(" Expr ")"
  | "!" Expr
  | Expr "*" Expr
  | Expr "/" Expr
  | Expr "+" Expr
  | Expr "-" Expr
  | Expr "<" Expr
  | Expr "<=" Expr
  | Expr ">" Expr
  | Expr ">=" Expr
  | Expr "==" Expr
  | Expr "!=" Expr
  | Expr "&&" Expr
  | Expr "||" Expr

Label = stringValue
id = letter+
floatValue = digit+ ("." digit+)?
integerValue = digit+
stringValue = letter+
}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarRascalJava18 [
	" heavily modified and broken to suit our limited needs "

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'G <: BuiltInRules {
/*
@license{
  Copyright (c) 2009-2015 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Rodrigo Bonifacio - rbonifacio@unb.br - CIC/UnB}
@doc{
This Java grammar is based on the following references:

* https://docs.oracle.com/javase/specs/jls/se8/html/jls-19.html
* https://github.com/antlr/grammars-v4/blob/master/java8/Java8.g4
* Rascal Java15 grammar

.Benefits

* the grammar is well-annotated with the source information

.Pitfalls

* the grammar contains too many non-terminals for the expression sub-language (priorities and associativities
are still encoded with non-terminals)
* same for the Statements; too many non-terminals for handy use with concrete-syntax patterns
* the grammar is not well tested
} 

module lang::java::\syntax::Java18
*/

CompilationUnit = PackageDeclaration? Imports TypeDeclaration*

Literal = integerLiteral
  			   | floatingPointLiteral
  			   | booleanLiteral
  			   | characterLiteral
  			   | stringLiteral
  			   | nullLiteral
  		
Imports = ImportDeclaration*

Type = PrimitiveType
             | ReferenceType
 
PrimitiveType = Annotation* NumericType
                      | Annotation* "boolean" 

NumericType = IntegralType
                    | FloatingPointType

IntegralType = "byte" 
                    | "short" 
                    | "int" 
                    | "long" 
                    | "char"

FloatingPointType = "float" | "double"

ReferenceType = ClassOrInterfaceType 
                     | ArrayType

ClassOrInterfaceType = ClassType 
                                          
ClassType = Annotation* Identifier TypeArguments? 
                 | ClassOrInterfaceType "." Annotation* Identifier TypeArguments?

InterfaceType = ClassType

TypeVariable = Annotation* Identifier

ArrayType = PrimitiveType Dims 
                 | ClassOrInterfaceType Dims 

Dims = Annotation* "[" "]" (Annotation* "[" "]")*

TypeParameter = TypeParameterModifier* Identifier TypeBound?

TypeParameterModifier = Annotation

TypeBound = "extends" (ClassOrInterfaceType "&")+
                 
AdditionalBound = "&" InterfaceType


TypeArguments = "<"  (TypeArgument ",")* ">"

TypeArgument = ReferenceType 
                    | Wildcard

Wildcard = Annotation* "?" WildcardBounds?

WildcardBounds = "extends" ReferenceType
	                  |	"super" ReferenceType

TypeName = Identifier
                | PackageOrTypeName "." Identifier

PackageOrTypeName = Identifier 
                         | PackageOrTypeName "." Identifier
ExpressionName = Identifier 
                      | AmbiguousName "." Identifier                        
                     
MethodName = Identifier

PackageName = Identifier 
                   | PackageName "." Identifier
                   
AmbiguousName = Identifier 
                     | AmbiguousName "." Identifier

PackageDeclaration = PackageModifier* "package" (Identifier ".")+ ";"

PackageModifier = Annotation

ImportDeclaration = SingleTypeImportDeclaration
                         | TypeImportOnDemandDeclaration
                         | SingleStaticImportDeclaration
                         | StaticImportOnDemandDeclaration
 
SingleTypeImportDeclaration = "import" TypeName ";"+

TypeImportOnDemandDeclaration = "import" PackageOrTypeName "." "*" ";"+

SingleStaticImportDeclaration = "import" "static" TypeName "." Identifier ";"+

StaticImportOnDemandDeclaration = "import" "static" TypeName "." "*" ";"+


TypeDeclaration = ClassDeclaration ";"*
                       | InterfaceDeclaration ";"* 

ClassDeclaration = NormalClassDeclaration
                        | EnumDeclaration 
                        
NormalClassDeclaration = ClassModifier* "class" Identifier TypeParameters? Superclass? Superinterfaces? ClassBody

ClassModifier = Annotation 
                     | "public" 
                     | "protected" 
                     | "private" 
                     | "abstract" 
                     | "static" 
                     | "final" 
                     | "strictfp"

TypeParameters = "<" (TypeParameter ",")+ ">"

Superclass = "extends" ClassType

Superinterfaces = "implements" (InterfaceType ",")+

ClassBody = "{" ClassBodyDeclaration* "}" ";"?

ClassBodyDeclaration = ClassMemberDeclaration 
                            | InstanceInitializer 
                            | StaticInitializer 
                            | ConstructorDeclaration 

ClassMemberDeclaration = FieldDeclaration 
                              | MethodDeclaration 
                              | ClassDeclaration 
                              | InterfaceDeclaration 

FieldDeclaration = FieldModifier* UnannType VariableDeclaratorList ";"+

FieldModifier = Annotation 
                     | "public" 
                     | "protected" 
                     | "private" 
                     | "static" 
                     | "final" 
                     | "transient" 
                     | "volatile"

VariableDeclaratorList = (VariableDeclarator ",")+

VariableDeclarator = VariableDeclaratorId ("=" VariableInitializer)?

VariableDeclaratorId = Identifier Dims?

VariableInitializer = Expression 
                           | ArrayInitializer

UnannType = UnannPrimitiveType 
                 | UnannReferenceType

UnannPrimitiveType = NumericType 
                          | "boolean" 

UnannReferenceType = UnannClassOrInterfaceType 
                          | UnannArrayType
                          
UnannClassOrInterfaceType = UnannClassType 
                          
UnannClassType = Identifier TypeArguments? 
                      | UnannClassOrInterfaceType "." Annotation* Identifier TypeArguments?
               
UnannInterfaceType = UnannClassType

UnannTypeVariable = Identifier

UnannArrayType = UnannPrimitiveType Dims 
               | UnannClassOrInterfaceType Dims 

MethodDeclaration = MethodModifier* MethodHeader MethodBody

MethodModifier = Annotation 
                      | "public" 
                      | "protected" 
                      | "private"
                      | "abstract" 
                      | "static" 
                      | "final" 
                      | "synchronized" 
                      | "native" 
                      | "strictfp"

MethodHeader = Result MethodDeclarator Throws?
                    |  TypeParameters Annotation* Result MethodDeclarator Throws?
                    
Result = UnannType 
              | "void" 


MethodDeclarator = Identifier "(" ")" Dims?
                        | Identifier "(" LastFormalParameter ")" Dims?
                        | Identifier "(" (FormalParameter ",")+ ("," LastFormalParameter)?")" Dims?
            
FormalParameterList = FormalParameters
                            
FormalParameters = FormalParameter ("," FormalParameters)?
                        | LastFormalParameter

FormalParameter = VariableModifier* UnannType VariableDeclaratorId

                        
LastFormalParameter = VariableModifier* UnannType Annotation* "..." VariableDeclaratorId 

ReceiverParameter = Annotation* UnannType (Identifier ".")? "this"

VariableModifier = Annotation 
                        | "final" 
              


Throws = "throws" ( ExceptionType "," )+

ExceptionType = ClassType 


MethodBody = Block ";"*
                  | ";"

InstanceInitializer = Block

StaticInitializer = "static" Block ";"*

ConstructorDeclaration = ConstructorModifier* ConstructorDeclarator Throws? ConstructorBody

ConstructorModifier = Annotation 
                           | "public" 
                           | "protected" 
                           | "private" 
                           | "strictfp"

ConstructorDeclarator = TypeParameters? SimpleTypeName "(" FormalParameterList? ")"

SimpleTypeName = Identifier

ConstructorBody = "{" ExplicitConstructorInvocation? BlockStatements? "}" ";"*

ExplicitConstructorInvocation = TypeArguments? "this" "(" ArgumentList? ")" ";"  
                                     | TypeArguments? "super" "(" ArgumentList? ")" ";" 
                                     | ExpressionName "." TypeArguments "super" "(" ArgumentList? ")" ";" 
                                     | Primary "." TypeArguments? "super" "(" ArgumentList? ")" ";"

EnumDeclaration = ClassModifier* "enum" Identifier Superinterfaces? EnumBody

EnumBody = "{" EnumConstantList? ","? EnumBodyDeclarations? "}" ";"?

EnumConstantList = ( EnumConstant "," )+

EnumConstant = EnumConstantModifier* Identifier ("(" ArgumentList? ")")? ClassBody?

EnumConstantModifier = Annotation

EnumBodyDeclarations =  ";" ClassBodyDeclaration*

InterfaceDeclaration = NormalInterfaceDeclaration 
                            | AnnotationTypeDeclaration

NormalInterfaceDeclaration = InterfaceModifier* "interface" Identifier TypeParameters? ExtendsInterfaces? InterfaceBody

InterfaceModifier = Annotation 
                         | "public" 
                         | "protected" 
                         | "private" 
                         | "abstract" 
                         | "static" 
                         | "strictfp"

ExtendsInterfaces = "extends" (InterfaceType ",")+

InterfaceBody = "{" InterfaceMemberDeclaration* "}" ";"*

InterfaceMemberDeclaration = ConstantDeclaration 
                                  | InterfaceMethodDeclaration 
                                  | ClassDeclaration 
                                  | InterfaceDeclaration 

ConstantDeclaration = ConstantModifier* UnannType VariableDeclaratorList ";"

ConstantModifier = Annotation 
                        | "public" 
                        | "static" 
                        | "final"

InterfaceMethodDeclaration = InterfaceMethodModifier* MethodHeader MethodBody ";"?

InterfaceMethodModifier = Annotation 
                               | "public" 
                               | "abstract" 
                               | "default" 
                               | "static" 
                               | "strictfp"

AnnotationTypeDeclaration = InterfaceModifier* "@" "interface" Identifier AnnotationTypeBody

AnnotationTypeBody = "{" AnnotationTypeMemberDeclaration* "}"

AnnotationTypeMemberDeclaration = AnnotationTypeElementDeclaration 
                                       | ConstantDeclaration 
                                       | ClassDeclaration 
                                       | InterfaceDeclaration 
                                       | InterfaceMethodDeclaration

AnnotationTypeElementDeclaration = AnnotationTypeElementModifier* UnannType Identifier "(" ")" Dims? DefaultValue?

AnnotationTypeElementModifier = Annotation 
                                     | "public" 
                                     | "abstract"

DefaultValue = "default" ElementValue ";"*

Annotation = NormalAnnotation 
                  | MarkerAnnotation 
                  | SingleElementAnnotation

NormalAnnotation = "@" TypeName "(" ElementValuePairList? ")"

ElementValuePairList = (ElementValuePair ",")+

ElementValuePair = Identifier "=" ElementValue

ElementValue = ConditionalExpression 
                    | ElementValueArrayInitializer 
                    | Annotation

ElementValueArrayInitializer = "{" ElementValueList? ","? "}"

ElementValueList = ( ElementValue "," )*

MarkerAnnotation = "@" TypeName

SingleElementAnnotation = "@" TypeName "(" ElementValue ")"

ArrayInitializer = "{" VariableInitializerList? ","? "}"

VariableInitializerList = (VariableInitializer ",")+

Block = "{" BlockStatements? "}"
             

BlockStatements = BlockStatement BlockStatement*

BlockStatement = LocalVariableDeclarationStatement 
                      | ClassDeclaration 
                      | Statement

LocalVariableDeclarationStatement = LocalVariableDeclaration ";"+

LocalVariableDeclaration = VariableModifier* UnannType VariableDeclaratorList

Statement = StatementWithoutTrailingSubstatement 
                 | LabeledStatement 
                 | IfThenStatement 
                 | IfThenElseStatement 
                 | WhileStatement 
                 | ForStatement

StatementNoShortIf = StatementWithoutTrailingSubstatement 
                          | LabeledStatementNoShortIf 
                          | IfThenElseStatementNoShortIf 
                          | WhileStatementNoShortIf 
                          | ForStatementNoShortIf

StatementWithoutTrailingSubstatement = Block 
                                            | EmptyStatement 
                                            | ExpressionStatement 
                                            | AssertStatement 
                                            | SwitchStatement 
                                            | DoStatement 
                                            | BreakStatement 
                                            | ContinueStatement 
                                            | ReturnStatement 
                                            | SynchronizedStatement 
                                            | ThrowStatement 
                                            | TryStatement
EmptyStatement = ";"

LabeledStatement = Identifier ":" Statement

LabeledStatementNoShortIf = Identifier ":"  StatementNoShortIf

ExpressionStatement = StatementExpression ";"

StatementExpression = Assignment 
                           | PreIncrementExpression 
                           | PreDecrementExpression 
                           | PostIncrementExpression 
                           | PostDecrementExpression 
                           | MethodInvocation 
                           | ClassInstanceCreationExpression

IfThenStatement = "if" "(" Expression ")" Statement

IfThenElseStatement = "if" "(" Expression ")" StatementNoShortIf "else" Statement

IfThenElseStatementNoShortIf = "if" "(" Expression ")" StatementNoShortIf "else" StatementNoShortIf

AssertStatement = "assert" Expression ";"   
                       | "assert" Expression ":" Expression ";" 

SwitchStatement = "switch" "(" Expression ")" SwitchBlock

SwitchBlock = "{" SwitchBlockStatementGroups SwitchLabel* "}"

SwitchBlockStatementGroups = SwitchBlockStatementGroup*

SwitchBlockStatementGroup = SwitchLabels BlockStatements

SwitchLabels = SwitchLabel+

SwitchLabel = "case" ConstantExpression ":" 
                   | "default" ":" 

EnumConstantName = Identifier

WhileStatement = "while" "(" Expression ")" Statement

WhileStatementNoShortIf = "while" "(" Expression ")" StatementNoShortIf

DoStatement = "do" Statement "while" "(" Expression ")"

ForStatement = BasicForStatement  
                    | EnhancedForStatement

ForStatementNoShortIf = BasicForStatementNoShortIf 
                             | EnhancedForStatementNoShortIf

BasicForStatement = "for" "(" ForInit? ";" Expression? ";" ForUpdate? ")" Statement

BasicForStatementNoShortIf = "for" "(" ForInit? ";" Expression? ";" ForUpdate? ")" StatementNoShortIf

ForInit = StatementExpressionList 
               | LocalVariableDeclaration

ForUpdate = StatementExpressionList
               
StatementExpressionList = (StatementExpression ",") +

EnhancedForStatement = "for" "(" VariableModifier* UnannType VariableDeclaratorId ":" Expression ")" Statement

EnhancedForStatementNoShortIf = "for" "(" VariableModifier* UnannType VariableDeclaratorId ":" Expression ")" StatementNoShortIf

BreakStatement = "break" Identifier? ";"

ContinueStatement = "continue" Identifier? ";"

ReturnStatement = "return" Expression? ";"

ThrowStatement = "throw" Expression ";"

SynchronizedStatement = "synchronized" "(" Expression ")" Block

TryStatement = "try" Block Catches 
                    | "try" Block Catches? Finally 
                    | TryWithResourcesStatement

Catches = CatchClause+

CatchClause = "catch" "(" CatchFormalParameter ")" Block

CatchFormalParameter = VariableModifier* CatchType VariableDeclaratorId

CatchType = UnannClassType ("|" ClassType)*

Finally = "finally" Block

TryWithResourcesStatement = "try" ResourceSpecification Block Catches? Finally?

ResourceSpecification = "(" ResourceList ";"? ")"

ResourceList = (Resource ";")*

Resource = VariableModifier* UnannType VariableDeclaratorId "=" Expression

Primary = PrimaryNoNewArray 
                | ArrayCreationExpression

PrimaryNoNewArray = Literal 
                          | ClassLiteral 
                          | "this" 
                          | TypeName "." "this" 
                          | "(" Expression ")" 
                          | ClassInstanceCreationExpression 
                          | FieldAccess 
                          | ArrayAccess 
                          | MethodInvocation 
                          | MethodReference               

ClassLiteral = TypeName ("[" "]")* "." "class" 
                    | NumericType ("[" "]")* "." "class" 
                    | "boolean" ("[" "]")* "." "class" 
                    | "void" "." "class"              

ClassInstanceCreationExpression = UnqualifiedClassInstanceCreationExpression 
                                       | ExpressionName "." UnqualifiedClassInstanceCreationExpression 
                                       | Primary "." UnqualifiedClassInstanceCreationExpression

UnqualifiedClassInstanceCreationExpression = "new" TypeArguments? ClassOrInterfaceTypeToInstantiate "(" ArgumentList? ")" 
                                                  | AIC

AIC = "new" TypeArguments? ClassOrInterfaceTypeToInstantiate "(" ArgumentList? ")" ClassBody

ClassOrInterfaceTypeToInstantiate = (AnnotatedType ".")* TypeArgumentsOrDiamond?

AnnotatedType = Annotation* Identifier

TypeArgumentsOrDiamond = TypeArguments  

FieldAccess = Primary "." Identifier 
                   | "super" "." Identifier 
                   | TypeName "." "super" "." Identifier

ArrayAccess = ExpressionName "[" Expression "]" 
                   | PrimaryNoNewArray "[" Expression "]" 

MethodInvocation = MethodName "(" ArgumentList? ")"  
                        | ExpressionName "." TypeArguments? Identifier "(" ArgumentList? ")" 
                        | Primary "." TypeArguments? Identifier "(" ArgumentList? ")"  
                        | "super" "." TypeArguments? Identifier "(" ArgumentList? ")"  
                        | TypeName "." "super" "." TypeArguments? Identifier "(" ArgumentList? ")" 

ArgumentList = ( Expression "," )+

MethodReference = ExpressionName "::" TypeArguments? Identifier 
                       | Primary "::" TypeArguments? Identifier 
                       | "super" "::" TypeArguments? Identifier 
                       | TypeName "." "super" "::" TypeArguments? Identifier 
                       | ClassType "::" TypeArguments? "new" 
                       | ArrayType "::" "new"

ArrayCreationExpression = "new" PrimitiveType DimExprs Dims? 
                               | "new" ClassOrInterfaceType DimExprs Dims? 
                               | "new" PrimitiveType Dims ArrayInitializer 
                               | "new" ClassOrInterfaceType Dims ArrayInitializer

DimExprs = DimExpr+

DimExpr = Annotation* "[" Expression "]"

Expression = LambdaExpression 
                  | AssignmentExpression

LambdaExpression = LambdaParameters "->" LambdaBody

LambdaParameters = Identifier 
                        | "(" FormalParameterList? ")"
                        | "(" InferredFormalParameterList ")" 

InferredFormalParameterList = ( Identifier "," )+

LambdaBody = Expression 
                  | Block

AssignmentExpression = ConditionalExpression 
                            | Assignment

Assignment = LeftHandSide AssignmentOperator Expression

LeftHandSide = ExpressionName 
                    | FieldAccess 
                    | ArrayAccess

AssignmentOperator = "=" 
                          | "*="  
                          | "/="  
                          | "%="  
                          | "+="  
                          | "-="  
                          | "<<="  
                          | ">>="  
                          | ">>>="  
                          | "&="
                          | "^="  
                          | "|=" 

ConditionalExpression = ConditionalOrExpression 
                             | ConditionalOrExpression "?" Expression ":" ConditionalExpression 
                             | ConditionalOrExpression "?" Expression ":" LambdaExpression

ConditionalOrExpression = ConditionalAndExpression 
                               | ConditionalOrExpression "||" ConditionalAndExpression                              

ConditionalAndExpression = InclusiveOrExpression 
                                | ConditionalAndExpression "&&" InclusiveOrExpression

InclusiveOrExpression = ExclusiveOrExpression 
                             | InclusiveOrExpression "|" ExclusiveOrExpression

ExclusiveOrExpression = AndExpression 
                      | ExclusiveOrExpression "^" AndExpression

AndExpression = EqualityExpression 
                     | AndExpression "&" EqualityExpression

EqualityExpression = RelationalExpression 
                          | EqualityExpression "==" RelationalExpression 
                          | EqualityExpression "!=" RelationalExpression

RelationalExpression = ShiftExpression 
                            | RelationalExpression "<" ShiftExpression 
                            | RelationalExpression ">" ShiftExpression 
                            | RelationalExpression "<=" ShiftExpression 
                            | RelationalExpression ">=" ShiftExpression 
                            | RelationalExpression "instanceof" ReferenceType

ShiftExpression = AdditiveExpression 
                       | ShiftExpression "<<" AdditiveExpression 
                       | ShiftExpression ">>" AdditiveExpression 
                       | ShiftExpression ">>>" AdditiveExpression

AdditiveExpression = MultiplicativeExpression 
                          | AdditiveExpression "+" ~"+" MultiplicativeExpression 
                          | AdditiveExpression "-" ~"-" MultiplicativeExpression
                          
MultiplicativeExpression = UnaryExpression 
                                | MultiplicativeExpression "*" UnaryExpression 
                                | MultiplicativeExpression "/" UnaryExpression 
                                | MultiplicativeExpression "%" UnaryExpression

UnaryExpression = PreIncrementExpression 
                       | PreDecrementExpression 
                       | "+" ~"+" UnaryExpression 
                       | "-" ~"-" UnaryExpression 
                       | UnaryExpressionNotPlusMinus

PreIncrementExpression = "++" UnaryExpression

PreDecrementExpression = "--" UnaryExpression

UnaryExpressionNotPlusMinus = PostfixExpression 
                                   | "~" UnaryExpression 
                                   | "!" UnaryExpression 
                                   | CastExpression                                

PostfixExpression = Primary 
                         | ExpressionName 
                         | PostIncrementExpression 
                         | PostDecrementExpression                                   

PostIncrementExpression = PostfixExpression "++"

PostDecrementExpression = PostfixExpression "--"

CastExpression = "(" PrimitiveType ")" UnaryExpression 
                      | "(" ReferenceType AdditionalBound* ")" UnaryExpressionNotPlusMinus 
                      | "(" ReferenceType AdditionalBound* ")" LambdaExpression
ConstantExpression = Expression

signedInteger = "-"? digit+
  
floatingPointLiteral = digit+

integerLiteral = digit+

id = ("$" | "_" | letter) ("$" | "_" | letter | digit)*

Identifier = ("$" | "_" | letter) ("$" | "_" | letter | digit)*
  
booleanLiteral
  = "false" 
  | "true" 

characterLiteral = "''" letter "''"
  
stringLiteral = "\"" letter* "\""

nullLiteral = "null"

}';
		yourself
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarRascalJavascript [
	" heavily modified and broken to suit our limited needs "

	^ SBGrammarSimplify new
		preDo: [:grammar |
			grammar allBlocksDo: [:b | (b isIdentifier and: [b contents = 'VariableDeclarationNoIn']) ifTrue: [b contents: 'VariableDeclaration']].
			(grammar ruleNamed: 'VariableDeclarationNoIn') delete];
		postDo: [:grammar |
			(grammar ruleNamed: 'Statement')
				setProperty: #kogiOutput
				toValue: 'input_statement'.
			SBToggledCode comment: '' active: 1 do: {
				[
					(grammar ruleNamed: 'VariableDeclaration') expression childSandblocks first
						setProperty: #preferredChoice
							toValue: true;
						setProperty: #inline
							toValue: false]}];
		grammar: 'G <: BuiltInRules {
	/*
@CachedParser{javascript.cached.SweeterJSCachedParser}
@contributor{
Tijs van der Storm - CWI (storm@cwi.nl)
}
@doc{
A saner grammar for JavaScript
It assumes:
- semicolons are present
- there is no comma expression
}
module javascript::Syntax
*/

Source 
  = Statement*

Statement 
  = VarDecl
  | ";"
  | "{" Statement* "}" 
  | Expression ";"
  
  // Block level things
  | Function
  | "if" "(" Expression ")" Statement () ~"else" 
  | "if" "(" Expression ")" Statement "else" Statement
  | "do" Statement "while" "(" Expression ")" ";"
  | "while" "(" Expression ")" Statement
  | "for" "(" (Expression ",")* ";" (Expression ",")* ";" (Expression ",")* ")" Statement
  | "for" "(" "var" (VariableDeclarationNoIn ",")+ ";" (Expression ",")* ";" (Expression ",")* ")" Statement  
  | "for" "(" Expression "in" Expression ")" Statement
  | "for" "(" "var" id "in" Expression ")" Statement
  | "with" "(" Expression ")" Statement
  
  | "return"  Expression ";"
  | "return" ";"
  | "throw" Expression ";"
  | "throw" ";"
  | "continue" id ";"
  | "continue" ";"
  | "break" id ";"
  | "break" ";"
  | "debugger" ";"
  | id ":" Statement
 
  | "switch" "(" Expression ")" "{" CaseClause* "}"
  | "try" Statement "catch" "(" id ")" Statement
  | "try" Statement "finally" Statement
  | "try" Statement "catch" "(" id ")" Statement "finally" Statement

VariableDeclaration 
  = id "=" Expression
  | id

VariableDeclarationNoIn
  = id "=" Expression
  | id


CaseClause 
  = "case" id ":" Statement*
  | "default" ":" Statement*
   
Function
  = "function" id "(" (id ",")* ")" "{" Statement* "}"
  | "function" "(" (id ",")* ")" "{" Statement* "}"

Expression
  = "[" (Expression ",")*  ","? "]"
  | "{" (PropertyAssignment ",")* ","? "}"
  | "this"
  | id 
  | literal
  | "(" Expression ")" 
  | Function
  | Expression "." id 
  | Expression "(" (Expression ",")* ")" 
  | Expression "[" Expression "]" 
  | "new" Expression
  | Expression "++"
  | Expression "--"
  | "delete" Expression
  | "typeof" Expression
  | "++" Expression
  | "--" Expression
  | "+" ~"=" Expression
  | "-" ~"=" Expression
  | "~" Expression
  | "!" ~"=" Expression
  | Expression "*" ~"=" Expression
  | Expression "/" ~"=" Expression
  | Expression "%" ~"=" Expression
  | Expression "+" ~"=" Expression
  | Expression "-" ~"=" Expression
  | Expression "<<" Expression
  | Expression ">>" ~">" Expression
  | Expression ">>>" Expression
  | Expression "<" Expression
  | Expression "<=" Expression
  | Expression ">" Expression
  | Expression ">=" Expression
  | Expression "instanceof" Expression
  | Expression "in" Expression
  | Expression "===" Expression
  | Expression "!==" Expression
  | Expression "==" ~"=" Expression 
  | Expression "!=" ~"=" Expression
  | Expression "&" ~"=" Expression
  | Expression "^" ~"=" Expression
  | Expression "|" ~"=" Expression
  | Expression "&&" Expression
  | Expression "||" Expression
  | Expression "?" Expression ":" Expression
  | Expression "=" ~"=" Expression
  | Expression "*=" Expression
  | Expression "/=" Expression
  | Expression "%=" Expression
  | Expression "+=" Expression
  | Expression "-=" Expression
  | Expression "<<=" Expression
  | Expression ">>=" Expression
  | Expression ">>>=" Expression
  | Expression "&=" Expression
  | Expression "^=" Expression
  | Expression "|=" Expression
  
  
VarDecl
  = "var" (VariableDeclaration ",")+ ";"
  | "let" (VariableDeclaration ",")+ ";"
  | "const" (VariableDeclaration ",")+ ";"
  
propertyName
 = id
 | string
 | numeric

PropertyAssignment
  = propertyName ":" Expression
  | "get" propertyName "(" ")" "{" Statement* "}"
  | "set" propertyName "(" id ")" "{" Statement* "}"


literal
 = "null"
 | boolean
 | numeric
 | string
 | regularExpression

boolean
  = "true"
  | "false"

numeric
  = digit+

string
  = "\"" letter* "\""
  | "''" letter* "''"

regularExpression
  = "/" regularExpressionBody "/" regularExpressionFlags

regularExpressionBody
  = regularExpressionFirstChar regularExpressionChar*

regularExpressionFirstChar
  = regularExpressionBackslashSequence
  | regularExpressionClass

regularExpressionChar
  = letter+

regularExpressionBackslashSequence
  = "\""+

regularExpressionClass
  = letter+

regularExpressionClassChar
  = letter+

regularExpressionFlags
  = letter*

id
  = (letter | "_" | "$") (letter | digit | "_" | "$")
}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarSimpleSmalltalk [

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'G <: BuiltInRules {
Statements = Temporaries? (Expr ".")* Expr?

Expr = Assignment

Assignment = identifier ":=" Assignment | BinaryMessageSend

BinaryMessageSend = BinaryMessageSend binaryOp UnaryMessageSend ~";" | UnaryMessageSend

UnaryMessageSend = UnaryMessageSend identifier ~":" ~";" | Literal

Literal = "(" Expr ")" | Block | Array | literal

Array = "{" (Expr ".")* Expr? "}"

Block = "[" ((":" identifier)+ "|")? Statements "]"

Temporaries = "|" identifier* "|"

binaryOp = specialChar

specialChar = "+" | "-" | "*" | "%" | ">" | "<" | ","

literal = number | identifier | symbol

number = digit+

identifier = letter (letter | digit)*

symbol = "#" identifier}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarSonificationBlocks [
	" https://github.com/cwi-swat/kogi/blob/simplification/src/kogi/demo/sonification/Syntax.rsc "

	^ SBGrammarSimplify new
		grammar: 'G <: BuiltInRules {

Program
  = "run program" Connection*

Connection
  = SoundConnection
  | ControllingParameters
  | PassingTime

ControllingParameters
  = "set parameters" id "of sound" SoundSource "to be" ToBe

ToBe
  = SoundSource
  | DataProcessing
  | integerValue

DataProcessing
  = "data source" DataSource "processed with" DataProcessing* "then scaled to" DataProcessing
  | DataProcessor "image"
  | "range" integerValue "to" integerValue

DataProcessor
  = "reverse"
  | "do_nothing"
  | "slow_ramp"
  | "medium_ramp"
  | "fast_ramp"
  | "hard_cutoff"
  | "hump"
  | "rotate"

PassingTime
  = "wait" integerValue "seconds"

SoundConnection
  = "connect" SoundSource "to" DataSource

SoundSource
  = Wave "wave" imageValue "(spectrum:" imageValue ")" "named" id
  | Filter "filter" " (spectrum:" imageValue ")" "named" id

Filter
  = "lowpass"
  | "highpass"
  | "bandpass"

Wave
  = "sine"
  | "triangle"
  | "square"
  | "sawtooth"

DataSource
  = "speaker"
  | "slider_with_label" id
  | "device position along" id "axis"
  | "device movement along" id "axis"
  | "device rotation along" id "axis"
  
integerValue
 = digit+

id = letter+

imageValue 
  = "\"" letter+ "\""
}';
		yourself
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarStatemachine [
	" heavily modified and broken to suit our limited needs "

	^ SBGrammarSimplify new
		grammar: 'G <: BuiltInRules {
Machine = "machine" id State*

State 	= "state" id "{" Trans* "}"

Trans = "on" id "to" id

id = letter+

}'
]

{ #category : #'example grammars' }
SBGrammarTransformer class >> grammarTinyJava [
	" https://cs.lmu.edu/~ray/notes/ohmexamples/ "

	^ SBGrammarSimplify new
		isOhm: true;
		grammar: 'G <: BuiltInRules {
Program = Stmt+

Stmt
	 = Dec
	| Assignment ";"
	| Call ";"
	| break ";"
	| return Exp? ";"
	| print Args ";"
	| if Exp Block (else if Exp Block)* (else Block)?
	| while Exp Block
	| for "(" (Type id "=" Exp)? ";" Exp? ";" Assignment? ")" Block

Assignment
	 = Increment
	| Var "=" Exp

Increment
	 = incop Var
	| Var incop

Dec
	 = TypeDec
	| VarDec
	| FunDec

TypeDec = struct id "{" (Type id ";")* "}"

TypeArray = Type "[" "]"
Type
	 = TypeArray
	| primtype
	| id

VarDec = Type id ("=" Exp)? ";"

FunDec = (Type | void) id "(" Params ")" Block

Params = (Type id ("," Type id)*)?

Block = "{" Stmt* "}"

Exp = Exp1 ("||" Exp1)*

Exp1 = Exp2 ("&&" Exp2)*

Exp2 = Exp3 ("|" Exp3)*

Exp3 = Exp4 ("^" Exp4)*

Exp4 = Exp5 ("&" Exp5)*

Exp5 = Exp6 (relop Exp6)?

Exp6 = Exp7 (shiftop Exp7)*

Exp7 = Exp8 (addop Exp8)*

Exp8 = Exp9 (mulop Exp9)*

Exp9 = prefixop? Exp10

Exp10
	 = Literal
	| Increment
	| Var
	| NewObject
	| NewArray
	| EmptyArray
	| "(" Exp ")"

Literal
	 = nl
	| tr
	| fs
	| floatlit
	| intlit
	| charlit
	| stringlit

Var
	 = Var "[" Exp "]"
	| Var "." id
	| Call
	| id

NewObject = new id "{" Args "}"

NewArray = new TypeArray "{" Args "}"

EmptyArray = new Type "[" Exp "]"

Call = id "(" Args ")"

Args = (Exp ",")* Exp?

boolean = "boolean" ~idchar

break = "break" ~idchar

char = "char" ~idchar

else = "else" ~idchar

fs = "false" ~idchar

for = "for" ~idchar

if = "if" ~idchar

int = "int" ~idchar

length = "length" ~idchar

new = "new" ~idchar

nl = "null" ~idchar

print = "print" ~idchar

real = "real" ~idchar

return = "return" ~idchar

string = "string" ~idchar

return = "return" ~idchar

struct = "struct" ~idchar

tr = "true" ~idchar

void = "void" ~idchar

while = "while" ~idchar

keyword
	 = boolean
	| if
	| break
	| else
	| int
	| for
	| new
	| return
	| char
	| struct
	| nl
	| while
	| real
	| tr
	| string
	| void
	| fs
	| length
	| print

id = ~keyword letter idchar*

idchar
	 = "_"
	| alnum

intlit = digit+

floatlit = digit+ "." digit+ (("E" | "e") ("+" | "-")? digit+)?

char
	 = escape
	| ~"\\" ~"\"" ~"''" ~"\n" any

h = hexDigit

escape
	 = "\\\\"
	| "\\\""
	| "\\''"
	| "\\n"
	| "\\t"
	| hexseq

hexseq = "\\" h h? h? h? h? h? h? h? ";"

charlit = "''" (char | "\"") "''"

stringlit = "\"" (char | "\''")* "\""

addop
	 = "+"
	| "-"

relop
	 = "<="
	| "<"
	| "=="
	| "!="
	| ">="
	| ">"

shiftop
	 = "<<"
	| ">>"

mulop
	 = "*"
	| "/"
	| "%"

prefixop
	 = ~"--" "-"
	| "!"
	| "~"
	| char
	| int
	| string
	| length

incop
	 = "++"
	| "--"

primtype
	 = boolean
	| char
	| int
	| real
	| string

space
	 = "\x20"
	| "\x09"
	| "\x0A"
	| "\x0D"
	| comment

comment = "//" (~"\n" any)* "\n"}'
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> inputTypeFor: aPart on: aStream [

	aPart
		allBlocksDetect: [:part | part isRepeatQuantifier and: [part expression allBlocksDetect: [:b | b isIdentifier and: [b isSimple not]] ifFound: [:b | true] ifNone: [false]]]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendStatementInput("NAME")']
		ifNone: [].
	aPart
		allBlocksDetect: [:part | part isIdentifier and: [part isPrimitive not]]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendValueInput("NAME")']
		ifNone: [].
	
	aStream nextPutAll: 'this.appendDummyInput("NAME")'
]

{ #category : #'transform helper' }
SBGrammarTransformer class >> isTerminal: aBlock in: aGrammar [

	| isTerminal |
	isTerminal := [:b | b isTerminal or: [b isAlternative and: [b childSandblocks allSatisfy: #isTerminal]]].
	^ (isTerminal value: aBlock) or: [(aBlock isIdentifier and: [aBlock isSimple not]) and: [isTerminal value: (aGrammar ruleNamed: aBlock contents) expression]]
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> jsFieldToggle [

	^ '// https://github.com/google/blockly-samples/blob/master/plugins/block-plus-minus/src/field_minus.js
const minusImage =    ''data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAw'' +    ''MC9zdmciIHZlcnNpb249IjEuMSIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48cGF0aCBkPS'' +    ''JNMTggMTFoLTEyYy0xLjEwNCAwLTIgLjg5Ni0yIDJzLjg5NiAyIDIgMmgxMmMxLjEwNCAw'' +
    ''IDItLjg5NiAyLTJzLS44OTYtMi0yLTJ6IiBmaWxsPSJ3aGl0ZSIgLz48L3N2Zz4K'';

// https://github.com/google/blockly-samples/blob/master/plugins/block-plus-minus/src/field_plus.js
const plusImage =    ''data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC'' +    ''9zdmciIHZlcnNpb249IjEuMSIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48cGF0aCBkPSJNMT'' +    ''ggMTBoLTR2LTRjMC0xLjEwNC0uODk2LTItMi0ycy0yIC44OTYtMiAybC4wNzEgNGgtNC4wNz'' +    ''FjLTEuMTA0IDAtMiAuODk2LTIgMnMuODk2IDIgMiAybDQuMDcxLS4wNzEtLjA3MSA0LjA3MW'' +    ''MwIDEuMTA0Ljg5NiAyIDIgMnMyLS44OTYgMi0ydi00LjA3MWw0IC4wNzFjMS4xMDQgMCAyLS'' +
    ''44OTYgMi0ycy0uODk2LTItMi0yeiIgZmlsbD0id2hpdGUiIC8+PC9zdmc+Cg=='';

const FieldToggle = function(message, args, min, max, opt_validator) {
  FieldToggle.superClass_.constructor.call(this, plusImage, 15, 15, undefined, function(field) {
    const block = field.getSourceBlock();
    if (block.isInFlyout) {
      return;
    }

    Blockly.Events.setGroup(true);
	const oldMutation = Blockly.Xml.domToText(block.mutationToDom());
    block.add(message, args, min, max, field.getParentInput(), field);
    const newMutation = Blockly.Xml.domToText(block.mutationToDom());



    if (oldMutation != newMutation) {

      Blockly.Events.fire(new Blockly.Events.BlockChange(

          block, ''mutation'', null, oldMutation, newMutation));

    }

    Blockly.Events.setGroup(false);

  });

};



FieldToggle.fromJson = function(options) {

  var message = Blockly.utils.replaceMessageReferences(options[''message'']);

  var args = Blockly.utils.replaceMessageReferences(options[''args'']);

  var min = Blockly.utils.replaceMessageReferences(options[''min'']);

  var max = Blockly.utils.replaceMessageReferences(options[''max'']);

  return new FieldToggle(message, args, min, max);

};



Blockly.fieldRegistry.register(''field_toggle'', FieldToggle);

Blockly.utils.object.inherits(FieldToggle, Blockly.FieldImage);



Blockly.Extensions.registerMutator(''optional_mutator'', {

  props: {},



  mutationToDom: function() {

    const container = Blockly.utils.xml.createElement(''mutation'');

    container.setAttribute(''props'', JSON.stringify(this.props));

    return container;

  },

  domToMutation: function(xmlElement) {

    this.props = JSON.parse(xmlElement.getAttribute(''props'')) || {};

    for (const name in this.props) {

      const props = this.props[name];

      const count = props.count;

      props.count = 0;

      this.setCount(props.referenceFieldName, count, props.message, props.args, props.blockBeforeName, props.min, props.max);

      props.count = count;

    }

  },

  add: function(message, args, min, max, insertAfter, referenceField) {

    let props = this.props[referenceField.name];

    if (!props) {

      props = this.props[referenceField.name] = {

        count: 0,

        referenceFieldName: referenceField.name,

        blockBeforeName: insertAfter.name,

        message,

        args,

        min,

        max,

      };

    }



    if (props.count >= max)

      return;

    this.setCount(referenceField.name, props.count + 1, message, args, insertAfter.name, min, max);

    props.count++;

    this.render();

  },

  remove: function(message, args, min, max, insertAfter, referenceField) {

    const props = this.props[referenceField.name];

    if (props.count < 1)

      return;

    this.setCount(referenceField.name, props.count - 1, message, args, insertAfter.name, min, max);

    props.count--;

    this.render();

  },

  setCount: function(blockName, count, message, args, blockBeforeName, min, max) {

    const current = this.props[blockName].count;

    const repeat = count - current;

    const referenceField = this.getField(this.props[blockName].referenceFieldName);

    const insertAfter = this.getInput(blockBeforeName);



    if (repeat > 0) {

      for (let i = 0; i < repeat; i++) {

        const currentElements = [...this.inputList];

        this.interpolate_(message, args.map(arg => ({...arg, name: arg.name + ''_'' + (current + i)})));

        const newElements = this.inputList.filter(i => !currentElements.includes(i));

        let index = this.inputList.findIndex(i => i.name === blockBeforeName) + 1;

        for (const newEl of newElements) {

          newEl.name ||= ''GENERATED_'' + blockName + ''_'' + (current + i);

          this.moveNumberedInputBefore(this.inputList.indexOf(newEl), index);

        }

      }



      if (count === max) {

        referenceField.setVisible(false);

      }



      if (current === 0) {

        let self = this;

        const field = new Blockly.FieldImage(minusImage, 15, 15, undefined, function(field) {

          self.remove(message, args, min, max, insertAfter, referenceField);

        });

        insertAfter.insertFieldAt(insertAfter.fieldRow.indexOf(referenceField), field, ''REMOVE_'' + referenceField.name);

      }

    } else if (repeat < 0) {

      // const last = inputList.reversed().find(input => input.name.startsWith(blockName + ''_''));

      for (let i = 0; i < -repeat; i++) {

        for (const arg of [...args, {name: ''GENERATED''}]) {

          const name = arg.name + ''_'' + (current - 1 - i)

          if (this.inputList.find(i => i.name === name)) {

            this.removeInput(name);

          }

        }

      }

      referenceField.setVisible(true);

      if (count <= 0) {

        insertAfter.removeField(''REMOVE_'' + referenceField.name);

      }

    }

  },

}, function() { false && this.initShape(false); });'
]

{ #category : #'instance creation' }
SBGrammarTransformer class >> matchSpecific: aBlock [

	^ aBlock pragmas anySatisfy: [:p | p selector = 'grammarTransformer']
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> matchTerminalsOf: a and: b differenceDo: aBlock noMatch: aFailBlock [

	| ab bb origLookup processBlock |
	" iterate over blocks and find if they only differ in literals "
	origLookup := Dictionary new.
	processBlock := [:block :stream |
		" if we encounter an alternative of terminals, we replace it with a temporary single terminal for easier processing "
		(block isTerminalish and: [block isAlternative])
			ifTrue: [ | merged |
				merged := SBOhmTerminal new contents: ((block childSandblocks collect: #contents) joinSeparatedBy: ',').
				origLookup at: merged put: block.
				stream nextPut: merged]
			ifFalse: [(block parentSandblock isTerminalish not or: [a = block]) ifTrue: [stream nextPut: block]]].
	
	ab := Array streamContents: [:s | a allBlocksDo: [:block | processBlock value: block value: s]].
	bb := Array streamContents: [:s | b allBlocksDo: [:block | processBlock value: block value: s]].
	
	ab size ~= bb size ifTrue: [^ aFailBlock value].
	ab
		with: bb
		do: [:blockA :blockB | (blockA class ~= blockB class or: [blockA contents ~= blockB contents and: [blockA isTerminal not]]) ifTrue: [^ aFailBlock value]].
	
	ab with: bb do: [:blockA :blockB |
		((blockA isTerminalish and: [blockB isTerminalish]) and: [blockA contents ~= blockB contents]) ifTrue: [
			^ aBlock
				value: (origLookup at: blockA ifAbsent: [blockA])
				value: (origLookup at: blockB ifAbsent: [blockB])]].
	
	^ aFailBlock value
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeBinaryOperators: g [

	| operators isBinaryOp |
	" replace binary ops"
	isBinaryOp := [:b | b childSandblocks size = 3 and: [b childSandblocks first isIdentifier and: [b childSandblocks last isIdentifier and: [(b childSandblocks second isTerminal or: [b childSandblocks second isAlternative and: [b childSandblocks second childSandblocks allSatisfy: #isTerminal]]) and: [b childSandblocks first contents = b childSandblocks last contents]]]]].
	g childSandblocksDo: [:b |
		operators := OrderedCollection new.
		b expression isAlternative ifTrue: [b expression childSandblocksDo: [:expr | (isBinaryOp value: expr) ifTrue: [operators add: expr]]].
		" TODO: ensure lhs and rhs require same identifier "
		operators size > 1 ifTrue: [ | opList |
			opList := operators first childSandblocks second in: [:alt |
				alt isAlternative ifTrue: [alt] ifFalse: [ | repr |
					repr := SBOhmList new.
					alt replaceBy: repr.
					repr connect: 'OR' expressions: {alt}.
					repr]].
			operators allButFirstDo: [:op |
				operators first childSandblocks second addMorphBack: op childSandblocks second.
				op delete]]].
	g mergeRedundantGroups
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeConsecutiveLabels: g [

	| toDelete |
	" merge consecutive labels "
	g childSandblocks copy do: [:r | r expression ifNil: [r delete]].
	toDelete := OrderedCollection new.
	g allBlocksDo: [:el | | next |
		next := el.
		(el isTerminal and: [el parentSandblock isSequence]) ifTrue: [
			[
				next := next adjacentBlock: 1.
				next notNil and: [next isTerminal]] whileTrue: [
				el contents: el contents, ((((el contents last isLetter and: [next contents first isLetter]) or: [true])
					ifTrue: [' ']
					ifFalse: ['']), next contents).
				toDelete add: next]]].
	toDelete do: #delete.
	g mergeRedundantGroups
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeGlobalBinaryOperators: g [

	| operators ruleName |
	" replace binary ops"
	ruleName := 'GENbinaryOpGEN'.
	operators := OrderedCollection new.
	g allBlocksDo: [:b |
		(b isSequence and: [b childSandblocks size = 3 and: [b childSandblocks first isIdentifier and: [b childSandblocks last isIdentifier and: [b childSandblocks second isTerminal or: [b childSandblocks second isAlternative and: [b childSandblocks second childSandblocks allSatisfy: #isTerminal]]]]]]) ifTrue: [
			b replaceBy: (SBOhmIdentifier new contents: ruleName).
			operators add: b]].
	operators ifNotEmpty: [
		g addMorphBack: (SBOhmRule new name: ruleName alternatives: (SBOhmList new connect: 'AND' expressions: {
			SBOhmIdentifier new contents: ruleName.
			SBOhmList new connect: 'OR' expressions: (operators collect: [:o | o childSandblocks second]).
			SBOhmIdentifier new contents: ruleName}))].
	g mergeRedundantGroups
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeIdenticalAroundLiteral: g [
	" merge alternatives that only differ in their literals "

	(g childSandblocks select: [:b | b expression isAlternative]) do: [:b | | patterns |
		patterns := OrderedCollection new.
		b expression childSandblocksDo: [:expr | self findPatternFor: expr in: patterns].
		
		Transcript showln: patterns.
		patterns do: [:group |
			group size > 1 ifTrue: [ | literalsList |
				literalsList := self
					matchTerminalsOf: group first
					and: group second
					differenceDo: [:lit1 :lit2 |
						" we keep the block around lit1, so make sure its literal is in an alternative"
						lit1 isAlternative ifTrue: [lit1] ifFalse: [ | repr |
							repr := SBOhmList new.
							lit1 replaceBy: repr.
							repr connect: 'OR' expressions: {lit1}.
							repr]]
					noMatch: [self assert: false].
				
				group allButFirstDo: [:op |
					self
						matchTerminalsOf: group first
						and: op
						differenceDo: [:lit1 :lit2 |
							literalsList addMorphBack: lit2.
							op ~= lit2 ifTrue: [op delete]]
						noMatch: [self assert: false].
					b mergeRedundantGroups]]]].
	
	" FIXME: special case for top-level terminals that are in an alternative, because I'm too lazy to read the code above "
	SBToggledCode comment: '' active: 1 do: {
		[
			g childSandblocksDo: [:rule |
				(rule expression isAlternative and: [rule isLexical not]) ifTrue: [ | candidates |
					candidates := rule expression childSandblocks select: [:b | b allBlocksSatisfy: [:child | child isSequence or: [child isTerminal]]].
					candidates size > 1 ifTrue: [
						candidates do: #delete.
						rule expression addMorphBack: (SBOhmList new
							connect: 'OR' expressions: candidates;
							setProperty: #pinned toValue: true;
							yourself)]]]]}.
	
	g mergeRedundantGroups
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergePrecedenceChains: g [

	| operators remaining target exprRuleNames isBinaryOp isPrefixOp targetRuleName |
	operators := OrderedCollection new.
	exprRuleNames := OrderedCollection new.
	
	isBinaryOp := [:b | b childSandblocks size = 3 and: [(b childSandblocks first isIdentifier and: [b childSandblocks first isPrimitive not]) and: [b childSandblocks last isIdentifier and: [self isTerminal: b childSandblocks second in: g]]]].
	isPrefixOp := [:b | b childSandblocks size = 2 and: [(self isTerminal: b childSandblocks first in: g) and: [b childSandblocks second isIdentifier]]].
	
	g allBlocksDo: [:b | (b isSequence and: [(isBinaryOp value: b) or: [isPrefixOp value: b]]) ifTrue: [operators add: b]].
	SBToggledCode comment: '' active: 1 do: {
		[
			operators do: [:op |
				op parentSandblock isAlternative ifTrue: [
					op parentSandblock childSandblocks do: [:c |
						(c isIdentifier and: [c isPrimitive not]) ifTrue: [ | nested |
							nested := g ruleNamed: c contents.
							c replaceBy: nested expression.
							exprRuleNames add: c contents.
							nested delete]]]]]}.
	remaining := (operators collect: #containingRule) asSet anyOne.
	exprRuleNames add: remaining name.
	target := remaining allUsages reject: [:usage | usage containingRule = remaining].
	targetRuleName := ''.
	
	SBToggledCode
		comment: 'is there a single identity rule pointing to us? inline'
		active: 1
		do: {
			[
				(target size = 1 and: [target first containingRule expression = target first])
					ifTrue: [
						target := target first.
						targetRuleName := target containingRule name.
						target replaceBy: remaining expression.
						remaining delete]
					ifFalse: [targetRuleName := remaining name]]}.
	
	g mergeRedundantGroups.
	SBToggledCode
		comment: 'do our alternatives contain a single identifier? merge, it''s probably literals'
		active: 1
		do: {
			[
				(g ruleNamed: targetRuleName) expression childSandblocks
					detect: #isIdentifier
					ifFound: [:identifier | | trailingRule |
						trailingRule := g ruleNamed: identifier contents.
						identifier replaceBy: trailingRule expression.
						exprRuleNames add: identifier contents.
						trailingRule delete]]}.
	
	SBToggledCode comment: 'now replace all occurences with the merged one' active: 1 do: {
		[g allBlocksDo: [:block | (block isIdentifier and: [exprRuleNames includes: block contents]) ifTrue: [block contents: targetRuleName]]]}
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeUpCardinalityOnlyBlocks: g [

	| candidates |
	candidates := OrderedCollection new.
	g childSandblocksDo: [:rule |
		(rule isFieldInput not and: [
			((rule expression isAlternative
				ifTrue: [rule expression childSandblocks]
				ifFalse: [{rule expression}]) allSatisfy: [:alt | alt isRepeatQuantifier or: [alt isIdentifier]]) and: [rule allUsages notEmpty]]) ifTrue: [candidates add: rule]].
	
	candidates do: [:rule | rule allUsagesDo: [:usage | usage replaceBy: rule expression veryDeepCopy]].
	candidates do: [:r | r allUsages size < 1 ifTrue: [r delete]].
	g mergeRedundantGroups
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeUpLexicalRules: g [

	| lexicalRules |
	lexicalRules := g childSandblocks select: [:rule | rule isLexical].
	lexicalRules do: [:r |
		r allUsages do: [:id | | copy |
			copy := r expression veryDeepCopy.
			id replaceBy: copy]].
	lexicalRules do: [:r | r allUsages size < 1 ifTrue: [r delete]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeUpLiteralAlternatives: g [

	| toDelete |
	" merge up alternatives that only contain literals "
	toDelete := OrderedCollection new.
	g childSandblocksDo: [:r |
		(r expression isAlternative and: [r expression childSandblocks allSatisfy: #isTerminal]) ifTrue: [
			r allUsages do: [:u | u replaceBy: r expression veryDeepCopy].
			toDelete add: r]].
	toDelete do: #delete
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeUpSimpleRules: g [

	| simpleRules |
	" merge up rules with only one non-terminal in sequences "
	simpleRules := g childSandblocks select: [:rule |
		(SBToggledCode comment: '' active: 2 do: {[false]. [rule isFieldInput not]}) and: [
			(rule allBlocksSelect: [:b | b isIdentifier]) size <= 1 and: [
				rule allUsages notEmpty and: [
					SBToggledCode comment: '' active: 1 do: {
						[(rule expression allBlocksSelect: [:b | b isAlternative not or: [rule expression childSandblocks allSatisfy: #isTerminal]]) isEmpty].
						[(rule isPrimitive not or: [rule expression isAlternative]) and: [rule expression isAlternative not or: [rule expression childSandblocks allSatisfy: #isTerminal]]]}]]]].
	simpleRules do: [:r |
		r allUsages do: [:id | | copy |
			id parentSandblock isRepeatQuantifier not ifTrue: [
				copy := r expression veryDeepCopy.
				id replaceBy: copy]]].
	simpleRules do: [:r | r allUsages size < 1 ifTrue: [r delete]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeUpUnitUses: g [

	| candidates rules |
	candidates := OrderedCollection new.
	g allBlocksDo: [:b | ((b isIdentifier and: [b isSimple not]) and: [b parentSandblock isRule or: [b parentSandblock isAlternative and: [b parentSandblock parentSandblock isRule]]]) ifTrue: [candidates add: b]].
	rules := (candidates collect: #associatedRule) asSet.
	candidates do: [:id |
		id replaceBy: id associatedRule expression veryDeepCopy].
	rules do: [:r | r allUsages size < 1 ifTrue: [r delete]].
	g mergeRedundantGroups
]

{ #category : #'instance creation' }
SBGrammarTransformer class >> newFrom: aBlock [

	| msg |
	msg := aBlock statements second expression.
	^ (super newFrom: aBlock) grammar: msg arguments first steps: msg arguments second
]

{ #category : #'transform pipelines' }
SBGrammarTransformer class >> ohmToRascal [

	^ {
		[:g | SBGrammarTransformer removeBuiltInRules: g].
		[:g | SBGrammarTransformer removeLookAheads: g].
		[:g | SBGrammarTransformer removeSpaces: g].
		[:g | SBGrammarTransformer disassemblePrecedenceLists: g].
		[:g | g mergeRedundantGroups].
		[:g | SBGrammarTransformer mergePrecedenceChains: g]}
]

{ #category : #'transform helper' }
SBGrammarTransformer class >> open: aCollection for: aGrammar [

	| original g |
	g := SBOhmGrammar fromGrammar: aGrammar.
	original := g veryDeepCopy.
	aCollection do: [:steps |
		steps do: [:step | step value: g].
		SBToggledCode
			comment: 'get a preview of each step'
			active: 0
			do: {[g veryDeepCopy openInWorld]}].
	^ self openFor: g original: original
]

{ #category : #'generate helper' }
SBGrammarTransformer class >> openFor: aGrammar original: anOriginalGrammar [

	ExternalWebBrowser openOnUrl: 'file://', (self writeFor: aGrammar original: anOriginalGrammar)
]

{ #category : #'generate helper' }
SBGrammarTransformer class >> originalRuleFor: rule in: aGrammar from: anOriginalGrammar [

	| n |
	n := rule isString ifTrue: [rule] ifFalse: [rule name].
	
	^ (n includesSubstring: 'GEN') ifTrue: [aGrammar ruleNamed: n] ifFalse: [
		(n beginsWith: 'EXP')
			ifTrue: [
				self
					originalRuleFor: (n copyWithRegex: '^EXP\d+' matchesReplacedWith: '')
					in: aGrammar
					from: anOriginalGrammar]
			ifFalse: [anOriginalGrammar ruleNamed: n]]
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> outputStringFor: aGrammar original: anOriginalGrammar [

	| rules |
	rules := aGrammar childSandblocks select: [:r | r name ~= 'primitive'].
	SBToggledCode
		comment: 'only keep one primitive'
		active: 1
		do: {[rules := rules copyWithoutAll: (rules select: #isPrimitive) viewAllButFirst]}.
	
	^ '<meta charset="utf-8">
<script src="https://unpkg.com/blockly/blockly.min.js"></script>
<div id="blocklyDiv" style="height: 480px; width: 800px;"></div>

<xml id="toolbox"><category name="blocks">
	{1}
	<block type="rubber"></block>
</category></xml>
<script>
	{3}
	{2}
	Blockly.Blocks[''rubber''] = \{
		init: function() \{
    		this.setPreviousStatement(true, null);
			this.setNextStatement(true, null);
			this.appendValueInput("NAME");
 		\}
	\}
</script>

<script>
Blockly.BlockSvg.START_HAT = true;
var workspace = Blockly.inject(''blocklyDiv'', \{
	toolbox: document.getElementById(''toolbox''),
	collapse: true,
	toolboxPosition: ''start'',
	trashcan: true
\});
</script>' format: {
		(rules collect: [:rule | '<block type="{1}">{2}</block>' format: {rule name. ''}]) joinSeparatedBy: String cr.
		(rules collect: [:rule | | props |
			props := String streamContents: [:stream |
				self connectorsOf: rule on: stream original: anOriginalGrammar.
				stream nextPutAll: 'this.setColour(', (360 atRandom asString, ');').
				rule isPrimitive
					ifTrue: [self propsForExpression: (SBOhmIdentifier new contents: 'letter') on: stream]
					ifFalse: [
						rule expression isSequence
							ifFalse: [self propsForExpression: rule expression on: stream]
							ifTrue: [
								rule expression childSandblocks do: [:part |
									self propsForExpression: part on: stream.
									stream
										nextPut: $;;
										cr]]]].
			'Blockly.Blocks[''{1}''] = \{
  init: function() \{
	this.setInputsInline(true);
	this.setTooltip(''{1}'');
    {2}
  \}
\}' format: {rule name. props}]) joinSeparatedBy: String cr.
		self jsFieldToggle}
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> propsForExpression: aPart on: aStream [

	self inputTypeFor: aPart on: aStream.
	
	(aPart isRepeatQuantifier and: [aPart expression isIdentifier and: [aPart expression isSimple not]]) ifTrue: [^ self].
	(aPart isIdentifier and: [aPart isPrimitive not]) ifTrue: [^ self].
	
	self fieldFor: aPart on: aStream
]

{ #category : #'transform pipelines' }
SBGrammarTransformer class >> rascalSimplified [

	^ {
		[:g | SBGrammarTransformer mergeUpSimpleRules: g].
		[:g | SBGrammarTransformer removeUnitProductions: g].
		[:g | SBGrammarTransformer mergeConsecutiveLabels: g].
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer mergeBinaryOperators: g]}].
		[:g | SBGrammarTransformer removeDuplicateAlternatives: g].
		[:g | SBGrammarTransformer mergeUpLiteralAlternatives: g].
		[:g | SBGrammarTransformer removeUnitProductions: g].
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer splitAlternatives: g]}].
		[:g | SBGrammarTransformer extractSequencesInQuantifiers: g].
		[:g | SBGrammarTransformer removeIdentityAndEmptyRules: g].
		[:g | SBGrammarTransformer mergeUpSimpleRules: g].
		[:g | SBGrammarTransformer mergeConsecutiveLabels: g]}
]

{ #category : #'transform pipelines' }
SBGrammarTransformer class >> rascalSimplifiedMin [

	^ {
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer mergeUpSimpleRules: g]}].
		[:g | SBGrammarTransformer mergeIdenticalAroundLiteral: g].
		[:g | self supportsCardinality ifFalse: [SBGrammarTransformer extractSequencesInQuantifiers: g]].
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer mergeUpSimpleRules: g]}].
		[:g | g mergeRedundantGroups].
		[:g |
			SBToggledCode
				comment: ''
				active: 0
				do: {[SBGrammarTransformer mergeUpLiteralAlternatives: g]}].
		[:g | SBGrammarTransformer mergeConsecutiveLabels: g].
		[:g | SBGrammarTransformer removeDuplicateAlternatives: g].
		[:g |
			SBToggledCode
				comment: ''
				active: 0
				do: {[SBGrammarTransformer mergeUpCardinalityOnlyBlocks: g]}].
		[:g |
			SBToggledCode
				comment: ''
				active: 1
				do: {[SBGrammarTransformer splitNonToplevelAlternatives: g]}].
		[:g |
			SBToggledCode
				comment: ''
				active: 1
				do: {[self supportsCardinality ifFalse: [SBGrammarTransformer flattenOptionals: g]]}].
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer mergeUpUnitUses: g]}].
		[:g | SBToggledCode comment: '' active: 1 do: {[SBGrammarTransformer mergeUpUnitUses: g]}]}
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeBuiltInRules: g [
	" remove extensions of built-in rules"

	g childSandblocks do: [:rule | rule name = 'space' ifTrue: [rule delete]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeDuplicateAlternatives: g [
	" remove duplicate alternatives "

	g allBlocksDo: [:b |
		b isAlternative ifTrue: [ | seen |
			seen := Set new.
			b childSandblocks copy do: [:alt |
				(alt isIdentifier and: [seen includes: alt contents])
					ifTrue: [alt delete]
					ifFalse: [seen add: alt contents]]]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeIdentityAndEmptyRules: g [

	| toDelete |
	" cleanup: remove identity and empty rules "
	toDelete := OrderedCollection new.
	g childSandblocks
		select: [:rule | rule expression isNil or: [rule expression isIdentifier]]
		thenDo: #delete.
	g allBlocksDo: [:b | ((b isAlternative or: [b isSequence or: [b isQuantifier]]) and: [b childSandblocks size < 1]) ifTrue: [toDelete add: b]].
	toDelete do: #delete.
	toDelete := OrderedCollection new.
	g allBlocksDo: [:b | ((b isAlternative or: [b isSequence or: [b isQuantifier]]) and: [b childSandblocks size < 1]) ifTrue: [toDelete add: b]].
	toDelete do: #delete
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeListSeparatorsWithRecursion: g [
	" remove separators in the form R = E (',' R)?"

	g childSandblocksDo: [:r |
		(r expression isSequence and: [ | c |
			c := r expression childSandblocks.
			c last isOptional and: [c last expression childSandblocks notEmpty and: [ | rec |
				rec := c last expression childSandblocks last.
				rec isIdentifier and: [rec contents = r name]]]]) ifTrue: [
			r expression childSandblocks last delete.
			SBWrapCommand new
				outer: SBOhmQuantifier new;
				inner: r expression;
				wrap: [:outer :inner | outer expression: inner quantifier: '+'];
				do]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeListSeperators0toN: g [

	| suspiciousQuantifiers |
	" try and detect 0-n lists with separators "
	suspiciousQuantifiers := OrderedCollection new.
	g allBlocksDo: [:b | (b isRepeatQuantifier and: [b expression isSequence and: [b expression childSandblocks last isTerminal and: [b expression childSandblocks last contents size = 1]]]) ifTrue: [suspiciousQuantifiers add: b]].
	suspiciousQuantifiers do: [:b | | char |
		char := b expression childSandblocks last contents.
		b expression childSandblocks last delete.
		b mergeRedundantGroups.
		" check if we have an optional terminator construct (a "
		")* a? "
		(b adjacentBlock: 1) ifNotNil: [:next | (next isQuantifier and: [next quantifier = $? and: [(next expression isIdentifier and: [next expression contents = b expression contents]) or: [next expression isTerminal and: [next expression contents = char]]]]) ifTrue: [next delete]]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeListSeperators1toN: g [

	| suspiciousQuantifiers |
	" try and detect 1-n lists with separators "
	suspiciousQuantifiers := OrderedCollection new.
	g allBlocksDo: [:b |
		((b isRepeatQuantifier and: [b expression isSequence and: [b expression childSandblocks first isTerminal and: [b expression childSandblocks first contents size = 1]]]) and: [
			(b adjacentBlock: -1)
				ifNotNil: [:prev | prev isIdentifier and: [prev contents = b expression childSandblocks last contents]]
				ifNil: [false]]) ifTrue: [suspiciousQuantifiers add: b]].
	suspiciousQuantifiers do: [:b |
		SBWrapCommand new
			inner: (b adjacentBlock: -1);
			outer: SBOhmQuantifier new;
			wrap: [:outer :inner | outer expression: inner quantifier: '+'];
			do.
		b delete]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeLookAheads: g [

	| toDelete |
	" remove lookaheads "
	toDelete := OrderedCollection new.
	g allBlocksDo: [:b | b isLookahead ifTrue: [toDelete add: (b parentSandblock isQuantifier ifTrue: [b parentSandblock] ifFalse: [b])]].
	toDelete do: #delete.
	g childSandblocks copy do: [:r | r expression ifNil: [r delete]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeSpaces: g [

	| toDelete |
	" remove spaces "
	toDelete := OrderedCollection new.
	g allBlocksDo: [:b | (b isIdentifier and: [b contents = 'space']) ifTrue: [toDelete add: (b parentSandblock isQuantifier ifTrue: [b parentSandblock] ifFalse: [b])]].
	toDelete do: #delete
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeUnitProductions: g [

	| candidates |
	" remove unit productions "
	candidates := g allBlocksSelect: [:b | b isIdentifier and: [b parentSandblock isAlternative and: [b parentSandblock parentSandblock isRule]]].
	" only remove those that we think are redundant specifiers,
i.e. that are reacheable from at least one other place"
	candidates do: [:c | (c allUsages difference: candidates) ifNotEmpty: [c delete]].
	g mergeRedundantGroups
]

{ #category : #'transform pipelines' }
SBGrammarTransformer class >> removeUnnecessarySyntax [

	^ {
		[:g | SBGrammarTransformer removeLookAheads: g].
		[:g | SBGrammarTransformer removeListSeperators0toN: g].
		[:g | SBGrammarTransformer removeListSeperators1toN: g].
		[:g | SBGrammarTransformer removeListSeparatorsWithRecursion: g].
		[:g |
			" change A A* to A+ "
			g allBlocksDo: [:b |
				(b isRepeatQuantifier and: [
					b quantifier = '*' and: [
						(b adjacentBlock: -1)
							ifNotNil: [:adj | adj isIdentifier and: [adj contents = b contents]]
							ifNil: [false]]]) ifTrue: [
					(b adjacentBlock: -1) delete.
					b quantifier: '+']]]}
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeUnusedRules: g [

	g childSandblocksDo: [:r | r allUsages size < 1 ifTrue: [r delete]]
]

{ #category : #'transform helper' }
SBGrammarTransformer class >> run: aCollection for: aGrammar [

	| g |
	g := aGrammar.
	aCollection do: [:step | step value: g].
	^ g
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> splitAlternatives: g [

	| alts splitRules |
	" split alternatives "
	alts := OrderedCollection new.
	g allBlocksDo: [:b | ((b isAlternative and: [(b childSandblocks allSatisfy: #isTerminal) not]) and: [b containingRule isPrimitive not]) ifTrue: [alts add: b]].
	splitRules := (alts collect: #containingRule) asSet.
	alts do: [:alt | | terminals nonTerminals |
		terminals := alt childSandblocks select: #isTerminal.
		nonTerminals := alt childSandblocks select: [:optn | optn isTerminal not].
		SBToggledCode
			comment: 'keep terminals in one separate together so that we get dropdowns for these'
			active: 1
			do: {
				[
					terminals size > 1 ifTrue: [
						terminals do: #delete.
						alt addMorphBack: (SBOhmList new connect: 'OR' expressions: terminals)]]}.
		
		alt childSandblocks doWithIndex: [:optn :index | | rule newRule |
			rule := alt containingRule.
			alt replaceBy: optn.
			newRule := rule veryDeepCopy name: 'EXP', (index asString, rule name).
			optn replaceBy: alt.
			g addMorphBack: newRule]].
	alts do: [:alt | alt childSandblocks size = 0 ifTrue: [alt containingRule ifNotNil: #delete]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> splitNonToplevelAlternatives: g [

	| alts splitRules |
	" split alternatives "
	alts := OrderedCollection new.
	g allBlocksDo: [:b | (((b isAlternative and: [(b childSandblocks allSatisfy: #isTerminal) not]) and: [b containingRule isPrimitive not]) and: [b parentSandblock isRule not]) ifTrue: [alts add: b]].
	splitRules := (alts collect: #containingRule) asSet.
	alts do: [:alt | | terminals nonTerminals rule |
		terminals := alt childSandblocks select: #isTerminal.
		nonTerminals := alt childSandblocks select: [:optn | optn isTerminal not].
		SBToggledCode
			comment: 'keep terminals in one separate together so that we get dropdowns for these'
			active: 1
			do: {
				[
					terminals size > 1 ifTrue: [
						terminals do: #delete.
						alt addMorphBack: (SBOhmList new connect: 'OR' expressions: terminals)]]}.
		
		rule := alt containingRule.
		rule ensureExpressionIsAlternative.
		alt childSandblocks allButLastDo: [:optn | | newPart |
			alt replaceBy: optn.
			newPart := rule expression veryDeepCopy.
			optn replaceBy: alt.
			rule expression addMorphBack: newPart]].
	SBToggledCode
		comment: ''
		active: 0
		do: {[alts do: [:alt | alt childSandblocks size = 0 ifTrue: [alt containingRule ifNotNil: #delete]]]}.
	g mergeRedundantGroups
]

{ #category : #constants }
SBGrammarTransformer class >> supportsCardinality [

	^ true
]

{ #category : #'generate helper' }
SBGrammarTransformer class >> writeFor: aGrammar original: anOriginalGrammar [

	| file |
	file := (FileDirectory default / 'blocky-test.html') fullName.
	FileStream
		forceNewFileNamed: file
		do: [:f | f nextPutAll: (self outputStringFor: aGrammar original: anOriginalGrammar)].
	^ file
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> argumentsDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> canDeleteChild: aBlock [

	^ aBlock isFirstChild not
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> currentSelector: messageName [

	self selectorName contents: messageName.
	super currentSelector: messageName
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> grammar [

	^ self childSandblocks second
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> grammar: aGrammar steps: aCollection [

	self grammar replaceBy: ((aGrammar isKindOf: SBOhmGrammar) ifTrue: [aGrammar] ifFalse: [
		aGrammar isMessageSend
			ifTrue: [SBOhmGrammar from: aGrammar arguments first contents]
			ifFalse: [SBOhmGrammar from: aGrammar grammarDefinitionString]]).
	self steps copy do: #delete.
	aCollection do: [:block | self addMorphBack: (SBGrammarTransformStep new block: block asSandblock)]
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> initialize [

	super initialize.
	self
		hResizing: #rigid;
		width: 200;
		vResizing: #shrinkWrap;
		changeTableLayout;
		listDirection: #topToBottom;
		addMorphBack: (SBTextBubble new placeholderText: 'selector ...');
		addMorphBack: SBOhmGrammar new;
		addMorphBack: (SBStringMorph new contents: 'Transforms');
		addMorphBack: SBGrammarTransformStep new;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> newEmptyChildNear: aBlock before: aBoolean [

	^ SBGrammarTransformStep new
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> objectInterfaceNear: aBlock at: aSymbol [

	aBlock = self grammar ifTrue: [
		^ aSymbol = #replace
			ifTrue: [{[:o | o isKindOf: SBOhmGrammar]}]
			ifFalse: [SBInterfaces never]].
	^ {[:o | o isKindOf: SBGrammarTransformStep]}
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> selector [

	^ self selectorName contents
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> selector: aSymbol arguments: aCollection [

	self selectorName contents: aSymbol
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> selectorName [

	^ self childSandblocks first
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> specialDropCommand: aBlock [

	^ (aBlock isOhm and: [aBlock isKindOf: SBOhmGrammar])
		ifTrue: [
			SBReplaceCommand new
				target: self grammar;
				replacer: aBlock]
		ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> steps [

	^ self childSandblocks viewAllButFirst: 2
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> writeSignatureSourceOn: aStream [

	aStream nextPutAll: self selectorName contents
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> writeSourceOn: aStream [

	aStream nextPutAll: self selector.
	aStream cr.
	aStream nextPutAll: '<grammarTransformer>'.
	aStream nextPutAll: '^'.
	aStream nextPutAll: self className.
	aStream space.
	aStream nextPutAll: 'grammar: '.
	self grammar writeStBlockSourceOn: aStream.
	aStream nextPutAll: ' steps: {'.
	self steps do: [:step | step block body writeSourceOn: aStream].
	aStream nextPutAll: '}'
]
