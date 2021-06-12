Class {
	#name : #SBGrammarTransformer,
	#superclass : #SBStMethodSubstitution,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'generate blocks' }
SBGrammarTransformer class >> connectorsOf: rule on: aStream original: anOriginalGrammar [

	| usages |
	usages := (self originalRuleFor: rule from: anOriginalGrammar) allUsages.
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
						seq isSequence and: [seq childSandblocks size = 2 and: [(seq childSandblocks first isTerminal or: [seq childSandblocks first isAlternative and: [seq childSandblocks first childSandblocks allSatisfy: #isTerminal]]) and: [seq childSandblocks second isIdentifier and: [seq childSandblocks second contents = b childSandblocks first contents]]]]]]]]) ifTrue: [ops add: b]].
	ops do: [:b |
		b childSandblocks second replaceBy: b childSandblocks second expression.
		b mergeRedundantGroups]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> extractSequencesInQuantifiers: g [

	| seqs extractCounts |
	" extract seqs of non-primitives inside quantifiers "
	seqs := OrderedCollection new.
	g allBlocksDo: [:b | (b isQuantifier and: [b expression isSequence and: [b expression childSandblocks anySatisfy: [:c | c isTerminal not or: [c isIdentifier and: [c isPrimitive not]]]]]) ifTrue: [seqs add: b expression]].
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
		allBlocksDetect: [:part | part isRepeatQuantifier and: [part expression allBlocksDetect: [:b | b isIdentifier and: [b isSimple not]] ifFound: [:b | true] ifNone: [false]]]
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

{ #category : #'transform steps' }
SBGrammarTransformer class >> mergeBinaryOperators: g [

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
	simpleRules := g childSandblocks select: [:rule | (rule allBlocksSelect: [:b | b isIdentifier]) size <= 1 and: [rule allUsages notEmpty and: [rule isPrimitive not or: [rule expression isAlternative]]]].
	simpleRules do: [:r |
		r allUsages do: [:id | | copy |
			(SBToggledCode
				comment: 'why was this necessary?'
				active: 1
				do: {[true]. [id parentSandblock isAlternative not]}) ifTrue: [
				copy := r expression veryDeepCopy.
				id replaceBy: copy]]].
	simpleRules do: [:r | r allUsages size < 1 ifTrue: [r delete]]
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

{ #category : #'as yet unclassified' }
SBGrammarTransformer class >> originalRuleFor: rule from: anOriginalGrammar [

	^ (rule name beginsWith: 'GEN') ifTrue: [rule] ifFalse: [
		(rule name beginsWith: 'EXP')
			ifTrue: [anOriginalGrammar ruleNamed: (rule name copyWithRegex: '^EXP\d+' matchesReplacedWith: '')]
			ifFalse: [anOriginalGrammar ruleNamed: rule name]]
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
\}' format: {rule name. props}]) joinSeparatedBy: String cr}
]

{ #category : #'generate blocks' }
SBGrammarTransformer class >> propsForExpression: aPart on: aStream [

	self inputTypeFor: aPart on: aStream.
	
	(aPart isRepeatQuantifier and: [aPart expression isIdentifier and: [aPart expression isSimple not]]) ifTrue: [^ self].
	(aPart isIdentifier and: [aPart isPrimitive not]) ifTrue: [^ self].
	
	self fieldFor: aPart on: aStream
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
			c size = 2 and: [
				c second isOptional and: [ | rec |
					rec := c second expression childSandblocks last.
					rec isIdentifier and: [rec contents = r name]]]]) ifTrue: [r expression replaceBy: (SBOhmQuantifier new expression: r expression childSandblocks first quantifier: '+')]]
]

{ #category : #'transform steps' }
SBGrammarTransformer class >> removeListSeperators0toN: g [

	| suspiciousQuantifiers |
	" try and detect 0-n lists with separators "
	suspiciousQuantifiers := OrderedCollection new.
	g allBlocksDo: [:b | (b isRepeatQuantifier and: [b expression isSequence and: [b expression childSandblocks last isTerminal and: [b expression childSandblocks last contents size = 1]]]) ifTrue: [suspiciousQuantifiers add: b]].
	suspiciousQuantifiers do: [:b |
		b expression childSandblocks last delete.
		b mergeRedundantGroups.
		" check if we have an optional terminator construct (a "
		")* a? "
		(b adjacentBlock: 1) ifNotNil: [:next | (next isQuantifier and: [next quantifier = $? and: [next expression isIdentifier and: [next expression contents = b expression contents]]]) ifTrue: [next delete]]]
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
	" only remove those that we think are redundant specifiers,#ppEmptyLine.
i.e. that are reacheable from at least one other place"
	candidates do: [:c | (c allUsages difference: candidates) ifNotEmpty: [c delete]].
	g mergeRedundantGroups
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
