"
A SBDragHelper takes direct user input events via SBEditor>>#filterEvent:for: and interprets them on the block hierarchy for dropping. When a drag is initiated, it will take a snapshot of the bounds of all submorphs in the editor and compare drop locations against this cached view, such that inserting a preview of a dropped morph will still result in stable layouting.

Note that we have a preference (SBPreferences>>previewDropInsert) that indicates whether to show our insertion point as proper block or as a simple line.
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
		'floatingMorphs',
		'onMove',
		'transferContainer'
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
SBDragHelper >> applyHintAt: anEvent [

	onLeave ifNotNil: [onLeave value].
	onMove := nil.
	transferContainer applyDrag.
	^ onApply
		ifNotNil: [
			onApply cull: anEvent.
			true]
		ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> blockAtPoint: aPoint [

	| best bestArea |
	best := nil.
	bestArea := 900000000.
	
	SBPreferences previewDropInsert
		ifFalse: [
			editor morphsAt: aPoint unlocked: true do: [:morph |
				morph bounds area < bestArea ifTrue: [
					best := morph.
					bestArea := morph bounds area]]]
		ifTrue: [
			blockBounds keysAndValuesDo: [:block :bounds |
				((bounds containsPoint: aPoint) and: [bounds area < bestArea]) ifTrue: [
					best := block.
					bestArea := bounds area]]].
	
	^ best ifNotNil: #containingSandblock
]

{ #category : #'as yet unclassified' }
SBDragHelper >> boundsOf: aMorph ifPresent: aBlock [

	^ blockBounds
		ifNotNil: [blockBounds at: aMorph ifPresent: aBlock]
		ifNil: [aBlock value: aMorph boundsInWorld]
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
SBDragHelper >> dragCancelled [

	onLeave value.
	onLeave := nil.
	onMove := nil.
	onApply := nil.
	self delete
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocation: dropLocation [

	currentDropLocation ifNotNil: [
		onLeave ifNotNil: [
			onLeave value.
			onLeave := nil]].
	
	currentDropLocation := dropLocation.
	
	dropLocation ifNotNil: [
		dropLocation first = #insert ifTrue: [self dropLocationForInsert: dropLocation].
		dropLocation first = #replace ifTrue: [self dropLocationForReplace: dropLocation].
		dropLocation first = #special ifTrue: [self dropLocationForSpecial: dropLocation]].
	
	SBPreferences previewDropInsert ifTrue: [self ensurePositionOfFloats]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocationForInsert: aDropLocation [

	self
		hintInsertOf: aDropLocation fifth
		in: currentDropLocation second
		near: aDropLocation third
		before: aDropLocation fourth
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocationForReplace: dropLocation [

	(morph isMorph and: [morph wrapsAround and: [morph satisfies: dropLocation second objectInterface]]) ifTrue: [
		dropLocation second convertedFor: morph copyPlaceholder objectInterface do: [:res |
			self hintWrap: morph around: dropLocation second as: res.
			^ true]].
	
	" try replace then "
	morph convertedFor: dropLocation second objectInterface do: [:res |
		self hintReplaceOf: dropLocation second with: res.
		^ true].
	
	^ false
]

{ #category : #'as yet unclassified' }
SBDragHelper >> dropLocationForSpecial: dropLocation [

	self hintReplaceOf: dropLocation second with: morph.
	onApply := [editor do: (dropLocation second specialDropCommand: morph)]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> editor: anEditor [

	editor := anEditor.
	
	SBPreferences previewDropInsert ifTrue: [
		blockBounds := Dictionary new.
		floatingMorphs := OrderedCollection new.
		anEditor allMorphsDo: [:morph |
			morph ~= anEditor ifTrue: [blockBounds at: morph put: morph boundsInWorld].
			(morph isSandblock and: [morph floating]) ifTrue: [floatingMorphs add: morph]]]
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
SBDragHelper >> hintInsertOf: aBlock in: aParentBlock near: aChildBlock before: aBoolean [

	| command insertPreviewMarker |
	command := aParentBlock insertCommandRequest: aBlock near: aChildBlock before: aBoolean.
	self assert: command notNil.
	SBPreferences previewDropInsert ifTrue: [command do] ifFalse: [
		insertPreviewMarker := SBDropInsertMarker new
			color: (aParentBlock colorPolicy dropMarkerColorFor: aBlock);
			bounds: (aChildBlock
				ifNil: [10 @ 10 center: aParentBlock boundsInWorld center]
				ifNotNil: [aChildBlock transformFromWorld transformRect: command hintBounds]);
			openInWorld].
	
	onMove := [:event | (aChildBlock notNil and: [insertPreviewMarker notNil and: [aChildBlock floating]]) ifTrue: [insertPreviewMarker center: event position]].
	onLeave := [
		SBPreferences previewDropInsert
			ifTrue: [command undo]
			ifFalse: [insertPreviewMarker delete]].
	onApply := [:event | | localPoint |
		localPoint := (editor canvas canvasTransform globalPointToLocal: event position) asIntegerPoint.
		command position: localPoint.
		editor do: command.
		aBlock inputContainedUnknown]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintReplaceOf: aMorph with: newBlock [

	aMorph attachDecorator: (SBDropPreviewDecorator new outline: true).
	onLeave := [aMorph detachDecorators: SBDropPreviewDecorator].
	onApply := [
		editor do: (SBReplaceCommand new
			target: aMorph;
			replacer: newBlock).
		newBlock inputContainedUnknown]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> hintWrap: draggedBlock around: anOldMorph as: aNewMorph [

	anOldMorph attachDecorator: (SBDropPreviewDecorator new outline: true).
	onLeave := [anOldMorph detachDecorators: SBDropPreviewDecorator].
	onApply := [
		editor do: (SBRecordedCommand new record: [:recorder |
			recorder replace: anOldMorph with: draggedBlock.
			recorder replace: draggedBlock copyPlaceholder with: aNewMorph]).
		draggedBlock inputContainedUnknown]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> initialize [

	currentDropLocation := #(#none nil)
]

{ #category : #'as yet unclassified' }
SBDragHelper >> morph: aMorph [

	((aMorph isSandblock and: [aMorph isSelection]) or: [aMorph isKindOf: TransferMorph]) ifFalse: [^ false].
	
	transferContainer := aMorph.
	morph := aMorph unpackSelection.
	^ true
]

{ #category : #'as yet unclassified' }
SBDragHelper >> mouseMove: anEvent [

	| blockAtCursor dropLocation |
	blockAtCursor := self blockAtPoint: anEvent position.
	
	dropLocation := blockAtCursor
		ifNotNil: [
			(blockAtCursor specialDropCommand: morph)
				ifNotNil: [{#special. blockAtCursor}]
				ifNil: [
					blockAtCursor fixedNumberOfChildren
						ifTrue: [{#replace. blockAtCursor}]
						ifFalse: [
							self closestAdjacentTo: anEvent position in: blockAtCursor do: [:adjacent :before |
								(morph
									convertedFor: (blockAtCursor
										objectInterfaceForDrop: morph
										near: adjacent
										at: (before ifTrue: [#before] ifFalse: [#after]))
									do: [:res | {#insert. blockAtCursor. adjacent. before. res}]) ifNil: [{#replace. blockAtCursor}]]]]]
		ifNil: [#(#none nil)].
	
	(currentDropLocation hasEqualElements: dropLocation) ifFalse: [self dropLocation: dropLocation].
	onMove ifNotNil: [onMove value: anEvent]
]

{ #category : #'as yet unclassified' }
SBDragHelper >> submorphOf: aMorph closestTo: aPoint do: aBlock [

	| before best bestDistance calcDistanceBefore calcDistanceAfter |
	before := false.
	best := nil.
	bestDistance := 900000000.
	
	aMorph hasHorizontalLayout
		ifTrue: [
			calcDistanceBefore := [:m | (m left - aPoint x) abs].
			calcDistanceAfter := [:m | (m right - aPoint x) abs]]
		ifFalse: [
			calcDistanceBefore := [:m | (m top - aPoint y) abs].
			calcDistanceAfter := [:m | (m bottom - aPoint y) abs]].
	
	aMorph childSandblocks do: [:morph | | distance |
		self boundsOf: morph ifPresent: [:bounds |
			distance := calcDistanceBefore value: bounds.
			distance < bestDistance ifTrue: [
				best := morph.
				before := true.
				bestDistance := distance].
			distance := calcDistanceAfter value: bounds.
			distance < bestDistance ifTrue: [
				best := morph.
				before := false.
				bestDistance := distance]]].
	
	^ aBlock value: best value: before
]
