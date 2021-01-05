Class {
	#name : #SBScmGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Scheme'
}

{ #category : #helper }
SBScmGrammarHandler >> perform: aCharacter for: aBlock empty: aBoolean [ 

	aBoolean ifTrue: [
		aCharacter = $' ifTrue: [^ self replace: aBlock with: SBScmSymbol new].
		
		aCharacter = $( ifTrue: [^ self replace: aBlock with: (SBScmExpression new in: [:e | e addMorphBack: e newNullBlock])].
	
		(aCharacter isAlphabetic or: [aCharacter isSpecial]) ifTrue: [^ self replace: aBlock with: (SBScmIdentifier new contents: aCharacter asString)].
	
		aCharacter isDigit ifTrue: [^ self replace: aBlock with: (SBScmNumber new contents: aCharacter asString)]].

	aCharacter = Character space ifTrue: [
		^ aBlock insertElementAfter].
	
	aCharacter = $) ifTrue: [
		^ (aBlock parentSandblock insertElementAfter) deleteIfDismissed: true].
]
