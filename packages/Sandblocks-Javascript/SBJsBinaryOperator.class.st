Class {
	#name : #SBJsBinaryOperator,
	#superclass : #SBJsASTNode,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsBinaryOperator class >> validBinaryOperators [

	^ #('+' '-' '/' '*' '%' '**'
		'in' 'instanceof' '<' '>' '<=' '>='
		'==' '!=' '===' '!=='
		'<<' '>>' '>>>'
		'&' '|' '^'
		'&&' '||' '??'
		'?.'
		'.'
		'*=' '**=' '/=' '%=' '+=' '-=' '<<=' '>>=' '>>>=' '&=' '^=' '|=' '&&=' '||=' '??='
		',')
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> canMakeDeclaration [

	^ self isStatement and: [self operator contents = '=']
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> childSandblocksDo: aBlock [

	aBlock value: self firstSubmorph.
	aBlock value: self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> contents [

	^ self currentTextMorph contents
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> contents: aString [

	self currentTextMorph contents: aString
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> continueInputInRhs: anEvent [

	self sandblockEditor startInput: self rhs at: 0 replacingContents: false.
	^ self sandblockEditor selection keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> currentTextMorph [

	^ self operator
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> deleteBeforeCursor [
	<inputAction>
	
	self contents ifEmpty: [^ self tryDelete].
	self sandblockEditor deleteBeforeCursor
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> isBinaryOperator [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> keyStroke: anEvent [

	self currentTextMorph keyStroke: anEvent.
	
	self flag: #fixme. " auto-complete unambiguous matches? "
	self class validBinaryOperators
		detect: [:operator | operator beginsWith: self currentTextMorph contents]
		ifNone: [
			self currentTextMorph deleteBeforeCursor.
			self continueInputInRhs: anEvent]
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self lhs layoutCommands.
			SBAlgebraCommand gap.
			SBAlgebraCommand morph data: self submorphs second.
			SBAlgebraCommand indent data: {
				SBAlgebraCommand softLineOrGap.
				self rhs layoutCommands}}
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> lhs [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> lhs: aLeftBlock operator: anOperatorString rhs: aRhsBlock [

	self addMorphBack: aLeftBlock.
	self addMorphBack: (SBOwnTextMorph new contents: anOperatorString).
	self addMorphBack: aRhsBlock
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> makeDeclaration [
	<action>
	<actionValidIf: #canMakeDeclaration>
	
	self sandblockEditor do: ((SBRecordedCommand newFor: self containingArtefact) record: [:recorder |
		recorder restore: {self lhs. self rhs} after: [
			recorder replace: self with: (SBJsDeclaration new lhs: self lhs rhs: self rhs)]])
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> operator [

	^ self submorphs second
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> rhs [

	^ self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> startInputAt: aNumber replacingContents: aBoolean [

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
SBJsBinaryOperator >> stopEditing: aCommand [

	aCommand
		newText: self currentTextMorph contents;
		newMorph: self.
	
	self currentTextMorph stopEditing
]

{ #category : #'as yet unclassified' }
SBJsBinaryOperator >> tryDelete [

	| lhs |
	lhs := self lhs.
	^ self sandblockEditor
		endInput;
		do: ((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: lhs);
		startInput: lhs at: 9e8 replacingContents: false
]
