Class {
	#name : #SBTestMarker,
	#superclass : #TestCase,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBTestMarker class >> allTestSelectors [

	^ Array streamContents: [:stream | (SystemNavigation default allCallsOn: #self:args:label:assert:) do: [:reference | stream nextPutAll: ((self examplesFromMethod: reference compiledMethod) collect: [:node | reference actualClass name, '_', (reference selector, '_', node arguments third key)])]]
]

{ #category : #'as yet unclassified' }
SBTestMarker class >> examplesFromMethod: method [

	^ Array streamContents: [:stream | method methodNode body statements withIndexDo: [:node :index | (node isMessageNode and: [node receiver isVariableNode and: [node receiver name = 'SBExample' and: [node selector key = #self:args:label:assert:]]]) ifTrue: [stream nextPut: node]]]
]

{ #category : #'as yet unclassified' }
SBTestMarker >> evaluateNode: aNode [

	^ Compiler evaluate: (String streamContents: [:str | aNode printOn: str indent: 0]), ' value'
]

{ #category : #'as yet unclassified' }
SBTestMarker >> partsFromCombinedSelector: aString [

	| stream className selector name |
	SBExample
		self: [SBTestMarker new]
		args: [{'Test_we_abc_def'}]
		label: 'example'
		assert: [[:array | array hasEqualElements: {'Test'. 'we_abc'. 'def'}]].
	stream := aString readStream.
	SBToggledCode
		comment: 'NOTE: Does not work with classes that contain underscores'
		active: 1
		do: {[className := stream upTo: $_]}.
	selector := (self upToLast: $_ in: stream) allButFirst.
	name := stream upToEnd.
	^ {className. selector. name}
]

{ #category : #'as yet unclassified' }
SBTestMarker >> performTest [

	| parts class method examples |
	parts := self partsFromCombinedSelector: testSelector.
	class := (parts first endsWith: ' class')
		ifTrue: [(Smalltalk at: (parts first allButLast: ' class' size) asSymbol) class]
		ifFalse: [Smalltalk at: parts first asSymbol].
	method := class >> parts second asSymbol.
	examples := self class examplesFromMethod: method.
	examples
		detect: [:example | example arguments third key = parts third]
		ifFound: [:example | self runTest: example in: method]
]

{ #category : #'as yet unclassified' }
SBTestMarker >> runTest: aMessageNode in: aCompiledMethod [

	| receiver arguments compare result |
	receiver := Compiler evaluate: (String streamContents: [:str | aMessageNode arguments first printOn: str indent: 0]), ' value'.
	arguments := self evaluateNode: aMessageNode arguments second.
	compare := self evaluateNode: aMessageNode arguments fourth.
	result := receiver perform: aCompiledMethod selector withArguments: arguments.
	compare isBlock ifTrue: [self assert: (compare value: result)] ifFalse: [self assert: compare equals: result]
]

{ #category : #'as yet unclassified' }
SBTestMarker >> timeoutForSetUp [

	^ self defaultTimeout
]

{ #category : #'as yet unclassified' }
SBTestMarker >> timeoutForTest [

	^ self defaultTimeout
]

{ #category : #'as yet unclassified' }
SBTestMarker >> upToLast: aCharacter in: aStream [

	| combined next |
	next := ''.
	combined := ''.
	[
		next := aStream upTo: aCharacter.
		aStream atEnd ifTrue: [
			aStream position: aStream position - next size.
			^ combined].
		combined := (combined, '_'), next] repeat
]
