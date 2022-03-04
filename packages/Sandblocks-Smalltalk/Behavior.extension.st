Extension { #name : #Behavior }

{ #category : #'*Sandblocks-Smalltalk-suggestions' }
Behavior >> sandblocksSuggestionsFor: aBlock [
	"May be overridden by subclasses."

	^ Array streamContents: [:stream | self withAllSuperclassesDo: [:class | stream nextPutAll: class selectors sorted]]
]
