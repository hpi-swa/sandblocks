"
A SBDragHelper takes direct user input events via SBEditor>>#filterEvent:for: and interprets them on the block hierarchy for dropping. When a drag is initiated, it will take a snapshot of the bounds of all submorphs in the editor and compare drop locations against this cached view, such that inserting a preview of a dropped morph will still result in stable layouting.
"
Class {
	#name : #SBDragHelper,
	#superclass : #Object,
	#instVars : [
		'editor',
		'currentDropLocation',
		'morph',
		'onLeave',
		'blockBounds',
		'onApply',
		'floatingMorphs'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDragHelper class >> for: anEvent in: anEditor [

	| helper |
	helper := self new editor: anEditor.
	
	(helper morph: anEvent hand firstSubmorph) ifFalse: [^ nil].
	
	^ helper
]

{ #category : #'as yet unclassified' }
SBDragHelper >> applyHint [

	onLeave ifNotNil: [onLeave value].
	onApply ifNotNil: [onApply value]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> blockAtPoint: aPoint [

	| best bestArea |
	best := nil.
	bestArea := 900000000.
	
	blockBounds keysAndValuesDo: [:block :bounds |
		((bounds containsPoint: aPoint) and: [bounds area < bestArea]) ifTrue: [
			best := block.
			bestArea := bounds area]].
	
	^ best ifNotNil: #containingSandblock
]

{ #category : #'as yet unclassified' }
SBDragHelper >> boundsOf: aMorph [

	^ blockBounds at: aMorph
]

{ #category : #'as yet unclassified' }
SBDragHelper >> closestAdjacentTo: aPoint in: aMorph do: aBlock [

	^ self submorphOf: aMorph closestTo: aPoint do: [:candidate :before |
		aBlock
			value: (candidate ifNotNil: [ | block |
				block := candidate containingSandblock.
				block = aMorph ifTrue: [nil] ifFalse: [block]])
			value: before]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> delete [

	self dropLocation: #(#none nil)
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocation: dropLocation [

	currentDropLocation ifNotNil: [
		onLeave ifNotNil: [
			onLeave value.
			onLeave := nil]].
	
	currentDropLocation := dropLocation.
	
	dropLocation ifNotNil: [
		dropLocation first = #insert ifTrue: [
			morph
				convertedFor: (dropLocation second
					objectInterfaceNear: dropLocation third
					at: (dropLocation fourth ifTrue: [#before] ifFalse: [#after]))
				do: [:res |
					self hintInsertWith: (currentDropLocation second
						insertCommandRequest: res
						near: dropLocation third
						before: dropLocation fourth)]].
		dropLocation first = #replace ifTrue: [
			morph
				convertedFor: dropLocation second objectInterface
				do: [:res | self hintReplaceOf: dropLocation second with: res]]].
	
	self ensurePositionOfFloats
]

{ #category : #'as yet unclassified' }
SBDragHelper >> editor: anEditor [

	editor := anEditor.
	
	blockBounds := Dictionary new.
	floatingMorphs := OrderedCollection new.
	anEditor allMorphsDo: [:morph |
		morph ~= anEditor ifTrue: [blockBounds at: morph put: morph boundsInWorld].
		(morph isSandblock and: [morph floating]) ifTrue: [floatingMorphs add: morph]]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> ensurePositionOfFloats [
	"floating elements may have been pushed around, fix their positions"

	floatingMorphs do: [:morph |
		blockBounds at: morph ifPresent: [:fixedBounds | | localBounds |
			localBounds := morph bounds: fixedBounds from: editor world.
			morph bounds ~= localBounds ifTrue: [morph bounds: localBounds]]]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintInsertWith: aCommand [

	aCommand do.
	onApply := [editor do: aCommand].
	onLeave := [aCommand undo]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintReplaceOf: aMorph with: newBlock [

	aMorph attachDecorator: (SBDropPreviewDecorator new outline: true).
	onLeave := [aMorph detachDecorators: SBDropPreviewDecorator].
	onApply := [
		editor do: ((SBReplaceCommand newOrEditFor: aMorph containingArtefact)
			target: aMorph;
			replacer: newBlock)]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> initialize [

	currentDropLocation := #(#none nil)
]

{ #category : #'as yet unclassified' }
SBDragHelper >> morph: aMorph [

	((aMorph isSandblock and: [aMorph isSelection]) or: [aMorph isKindOf: TransferMorph]) ifFalse: [^ false].
	
	morph := aMorph unpackSelection.
	^ true
]

{ #category : #'as yet unclassified' }
SBDragHelper >> mouseMove: anEvent [

	| blockAtCursor dropLocation |
	blockAtCursor := self blockAtPoint: anEvent position.
	
	dropLocation := blockAtCursor
		ifNotNil: [
			blockAtCursor fixedNumberOfChildren
				ifTrue: [{#replace. blockAtCursor}]
				ifFalse: [
					self
						closestAdjacentTo: anEvent position
						in: blockAtCursor
						do: [:adjacent :before | {#insert. blockAtCursor. adjacent. before}]]]
		ifNil: [#(#none nil)].
	
	(currentDropLocation hasEqualElements: dropLocation) ifFalse: [self dropLocation: dropLocation]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> submorphOf: aMorph closestTo: aPoint do: aBlock [

	| before best bestDistance |
	before := false.
	best := nil.
	bestDistance := 900000000.
	
	aMorph submorphs do: [:morph | | distance |
		blockBounds at: morph ifPresent: [:bounds |
			distance := bounds topLeft dist: aPoint.
			distance < bestDistance ifTrue: [
				best := morph.
				before := true.
				bestDistance := distance].
			
			distance := bounds bottomRight dist: aPoint.
			distance < bestDistance ifTrue: [
				best := morph.
				before := false.
				bestDistance := distance]]].
	
	^ aBlock value: best value: before
]
