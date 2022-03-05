Extension { #name : #Metaclass }

{ #category : #'*Sandblocks-Smalltalk-suggestions' }
Metaclass >> sandblocksSuggestionsFor: aBlock [

	^ self theNonMetaClass sandblocksMetaSuggestionsFor: aBlock
]
