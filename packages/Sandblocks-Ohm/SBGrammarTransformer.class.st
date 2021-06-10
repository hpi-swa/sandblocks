Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBStMethodSubstitution,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'generate blocks' }
SBGrammarTransformer class >> connectorsOf: rule on: aStream original: anOriginalGrammar [

	| usages |
	usages := ((rule name beginsWith: 'GEN') ifTrue: [rule] ifFalse: [(rule name beginsWith: 'EXP') ifTrue: [anOriginalGrammar ruleNamed: (rule name allButFirst: 4)] ifFalse: [anOriginalGrammar ruleNamed: rule name]]) allUsages.
	usages ifNotEmpty: [
		(usages anySatisfy: [:identifier | identifier parentSandblock isQuantifier and: [identifier isPrimitive not]])
			ifTrue: [
				aStream
					nextPutAll: 'this.setPreviousStatement(true, null);';
					nextPutAll: 'this.setNextStatement(true, null);']
			ifFalse: [aStream nextPutAll: 'this.setOutput(true, null);']]
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
	" handled through the input type "
	aPart isQuantifier ifTrue: [^ self].
	
	^ self error: 'not supported'
]

{ #category : #'generate helper' }
SBGrammarTransformer class >> grammar: anOhmGrammar steps: aCollection [

	| grammar |
	grammar := anOhmGrammar veryDeepCopy.
	aCollection do: [:block | block value: grammar].
	self openFor: grammar original: anOhmGrammar
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> inputTypeFor: aPart on: aStream [

	aPart
		allBlocksDetect: [:part | part isQuantifier]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendStatementInput("NAME")']
		ifNone: [].
	aPart
		allBlocksDetect: [:part | part isIdentifier and: [part isPrimitive not]]
		ifFound: [:part | ^ aStream nextPutAll: 'this.appendValueInput("NAME")']
		ifNone: [].
	
	aStream nextPutAll: 'this.appendDummyInput("NAME")'
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

{ #category : #'generate helper' }
SBGrammarTransformer class >> openFor: aGrammar original: anOriginalGrammar [

	ExternalWebBrowser openOnUrl: 'file://', (self writeFor: aGrammar original: anOriginalGrammar)
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
		(rules collect: [:rule | '<block type="{1}"></block>' format: {rule name}]) joinSeparatedBy: String cr.
		(rules collect: [:rule | | props |
			props := String streamContents: [:stream |
				self connectorsOf: rule on: stream original: anOriginalGrammar.
				stream nextPutAll: 'this.setColour(', (360 atRandom asString, ');').
				rule isPrimitive
					ifTrue: [self propsForExpression: (SBOhmIdentifier new contents: 'letter') on: stream]
					ifFalse: [
						rule expression childSandblocks do: [:part |
							self propsForExpression: part on: stream.
							stream
								nextPut: $;;
								cr]]].
			'Blockly.Blocks[''{1}''] = \{
  init: function() \{
	this.setInputsInline(true);
    {2}
  \}
\}' format: {rule name. props}]) joinSeparatedBy: String cr}
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> propsForExpression: aPart on: aStream [

	self inputTypeFor: aPart on: aStream.
	
	(aPart isQuantifier and: [aPart expression isIdentifier]) ifTrue: [^ self].
	(aPart isIdentifier and: [aPart isPrimitive not]) ifTrue: [^ self].
	
	self fieldFor: aPart on: aStream
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
