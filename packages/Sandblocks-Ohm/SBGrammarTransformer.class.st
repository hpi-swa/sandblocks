Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBStMethodSubstitution,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> grammar: anOhmGrammar steps: aCollection [

	self halt.
	^ self new grammar: anOhmGrammar steps: aCollection
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> matchSpecific: aBlock [

	^ aBlock pragmas anySatisfy: [:p | p selector = 'grammarTransformer']
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> newFrom: aBlock [

	| msg |
	msg := aBlock statements second expression.
	^ (super newFrom: aBlock) grammar: msg arguments first steps: msg arguments second
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
SBGrammarTransformer >> fieldFor: aPart on: aStream [

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
	
	(aPart isIdentifier and: [aPart contents = 'integerValue']) ifTrue: [^ aStream nextPutAll: '.appendField(new Blockly.FieldNumber(0), "NAME")'].
	
	aPart isSequence ifTrue: [^ aPart childSandblocksDo: [:part | self fieldFor: part on: aStream]].
	
	aPart isIdentifier ifTrue: [^ self].
	
	^ self error: 'not supported'
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

	self grammar replaceBy: ((aGrammar isKindOf: SBOhmGrammar) ifTrue: [aGrammar] ifFalse: [SBOhmGrammar from: aGrammar grammarDefinitionString]).
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
SBGrammarTransformer >> inputTypeFor: aPart on: aStream [

	aPart
		allBlocksDetect: [:part | part isQuantifier]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendStatementInput("NAME")']
		ifNone: [].
	aPart
		allBlocksDetect: [:part | part isIdentifier and: [part contents ~= 'integerValue']]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendValueInput("NAME")']
		ifNone: [].
	
	aStream nextPutAll: 'this.appendDummyInput("NAME")'
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
SBGrammarTransformer >> open [

	ExternalWebBrowser openOnUrl: 'file://', self write
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> outputString [

	| isList rules |
	rules := self submorphs last grammar childSandblocks select: [:r | r name ~= 'integerValue'].
	isList := [:rule | rule allUsages anySatisfy: [:identifier | identifier parentSandblock isQuantifier]].
	
	^ '<meta charset="utf-8">
<script src="https://unpkg.com/blockly/blockly.min.js"></script>
<div id="blocklyDiv" style="height: 480px; width: 800px;"></div>

<xml id="toolbox"><category name="blocks">{1}</category></xml>
<script>
{2}
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
		(rules collect: [:rule | '<block type="{1}"></block>' format: {rule name}]) joinSeparatedBy: String cr.
		(rules collect: [:rule | | props |
			props := String streamContents: [:stream |
				rule allUsages ifNotEmpty: [
					(isList value: rule)
						ifTrue: [
							stream
								nextPutAll: 'this.setPreviousStatement(true, null);';
								nextPutAll: 'this.setNextStatement(true, null);']
						ifFalse: [stream nextPutAll: 'this.setOutput(true, null);']].
				rule expression childSandblocks do: [:part |
					self propsForExpression: part on: stream.
					stream
						nextPut: $;;
						cr]].
			'Blockly.Blocks[''{1}''] = \{
  init: function() \{
    {2}
  \}
\}' format: {rule name. props}]) joinSeparatedBy: String cr}
]

{ #category : #'as yet unclassified' }
SBGrammarTransformer >> propsForExpression: aPart on: aStream [

	self inputTypeFor: aPart on: aStream.
	
	(aPart isQuantifier and: [aPart expression isIdentifier]) ifTrue: [^ self].
	(aPart isIdentifier and: [aPart contents ~= 'integerValue']) ifTrue: [^ self].
	
	self fieldFor: aPart on: aStream
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
SBGrammarTransformer >> write [

	| file |
	file := (FileDirectory default / 'blocky-test.html') fullName.
	FileStream forceNewFileNamed: file do: [:f | f nextPutAll: self outputString].
	^ file
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
	self grammar writeStSourceOn: aStream.
	aStream nextPutAll: ' steps: {'.
	self steps do: [:step | step block body writeSourceOn: aStream].
	aStream nextPutAll: '}'
]
