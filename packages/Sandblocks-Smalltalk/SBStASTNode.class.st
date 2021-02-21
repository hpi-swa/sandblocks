Class {
	#name : #SBStASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStASTNode class >> preferredColor [

	^ Color r: 0.216 g: 0.249 b: 0.436
]

{ #category : #'action helpers' }
SBStASTNode >> actionProviders [

	^ {self grammarHandler}, super actionProviders
]

{ #category : #converting }
SBStASTNode >> asMessagePart: aConverter [
	<convert>
	
	^ aConverter
		if: [self currentTextMorph notNil]
		do: [SBStMessagePart new contents: self contents]
]

{ #category : #converting }
SBStASTNode >> asMorphBlock: converter [
	<convert>
	
	" we can't generally convert ourselves to morphs since we need our artefact owner "
]

{ #category : #testing }
SBStASTNode >> canAppearInBlockBody [

	^ self isExpression
]

{ #category : #evaluate }
SBStASTNode >> evaluate [

	^ self containingArtefact
		ifNotNil: [:artefact | | context |
			context := artefact evaluationContext.
			Compiler new
				evaluate: self sourceString
				in: context
				to: (context ifNil: [artefact evaluationReceiver] ifNotNil: #receiver)
				notifying: artefact
				ifFail: nil]
		ifNil: [Compiler evaluate: self sourceString]
]

{ #category : #evaluate }
SBStASTNode >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>

	| result |
	result := self evaluate.
	self containingArtefact ifNotNil: [
		self containingArtefact cacheType: result class for: self].
	
	result convertedFor: SBInterfaces topLevel do: [:morph |
		self sandblockEditor openMorphInView: morph.
		morph focusAfterDelete: self.
		self sandblockEditor connectFrom: self to: morph]
]

{ #category : #evaluate }
SBStASTNode >> evaluationContext [

	^ nil
]

{ #category : #evaluate }
SBStASTNode >> evaluationReceiver [

	^ nil
]

{ #category : #accessing }
SBStASTNode >> grammarHandler [

	^ SBStGrammarHandler new
]

{ #category : #accessing }
SBStASTNode >> guessClassExpensive [

	^ self guessedClass ifNil: [[(SBStSandboxSimulator new simulate: [self evaluate]) ifNotNil: #class] on: Error do: [nil]]
]

{ #category : #accessing }
SBStASTNode >> guessedClass [

	" return a non-nil value to help services like autocompletion do their job "
	^ nil
]

{ #category : #'initialize-release' }
SBStASTNode >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #testing }
SBStASTNode >> isReturn [

	^ false
]

{ #category : #testing }
SBStASTNode >> isSmalltalk [

	^ true
]

{ #category : #accessing }
SBStASTNode >> newNullBlock [

	^ SBUnknown new grammarHandler: SBStGrammarHandler new
]

{ #category : #'object interface' }
SBStASTNode >> object [

	^ self
]

{ #category : #'object interface' }
SBStASTNode >> objectInterfaceAt: aNumber adding: aBoolean [

	^ (self fixedNumberOfChildren and: [aBoolean]) ifTrue: [SBInterfaces never] ifFalse: [SBInterfaces stExpression]
]

{ #category : #accessing }
SBStASTNode >> pc [

	^ 0
]

{ #category : #accessing }
SBStASTNode >> pc: aNumber [

	" save a pc if you are an accessible point during execution "
]

{ #category : #accessing }
SBStASTNode >> preferredColor [

	^ self class preferredColor
]

{ #category : #printing }
SBStASTNode >> prettySourceString [

	^ SBFormatter formatString: self sourceString class: self containingArtefact relatedClass noPattern: self ~= self containingArtefact
]

{ #category : #printing }
SBStASTNode >> selectionLabel [

	^ String streamContents: [:stream |
		self printOn: stream.
		
		self guessedClass ifNotNil: [:c | stream space; nextPut: $(. c printOn: stream. stream nextPut: $)]]
]

{ #category : #printing }
SBStASTNode >> sourceString [

	^ String streamContents: [:s | self writeSourceOn: s]
]

{ #category : #accessing }
SBStASTNode >> updatePCFrom: aBlock [

	self pc: aBlock pc
]

{ #category : #converting }
SBStASTNode >> wrapInPlayground: convert [
	<convert>
	
	convert do: [SBStPlayground new statements: {self veryDeepCopy}]
]

{ #category : #printing }
SBStASTNode >> writeSourceOn: aStream [

	^ self subclassResponsibility
]
