Class {
	#name : #SBPalettePreviewContainer,
	#superclass : #SBSelection,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	self flag: #fixme. " may break things catastrophically "
	
	(block isDeclaration and: [block isBlockBinding and: [block parentSandblock isBlockBody]]) ifTrue: [^ nil].
	
	^ aBlock value: SBUnknown new
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> filterEvent: anEvent for: aMorph [

	(anEvent isMouse and: [anEvent isMouseWheel not and: [self bounds containsPoint: anEvent position]]) ifTrue: [
		anEvent sentTo: self.
		^ anEvent wasHandled: true].
	
	^ anEvent wasHandled: false
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> initialize [

	super initialize.
	
	self
		useAlgebraLayout;
		hResizing: #shrinkWrap;
		addMouseCaptureFilter: self
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> intoWorld: aWorld [

	super intoWorld: aWorld.
	
	self clearCache
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> label: aString [

	self balloonText: aString
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> parentSandblock [

	^ self owner ifNotNil: #containingSandblock
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> pickUp: anEvent [

	| editor |
	editor := self sandblockEditor.
	
	anEvent hand grabMorph: (SBSelection new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		color: (self sandblockBlockColorIfAbsent: [Color white]);
		addMorphBack: self firstSubmorph veryDeepCopy;
		yourself)
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> sandblockBlockColorIfAbsent: aBlock [

	^ self firstSubmorph preferredColor ifNil: [Color white]
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> sandblockEditor [

	^ self owner ifNotNil: #sandblockEditor
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> saveTryFixing: aFixBoolean quick: aQuickBoolean [

	^ false
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> wantsDroppedMorph: aMorph event: evt [

	^ false
]
