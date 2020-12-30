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
		',')
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

	self submorphCount = 3 ifTrue: [
		aBlock value: self firstSubmorph.
		aBlock value: self lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> contents [

	^ self submorphCount = 3 ifTrue: [self currentTextMorph contents] ifFalse: [nil]
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
	symbols second ifNotNil: [
		aCanvas
			drawString: symbols second
			at: self layoutBounds topRight
			font: font
			color: fg]
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

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self lhs layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			self contents = '['
				ifTrue: [self rhs layoutCommands]
				ifFalse: [SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap. self rhs layoutCommands}]
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
		#('.' '?.' '[') -> 20. " missing: function call "
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
SBJsInfixOperator >> rhs [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := (SBInputCommand newOrEditFor: self containingArtefact)
		oldMorph: self;
		previousText: self currentTextMorph contents;
		yourself.
	
	aBoolean
		ifTrue: [self currentTextMorph contents: ''; moveCursorTo: 0]
		ifFalse: [self currentTextMorph moveCursorTo: aNumber].
	
	^ cmd
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> stopEditing: aCommand [

	aCommand
		newText: self currentTextMorph contents;
		newMorph: self.
	
	self currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBJsInfixOperator >> symbols [

	^ self contents = '[' ifTrue: [#(nil ']')] ifFalse: [#(nil nil)]
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
