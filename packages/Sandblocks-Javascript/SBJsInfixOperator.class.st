Class {
	#name : #SBJsInfixOperator,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsInfixOperator class >> validInfixOperators [

	^ #('+' '-' '/' '*' '%' '**'
		'in' 'instanceof' '<' '>' '<=' '>='
		'==' '!=' '===' '!=='
		'<<' '>>' '>>>'
		'&' '|' '^'
		'&&' '||' '??'
		'?.'
		'.' '['
		'*=' '**=' '/=' '%=' '+=' '-=' '<<=' '>>=' '>>>=' '&=' '^=' '|=' '&&=' '||=' '??='
		','
		" special operators where we cheat and pretend it's infix by using an arity ~= 1"
		'++' '--' '(')
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> allRhs [

	^ self submorphs viewFrom: 3 to: self submorphCount
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> arity [

	self contents = '(' ifTrue: [^ self allRhs size].
	(#('++' '--') includes: self contents) ifTrue: [^ 0].
	^ 1
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> canDeleteChild: aMorph [

	^ self fixedNumberOfChildren ifTrue: [false] ifFalse: [aMorph ~= self lhs]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> canMakeDeclaration [

	^ self isStatement and: [self operator contents = '=']
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> centerAlignSymbols [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> childSandblocksDo: aBlock [

	(self submorphCount >= 2 and: [self firstSubmorph isSandblock]) ifTrue: [
		aBlock value: self firstSubmorph.
		self allRhs do: aBlock]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> contents [

	^ self submorphCount >= 2 ifTrue: [self currentTextMorph contents] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> continueInputInRhs: anEvent [

	self sandblockEditor startInput: self rhs at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> currentTextMorph [

	^ self operator
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> deleteBeforeCursor [
	<inputAction>
	
	self contents ifEmpty: [^ self tryDelete].
	self sandblockEditor deleteBeforeCursor
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> drawSymbolsOn: aCanvas [

	| symbols fg font space centerAlign |
	centerAlign := self colorPolicy centerAlignSymbols and: [self centerAlignSymbols].
	symbols := self symbols.
	space := self spaceForSymbols.
	font := self fontToUse.
	fg := self sandblockForegroundColor.
	symbols first ifNotNil: [
		aCanvas
			drawString: symbols first
			at: self layoutBounds origin + (space first negated rounded @ 0)
			font: font
			color: fg].
	symbols second ifNotNil: [ | drawAtBottom |
		drawAtBottom := self height > (self fontToUse height * 2).
		aCanvas
			drawString: symbols second
			at: (drawAtBottom
				ifTrue: [self layoutBounds bottomRight - (0 @ (self fontToUse height + 2))]
				ifFalse: [self layoutBounds topRight])
			font: font
			color: fg]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> fixedNumberOfChildren [

	^ self contents ~= '('
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: ((self submorphs indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]) max: 3);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> isBinaryOperator [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self class validInfixOperators
		detect: [:operator | operator beginsWith: self currentTextMorph contents]
		ifNone: [
			self currentTextMorph deleteBeforeCursor.
			self continueInputInRhs: anEvent]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> layoutCommands [

	| rhs |
	rhs := self allRhs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap].
	^ SBAlgebraCommand container
		morph: self;
		data: {
			self lhs layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap}, rhs
		}
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> lhs [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> lhs: aLeftBlock operator: anOperatorString rhs: aRhsBlock [

	self addMorphBack: aLeftBlock.
	self addMorphBack: (SBOwnTextMorph new contents: anOperatorString).
	self addMorphBack: aRhsBlock
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> makeDeclaration [
	<action>
	<actionValidIf: #canMakeDeclaration>
	
	self sandblockEditor do: ((SBRecordedCommand newFor: self containingArtefact) record: [:recorder |
		recorder restore: {self lhs. self rhs} after: [
			recorder replace: self with: (SBJsDeclaration new lhs: self lhs rhs: self rhs)]])
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> operator [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> precedence [

	^ {
		#('.' '?.' '[' '(') -> 20.
		" missing: postfix incr/decr -> 18 "
		#('**') -> 16.
		#('*' '/' '%') -> 15.
		#('+' '-') -> 14.
		#('<<' '>>' '>>>') -> 13.
		#('<' '<=' '>' '>=' 'in' 'instanceof') -> 12.
		#('==' '!=' '===' '!==') -> 11.
		#('&') -> 10.
		#('^') -> 9.
		#('|') -> 8.
		#('&&') -> 7.
		#('||') -> 6.
		#('??') -> 5.
		" missing: ternary op -> 4"
		#('=' '+=' '-=' '**=' '/=' '%=' '<<=' '>>=' '>>>=' '&=' '^=' '|=' '&&=' '||=' '??=') -> 3.
		#(',') -> 1.
	} detect: [:assoc | assoc key includes: self contents] ifFound: #value ifNone: [super precedence]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> printOn: aStream [

	self contents = '(' ifTrue: [^ aStream nextPutAll: 'method call'].
	self contents = '[' ifTrue: [^ aStream nextPutAll: 'member access'].
	aStream nextPutAll: 'operator '; nextPutAll: self contents
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> rhs [

	^ self submorphCount >= 3 ifTrue: [self lastSubmorph] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> shouldRotateWhenJustAdded [

	^ self parentSandblock precedence > 0 and: [
	self parentSandblock precedence >= self precedence and: [self parentSandblock rhs = self and: self parentSandblock contents ~= '(']]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> skipLeftRightNavigation [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBJsInfixOpInputCommand newFor: self containingArtefact)
		previousOperator: self currentTextMorph contents;
		previousRhs: self allRhs;
		morph: self;
		yourself.
	
	aBoolean
		ifTrue: [self currentTextMorph contents: ''; moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> stopEditing: aCommand [

	aCommand operator: self currentTextMorph contents.
	aCommand doRotate: (aCommand previousOperator = '' and: [self shouldRotateWhenJustAdded]).
	
	self currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> symbols [

	^ self contents caseOf: {
		['['] -> [#(nil ']')].
		['('] -> [#(nil ')')].
	} otherwise: [#(nil nil)]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> tryDelete [

	| lhs |
	lhs := self lhs.
	^ self sandblockEditor
		endInput;
		do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: lhs);
		startInput: lhs at: 9e8 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> wantsExtraSpace [

	^ self contents ~= '[' and: [self contents ~= '.']
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> writeSourceOn: aStream [

	aStream nextPutAll: '('.
	self lhs writeSourceOn: aStream.
	aStream nextPutAll: self operator contents.
	self allRhs do: [:s | s writeSourceOn: aStream] separatedBy: [aStream nextPut: $,; cr].
	
	self contents = '(' ifTrue: [aStream nextPut: $)].
	self contents = '[' ifTrue: [aStream nextPut: $]].
	aStream nextPutAll: ')'
]