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
	<convertPriority: 10>

	converter do: [SBStClass newFor: self at: 0 @ 0]
]

{ #category : #'*Sandblocks-Core-converting' }
Behavior >> openFull: converter [
	<convert>
	<convertPriority: 5>

	converter do: [SBStClassMethodEditor new class: self]
]
