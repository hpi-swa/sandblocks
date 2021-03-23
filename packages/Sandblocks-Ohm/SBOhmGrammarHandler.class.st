Class {
	#name : #SBOhmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Ohm'
}

{ #category : #actions }
SBOhmGrammarHandler >> extractVariable [
	<action>
	<actionValidIf: #isExpression>

	| name insert |
	name := (UIManager default request: 'Name for rule?') ifEmpty: [^ self].
	
	insert := self block containingArtefact
		insertCommandRequest: false
		near: self block containingStatement.
	
	self block sandblockEditor do: (SBCombinedCommand newWith: {
		(SBReplaceCommand newFor: self block containingArtefact)
			target: self block;
			replacer: (SBOhmIdentifier new contents: name).
		insert.
		(SBReplaceCommand newFor: self block containingArtefact)
			target: insert morph;
			replacer: (SBOhmRule new name: name alternatives: self block veryDeepCopy postDuplicate)})
]

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> insertStatementAboveOrBelow: aBoolean [

	self block containingStatement insertElement: aBoolean not
]

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> newNullBlock [

	^ SBUnknown new grammarHandler: self
]

{ #category : #callbacks }
SBOhmGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	char isLetter ifTrue: [^ self replace: aBlock with: (SBOhmIdentifier new contents: char asString)].
	char = $" ifTrue: [^ self replace: aBlock with: (SBOhmTerminal new contents: aBlock contents)].
	char = $| ifTrue: [
		^ aBlock parentSandblock isAlternative
			ifTrue: [aBlock insertElementAfter]
			ifFalse: [
				self
					wrap: aBlock
					do: [:outer :inner | outer connect: 'OR' expressions: {inner. self newNullBlock}]
					with: SBOhmList new]].
	char = Character space ifTrue: [
		^ aBlock parentSandblock isSequence
			ifTrue: [aBlock insertElement: ActiveEvent shiftPressed not]
			ifFalse: [
				self
					wrap: aBlock
					do: [:outer :inner |
						outer connect: 'AND' expressions: (ActiveEvent shiftPressed
							ifTrue: [{self newNullBlock. inner}]
							ifFalse: [{inner. self newNullBlock}])]
					with: SBOhmList new]].
	(#($+ $* $?) includes: char) ifTrue: [
		self
			wrap: aBlock
			do: [:outer :inner | outer expression: inner quantifier: char]
			with: SBOhmQuantifier new].
	(#($~ $&) includes: char) ifTrue: [
		self
			wrap: aBlock
			do: [:outer :inner | outer expression: inner predicate: char]
			with: SBOhmPredicate new]
]

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> wrap: aBlock do: aWrapBlock with: aNode [

	super wrap: aBlock do: aWrapBlock with: aNode.
	aNode inputNextUnknown
]

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> wrapInAlternative [
	<action>
	<actionValidIf: #isExpression>

	self block parentSandblock isAlternative ifTrue: [^ self block insertElementAfter].
	self
		wrap: self block
		do: [:outer :inner | outer connect: 'OR' expressions: {inner. self newNullBlock label: 'expr'}]
		with: SBOhmList new
]

{ #category : #actions }
SBOhmGrammarHandler >> wrapInOptional [
	<action>
	<actionValidIf: #isExpression>

	self
		wrap: self block
		do: [:outer :inner | outer expression: inner quantifier: $?]
		with: SBOhmQuantifier new
]

{ #category : #actions }
SBOhmGrammarHandler >> wrapInPlus [
	<action>
	<actionValidIf: #isExpression>

	self
		wrap: self block
		do: [:outer :inner | outer expression: inner quantifier: $+]
		with: SBOhmQuantifier new
]

{ #category : #actions }
SBOhmGrammarHandler >> wrapInStar [
	<action>
	<actionValidIf: #isExpression>

	self
		wrap: self block
		do: [:outer :inner | outer expression: inner quantifier: $*]
		with: SBOhmQuantifier new
]
