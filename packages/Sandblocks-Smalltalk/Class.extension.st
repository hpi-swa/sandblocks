Extension { #name : #Class }

{ #category : #'*Sandblocks-Smalltalk-suggestions' }
Class >> sandblocksMetaSuggestionsFor: aBlock [
	"May be overridden by subclasses. The answered suggestions will appear as class-side selectors for the class."

	^ Array streamContents: [:stream | self theMetaClass withAllSuperclassesDo: [:class | stream nextPutAll: class selectors sorted]]
]
