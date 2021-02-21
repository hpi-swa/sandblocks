Class {
	#name : #SBStateMachineTransitionCondition,
	#superclass : #SBBlock,
	#instVars : [
		'type'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> changeType [
	<action>

	| index newType block |
	
	index := UIManager default chooseFrom: {'Time'. 'Condition'. 'Signal'}.
	
	index < 1 ifTrue: [^ self].
	newType := #(#time #condition #signal) at: index.
	block := newType caseOf: {
		[#time] -> ['1 second' parseAsSandblock].
		[#condition] -> [SBStBlockBody empty].
		[#signal] -> [SBStSymbol new contents: 'signal']
	}.
	self sandblockEditor do: (SBCombinedCommand newWith: {
		(SBMutatePropertyCommand newFor: self containingArtefact)
			selector: #type;
			target: self;
			value: newType.
		(SBReplaceCommand newFor: self containingArtefact)
			replacer: block;
			target: self lastSubmorph
	})
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> childSandblocksDo: aBlock [

	aBlock value: self lastSubmorph
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> initialize [

	super initialize.
	
	self
		useAlgebraLayout;
		hResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> isSmalltalk [

	^ true
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> isTransitionCondition [

	^ true
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {self submorphs first layoutCommands. SBAlgebraCommand gap. self submorphs second layoutCommands}
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> object [

	
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> objectInterfaceAt: aNumber adding: aBoolean [

	aBoolean ifTrue: [^ SBInterfaces never].
	
	^ SBInterfaces stExpression
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> type: aSymbol [

	type := aSymbol.
	self updateIcon
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> type: aSymbol data: aBlock [

	type := aSymbol.
	
	self
		addMorphBack: Morph new;
		addMorphBack: aBlock;
		updateIcon
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> updateIcon [

	self firstSubmorph replaceBy: (type caseOf: {[#time] -> [SBIcon iconClock_o]. [#condition] -> [SBIcon iconCheck]. [#signal] -> [SBIcon iconFlash]}) large
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> updatePCFrom: aBlock [
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> valid [

	^ type caseOf: {
		[#time] -> [self lastSubmorph isMessageSend].
		[#condition] -> [self lastSubmorph isBlockBody].
		[#signal] -> [self lastSubmorph isSymbolBlock or: [self lastSubmorph isUnknown]]
	}
]

{ #category : #'as yet unclassified' }
SBStateMachineTransitionCondition >> writeSourceOn: aStream [

	aStream nextPutAll: (type caseOf: {[#time] -> [' after: ']. [#condition] -> [' if: ']. [#signal] -> [' when: ']}).
	self lastSubmorph writeSourceOn: aStream
]
