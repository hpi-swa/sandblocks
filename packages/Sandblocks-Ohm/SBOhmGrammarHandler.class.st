Class {
	#name : #SBOhmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> insertStatementAboveOrBelow: aBoolean [

	self block containingStatement insertElement: aBoolean not
]

{ #category : #'as yet unclassified' }
SBOhmGrammarHandler >> newNullBock [

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
					do: [:outer :inner | outer connect: 'OR' expressions: {inner. self newNullBock}]
					with: SBOhmList new]].
	char = Character space ifTrue: [
		^ aBlock parentSandblock isSequence
			ifTrue: [aBlock insertElement: ActiveEvent shiftPressed not]
			ifFalse: [
				self
					wrap: aBlock
					do: [:outer :inner | outer connect: 'AND' expressions: {inner. self newNullBock}]
					with: SBOhmList new]].
	(#($+ $* $?) includes: char) ifTrue: [
		self
			wrap: aBlock
			do: [:outer :inner | outer expression: inner quantifier: char]
			with: SBOhmQuantifier new]
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
		do: [:outer :inner | outer connect: 'OR' expressions: {inner. self newNullBock label: 'expr'}]
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
