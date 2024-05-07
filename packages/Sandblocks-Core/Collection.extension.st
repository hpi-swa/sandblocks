Extension { #name : #Collection }

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asBarChart: converter [
	<convert>
	
	converter
		if: [self allSatisfy: SBBarChart supportedInterface]
		do: [SBBarChart newWithValues: self]
]

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asCollectionView: converter [
	<convert>
	
	converter
		if: [self size < 20 and: [self isString not and: [self isDictionary not]]]
		do: [SBCollection new interface: converter objectInterface object: self]
]

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asLineChart: converter [
	<convert>
	
	converter
		if: [self allSatisfy: SBLineChart supportedInterface]
		do: [SBLineChart newWithValues: self]
]

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asRectangleChart: converter [
	<convert>
	
	converter
		if: [self allSatisfy: SBRectangleChart supportedInterface]
		do: [SBRectangleChart newWithValues: self]
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

{ #category : #'*Sandblocks-Core' }
Collection >> matchesEvent: anEvent mode: aSymbol [

	^ self anySatisfy: [:shortcut | shortcut matchesEvent: anEvent mode: aSymbol]
]
