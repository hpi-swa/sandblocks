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
SBPalettePreviewContainer >> insertCursorAfter: aMorph [

	| afterSelf referenceBlock |
	afterSelf := false.
	referenceBlock := aMorph firstBlock.
	aMorph parentSandblock cursorPositionsDo: [:c |
		c block = referenceBlock ifTrue: [afterSelf := true].
		(afterSelf and: [c isInsert and: [c container ~= aMorph and: [(c container hasOwner: aMorph) not]]]) ifTrue: [^ self sandblockEditor cursor cursorPosition: c explicitMove: true axis: #none]]
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
	
	anEvent hand grabMorph: (SBDragContainer new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		color: (self sandblockBlockColorIfAbsent: [Color r: 1 g: 1 b: 1]);
		addMorphBack: self firstSubmorph veryDeepCopy;
		yourself)
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

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> wasSelected [

	self sandblockEditor select: nil
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> wasSelectedFromCursor: aCursorPosition [

	super wasSelectedFromCursor: aCursorPosition.
	
	aCursorPosition mode = #insert ifTrue: [
		aCursorPosition command canInsert: self firstSubmorph do: [:morph |
			aCursorPosition command
				morph: morph;
				do.
			Project current addDeferredUIMessage: [
				SBToggledCode comment: '' active: 1 do: {
					[self insertCursorAfter: morph].
					[morph firstBlock select].
					[
						self sandblockEditor cursor
							cursorPosition: aCursorPosition
							explicitMove: true
							axis: #none]}]]]
]
