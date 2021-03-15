Class {
	#name : #SBScmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'block creation' }
SBScmGrammarHandler >> newCommentBlock [

	^ SBLabel new
		grammarHandler: self;
		delimiter: #(';' nil);
		yourself
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
		
		(aCharacter isLetter or: [aCharacter isSpecial or: [aCharacter = $#]]) ifTrue: [^ self replace: aBlock with: (SBScmIdentifier new contents: aCharacter asString)].
		
		aCharacter = $; ifTrue: [
			^ self replace: aBlock with: self newCommentBlock]].
	
	aCharacter = Character space ifTrue: [
		^ ActiveEvent shiftPressed
			ifTrue: [aBlock insertElementBefore]
			ifFalse: [aBlock insertElementAfter]].
	
	aCharacter = $) ifTrue: [^ aBlock parentSandblock insertElementAfter deleteIfDismissed: true]
]

{ #category : #actions }
SBScmGrammarHandler >> splitSExpr [
	<action>
	<inputAction>

	| newExpr newChildren |
	self block parentSandblock isSExpr ifFalse: [^ self].
	
	self block childIndex = self block parentSandblock childSandblocks size ifTrue: [^ self block parentSandblock insertElementAfter deleteIfDismissed: true].
	
	newExpr := SBScmExpression new.
	newChildren := self block parentSandblock childSandblocks
		copyFrom: self block childIndex + 1
		to: self block parentSandblock childSandblocks size.
	
	self block sandblockEditor do: (SBCombinedCommand newWith: {
		(SBInsertCommand newFor: self block containingArtefact)
			container: self block parentSandblock parentSandblock;
			index: self block parentSandblock childIndex + 1;
			morph: newExpr}, (newChildren collectWithIndex: [:child :index |
		(SBMoveCommand newFor: self block containingArtefact)
			morph: child;
			index: index;
			container: newExpr])).
	
	self block sandblockEditor maybeStartInputFromStart
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
			wrap: [:outer :inner | outer addMorphBack: inner]).
	
	self block sandblockEditor maybeStartInputFromStart
]

{ #category : #printing }
SBScmGrammarHandler >> writeSourceOn: aStream for: aBlock [

	aBlock writeScmSourceOn: aStream
]
