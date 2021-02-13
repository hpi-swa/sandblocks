Class {
	#name : #SBScmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Scheme'
}

{ #category : #helper }
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
