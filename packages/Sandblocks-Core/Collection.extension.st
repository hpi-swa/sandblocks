Extension { #name : #Collection }

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asCollectionView: converter [
	<convert>
	
	converter
		if: [self size < 20]
		do: [SBCollection new object: self]
]

{ #category : #'*Sandblocks-Core' }
Collection >> asSandblockShortcut [

	^ self
]

{ #category : #'*Sandblocks-Core' }
Collection >> includesRepresentation: aSymbol [

	^ self includes: aSymbol
]

{ #category : #'*Sandblocks-Core' }
Collection >> matchesEvent: anEvent [

	^ self anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]
]
