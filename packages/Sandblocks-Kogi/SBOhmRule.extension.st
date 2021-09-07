Extension { #name : #SBOhmRule }

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> blockDeclarationFrom: anOriginalGrammar [

	self isPrimitive ifTrue: [
		^ SBToggledCode comment: '' active: 1 do: {
			[''].
			['Blockly.Blocks[''{1}1''] = \{
  init: function() \{
	this.setInputsInline(true);
	this.setTooltip(''{1}'');
	this.setOutput(true, null);
	this.appendDummyInput("arg1").appendField(new Blockly.FieldTextInput(""), "arg2")
  \}
\}' format: {self name}]}].
	
	" TODO: split nested alternatives "
	^ ((self expression isAlternative
		ifTrue: [self expression childSandblocks]
		ifFalse: [{self expression}]) withIndexCollect: [:block :index |
		'Blockly.Blocks[''{1}''] = \{
  init: function() \{
	this.setInputsInline(true);
	this.setTooltip(''{1}'');
	{2}
	{3}
  \}
\}' format: {
			self name, index.
			self partDeclarationFor: block from: anOriginalGrammar.
			self connectorsFrom: anOriginalGrammar}]) joinSeparatedBy: String cr, String cr
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> candidateForPrefillingDo: aBlock [

	self isPrimitive ifTrue: [^ aBlock value: 1].
	self expression isAlternative ifTrue: [
		self expression childSandblocks
			detect: [:b | b valueOfProperty: #preferredChoice ifAbsent: [false]]
			ifFound: [:b | ^ aBlock value: (self expression childSandblocks indexOf: b)].
		SBToggledCode
			comment: 'first choise: a choice of terminals (may lead to undesired results...)'
			active: 0
			do: {
				[self expression childSandblocks do: [:expr | (expr isAlternative and: [expr allChildBlocksSatisfy: #isTerminal]) ifTrue: [^ aBlock value: (self expression childSandblocks indexOf: expr)]]]}.
		
		" second choice: an identifier-only, which will result in a simple input field "
		self expression childSandblocks do: [:expr |
			expr
				allBlocksDetect: [:b | (b isIdentifier and: [b isPrimitive not]) or: [b isTerminal and: [b contents size > 1]]]
				ifFound: [:b | ]
				ifNone: [^ aBlock value: (self expression childSandblocks indexOf: expr)]]].
	
	" no good guess came up, take the first "
	aBlock value: 1
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> connectorsFrom: anOriginalGrammar [

	^ (self kogiOutputFrom: anOriginalGrammar) caseOf: {
		['input_value'] -> ['this.setOutput(true, ''{1}'');' format: {self name}].
		['input_statement'] -> ['this.setPreviousStatement(true, ''{1}'');
this.setNextStatement(true, ''{1}'');' format: {self name}].
		['none'] -> ['']}
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> isFieldInput [

	^ self expression isFieldInput
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> jsonForPart: aBlock index: aNumber originalGrammar: anOriginalGrammar [

	| name |
	name := #name -> ('arg', aNumber).
	
	aBlock isIdentifier ifTrue: [
		^ aBlock isPrimitive
			ifTrue: [
				Dictionary newFrom: {
					#type -> (aBlock
						allBlocksDetect: [:b | b contents = 'digit']
						ifFound: [:r | 'field_number']
						ifNone: ['field_input']).
					name}]
			ifFalse: [Dictionary newFrom: {#type -> (aBlock associatedRule kogiOutputFrom: anOriginalGrammar). #check -> aBlock contents. name}]].
	
	aBlock isRepeatQuantifier ifTrue: [
		^ (SBGrammarTransformer supportsCardinality and: [aBlock expression isIdentifier not or: [aBlock expression isIdentifier and: [aBlock expression isLexical]]])
			ifTrue: [
				(Dictionary newFrom: {
					name.
					#type -> 'field_toggle'.
					#min -> (aBlock quantifier = $* ifTrue: [0] ifFalse: [1]).
					#max -> 900000000})
					addAll: (self messageAndPartsFrom: aBlock expression suffix: '' originalGrammar: anOriginalGrammar);
					yourself]
			ifFalse: [
				self assert: aBlock expression isIdentifier.
				Dictionary newFrom: {#type -> 'input_statement'. #check -> aBlock expression contents. name}]].
	
	aBlock isQuantifier ifTrue: [
		self assert: aBlock quantifier = $?.
		^ SBGrammarTransformer supportsCardinality
			ifTrue: [
				(Dictionary newFrom: {name. #type -> 'field_toggle'. #min -> 0. #max -> 1})
					addAll: (self messageAndPartsFrom: aBlock expression suffix: '' originalGrammar: anOriginalGrammar);
					yourself]
			ifFalse: [self jsonForPart: aBlock expression index: aNumber originalGrammar: anOriginalGrammar]].
	
	aBlock isAlternative ifTrue: [
		" TODO: self assert: (aBlock childSandblocks allSatisfy: #isTerminal)."
		^ Dictionary newFrom: {
			#type -> 'field_dropdown'.
			#options -> (aBlock childSandblocks collect: [:o | {o contents. o contents}]).
			name}].
	
	SBToggledCode comment: '' active: 0 do: {
		[
			aBlock isSequence ifTrue: [
				aBlock childSandblocksDo: [:child | self jsonForPart: child index: aNumber originalGrammar: anOriginalGrammar].
				^ self]]}.
	
	^ self error: 'not supported'
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> kogiColor [

	^ ((Random seed: self name identityHash) nextInt: 360) asString
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> kogiOutputFrom: anOriginalGrammar [

	self valueOfProperty: #kogiOutput ifPresentDo: [:val | ^ val].
	^ (SBGrammarTransformer
		originalRuleFor: self
		in: self parentSandblock
		from: anOriginalGrammar) allUsages
		ifNotEmpty: [:usages |
			(usages count: [:identifier | identifier parentSandblock isRepeatQuantifier]) > (usages count: [:identifier | identifier parentSandblock isRepeatQuantifier not])
				ifTrue: ['input_statement']
				ifFalse: ['input_value']]
		ifEmpty: ['none']
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> messageAndPartsFrom: aBlock suffix: aString originalGrammar: anOriginalGrammar [

	| parts fieldIndex |
	parts := aBlock isSequence ifTrue: [aBlock childSandblocks] ifFalse: [{aBlock}].
	fieldIndex := 0.
	^ {
		('message', aString) asSymbol -> ((parts collect: [:part | | process |
			process := [:b |
				b isTerminal ifTrue: [b contents] ifFalse: [
					b isSequence ifTrue: [b childSandblocksDo: process] ifFalse: [
						fieldIndex := fieldIndex + 1.
						'%', fieldIndex]]].
			process value: part]) joinSeparatedBy: ' ').
		('args', aString) asSymbol -> ((parts select: [:part | part isTerminal not]) collectWithIndex: [:part :index | self jsonForPart: part index: index originalGrammar: anOriginalGrammar])}
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> partDeclarationFor: aBlock from: anOriginalGrammar [

	| color props |
	color := self kogiColor.
	
	SBToggledCode comment: '' active: 0 do: {
		[(aBlock isIdentifier and: [aBlock isSimple]) ifTrue: [^ 'this.jsonInit({message0: "%1", args0: [{type: "field_input", name: "arg1"}])']]}.
	SBToggledCode
		comment: 'meant to detect alternatives that can be reduced to only a text field but not very reliable atm'
		active: 1
		do: {
			[
				aBlock isFieldInput ifTrue: [
					^ aBlock isTerminal
						ifTrue: ['this.jsonInit(\{message0: "{1}", colour: "{2}"})' format: {aBlock contents. color}]
						ifFalse: [ | label hadField |
							hadField := false.
							label := ((aBlock allBlocksSelect: [:b | b isTerminal or: [b isIdentifier]]) collect: [:b |
								b isTerminal
									ifTrue: [
										(b parentSandblock isAlternative not or: [b parentSandblock childSandblocks noneSatisfy: #isSimple])
											ifTrue: [b contents]
											ifFalse: ['']]
									ifFalse: [
										hadField
											ifFalse: [
												hadField := true.
												'%1']
											ifTrue: ['']]]) joinSeparatedBy: ''.
							hadField ifFalse: [label := label, ' %1'].
							
							'this.jsonInit(\{message0: "{1}", args0: [\{type: "field_input", name: "arg1"}], colour: "{2}"})' format: {label. color}]]]}.
	
	props := (Dictionary newFrom: {#colour -> color})
		addAll: (self messageAndPartsFrom: aBlock suffix: '0' originalGrammar: anOriginalGrammar);
		yourself.
	((props at: #args0) anySatisfy: [:arg | (arg at: #type) = 'field_toggle']) ifTrue: [props at: #mutator put: 'optional_mutator'].
	^ 'this.jsonInit({1})' format: {props asJsonString}
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> prefillBlockDeclaration: aBlock original: anOriginalGrammar [

	^ String streamContents: [:stream | | slots |
		slots := (aBlock childSandblocks ifEmpty: [{aBlock}] ifNotEmpty: #yourself) select: [:b | b isTerminal not].
		slots doWithIndex: [:block :index | | slot |
			slot := nil.
			(block isIdentifier and: [block isPrimitive not]) ifTrue: [slot := block].
			(block isRepeatQuantifier and: [block expression isIdentifier and: [block expression isPrimitive not]]) ifTrue: [slot := block expression].
			slot ifNotNil: [ | rule |
				rule := SBToggledCode
					comment: ''
					active: 1
					do: {[slot associatedRule]. [anOriginalGrammar ruleNamed: slot contents ifNone: [slot associatedRule]]}.
				rule candidateForPrefillingDo: [:prefillIndex | | value |
					value := '<{1} type="{2}"></{1}>' format: {
						((rule expression childSandblocks at: prefillIndex)
							valueOfProperty: #inline
							ifAbsent: [false])
							ifTrue: ['block']
							ifFalse: ['shadow'].
						slot contents, prefillIndex}.
					(block isRepeatQuantifier and: [(rule kogiOutputFrom: anOriginalGrammar) = 'input_value'])
						ifTrue: [stream nextPutAll: ('<value name="{1}"><block type="rubber"><value name="NAME">{2}</value></block></value>' format: {'arg', index. value})]
						ifFalse: [stream nextPutAll: ('<value name="{1}">{2}</value>' format: {'arg', index. value})]]]]]
]

{ #category : #'*Sandblocks-Kogi' }
SBOhmRule >> toolboxDeclarationFrom: anOriginalGrammar [

	self isPrimitive ifTrue: [^ ''].
	^ '<category name="{1}" colour="{3}">
	{2}
</category>' format: {
		self name.
		((self expression isAlternative
			ifTrue: [self expression childSandblocks]
			ifFalse: [{self expression}]) withIndexCollect: [:block :index | '<block type="{1}">{2}</block>' format: {self name, index. self prefillBlockDeclaration: block original: anOriginalGrammar}]) joinSeparatedBy: String cr.
		self kogiColor}
]
