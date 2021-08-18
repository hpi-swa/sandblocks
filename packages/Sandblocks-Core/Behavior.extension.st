Extension { #name : #Behavior }

{ #category : #'*Sandblocks-Core' }
Behavior >> lookupSelector: aSymbol upTo: aClass ifPresent: aBlock ifAbsent: anotherBlock [

	| lookupClass |
	lookupClass := self.
	[
		(lookupClass includesSelector: aSymbol) ifTrue: [^ aBlock value: (lookupClass compiledMethodAt: aSymbol)].
		lookupClass := lookupClass superclass
	] doWhileFalse: [lookupClass isNil or: [lookupClass = aClass]].
	^ anotherBlock value
]

{ #category : #'*Sandblocks-Core-converting' }
Behavior >> open: converter [
	<convert>
	
	converter do: [SBStClass newFor: self at: 0 @ 0]
]

{ #category : #'*Sandblocks-Core-converting' }
Behavior >> openFull: converter [
	<convert>
	
	converter do: [SBStClassMethodEditor new class: self]
]

{ #category : #'*Sandblocks-Core-suggestions' }
Behavior >> sandblocksSuggestionsFor: aBlock [
	"May be overriden by subclasses."

	^ Array streamContents: [:stream |
		self withAllSuperclassesDo: [:class |
			stream nextPutAll: class selectors sorted]]
]
