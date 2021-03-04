Class {
	#name : #SBScmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Scheme'
}

{ #category : #actions }
SBScmGrammarHandler >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>

	| result |
	result := self block evaluate.
	self block containingArtefact ifNotNil: [
		self block containingArtefact cacheType: result class for: self block].
	
	result convertedFor: SBInterfaces topLevel do: [:morph |
		self block sandblockEditor openMorphInView: morph.
		morph focusAfterDelete: self block.
		self block sandblockEditor connectFrom: self block to: morph]
]

{ #category : #callbacks }
SBScmGrammarHandler >> perform: aCharacter for: aBlock empty: aBoolean [ 

	aBoolean ifTrue: [
		aCharacter = $' ifTrue: [^ self replace: aBlock with: SBScmSymbol new].
		aCharacter = Character space ifTrue: [^ self replace: aBlock with: SBEmptyLine new].
		aCharacter = $" ifTrue: [^ self replace: aBlock with: SBScmString new].
		
		aCharacter = $( ifTrue: [^ self replace: aBlock with: (SBScmExpression new in: [:e | e addMorphBack: e newNullBlock])].
		
		aCharacter = $# ifTrue: [^ self replace: aBlock with: SBScmBoolean new].
		
		(aCharacter isDigit or: [aCharacter = $-]) ifTrue: [^ self replace: aBlock with: (SBScmNumber new contents: aCharacter asString)].
	
		(aCharacter isAlphabetic or: [aCharacter isSpecial or: [aCharacter = $#]]) ifTrue: [^ self replace: aBlock with: (SBScmIdentifier new contents: aCharacter asString)]].

	aCharacter = Character space ifTrue: [
		^ aBlock insertElementAfter].
	
	aCharacter = $) ifTrue: [
		^ (aBlock parentSandblock insertElementAfter) deleteIfDismissed: true]
]

{ #category : #actions }
SBScmGrammarHandler >> wrapAsArgument [
	<action>
	
	self block insertElementBefore
]

{ #category : #actions }
SBScmGrammarHandler >> wrapInMessageSend [
	<action>	
	<actionValidIf: #isExpression>
	
	self block insertElementAfter
]

{ #category : #actions }
SBScmGrammarHandler >> wrapInSExpr [
	<action>
	<inputAction>
	
	self block sandblockEditor
		do: ((SBWrapCommand newFor: self block containingArtefact)
			outer: SBScmExpression new;
			inner: self block;
			wrap: [:outer :inner | outer addMorphBack: inner])
]
