Class {
	#name : #SBPalettePreviewContainer,
	#superclass : #SBSelection,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> binding: aString for: block class: aClass ifPresent: aBlock [

	self flag: #fixme. " may break things catastrophically "
	^ aBlock value: SBUnknown new
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> filterEvent: anEvent for: aMorph [

	anEvent isMouse ifTrue: [
		anEvent sentTo: self.
		^ anEvent wasHandled: true].
	
	^ anEvent wasHandled: false; ignore
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
SBPalettePreviewContainer >> pickUp: anEvent [

	| editor |
	editor := self sandblockEditor.
	
	anEvent hand grabMorph: (SBSelection new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		addMorphBack: self firstSubmorph veryDeepCopy;
		yourself)
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> sandblockBlockColorIfAbsent: aBlock [

	^ Color r: 0.271 g: 0.682 b: 0.851
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> sandblockEditor [

	^ self owner ifNotNil: #sandblockEditor
]

{ #category : #'as yet unclassified' }
SBPalettePreviewContainer >> wantsDroppedMorph: aMorph event: evt [

	^ false
]
