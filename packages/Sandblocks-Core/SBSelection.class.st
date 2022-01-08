"
A SBSelection is a container that wraps copied statements.
"
Class {
	#name : #SBSelection,
	#superclass : #SBBlock,
	#instVars : [
		'colorPolicy',
		'methodClass',
		'homeArtefact',
		'sourceBlock',
		'onAbortUndoIn'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelection >> abortDrag: anEvent [

	self onAbortUndoIn ifNotNil: [:editor |
		editor undo.
		editor handleDropCancelMorph: self].
	
	self delete
]

{ #category : #'as yet unclassified' }
SBSelection >> aboutToBeGrabbedBy: aHand [

	super aboutToBeGrabbedBy: aHand.
	self align: self fullBounds topLeft with: aHand position + (aHand extent // 3).
	aHand newKeyboardFocus: self
]

{ #category : #'as yet unclassified' }
SBSelection >> addedMorph: aMorph [

	aMorph isSandblock ifTrue: [
		aMorph allBlocksDo: [:block |
			block
				detachDecorators: SBMultiSelectionDecorator;
				stopEditing]]
]

{ #category : #'as yet unclassified' }
SBSelection >> binding: aString for: block class: aClass ifPresent: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> blockForClass: aClass ifPresent: aBlock ifAbsent: anotherBlock [

	anotherBlock value
]

{ #category : #'as yet unclassified' }
SBSelection >> color [

	^ color
]

{ #category : #'as yet unclassified' }
SBSelection >> colorPolicy [

	^ colorPolicy ifNil: [super colorPolicy]
]

{ #category : #'as yet unclassified' }
SBSelection >> colorPolicy: aPolicy [

	colorPolicy := aPolicy
]

{ #category : #'as yet unclassified' }
SBSelection >> cursor [

	^ SBBlockCursor new editor: self
]

{ #category : #'as yet unclassified' }
SBSelection >> drawnColor [

	^ self sandblockBlockColorIfAbsent: [Color white]
]

{ #category : #'as yet unclassified' }
SBSelection >> evaluate [

	^ self submorphCount = 1
		ifTrue: [self firstSubmorph evaluate]
		ifFalse: [self submorphs collect: #evaluate]
]

{ #category : #'as yet unclassified' }
SBSelection >> evaluationContext [

	^ self homeArtefact ifNotNil: #evaluationContext ifNil: [nil]
]

{ #category : #'as yet unclassified' }
SBSelection >> evaluationReceiver [

	^ self homeArtefact ifNotNil: #evaluationReceiver ifNil: [nil]
]

{ #category : #'as yet unclassified' }
SBSelection >> handlesKeyboard: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> hasUnsavedChanges: anArtefact [

	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> homeArtefact [

	^ homeArtefact
]

{ #category : #'as yet unclassified' }
SBSelection >> homeArtefact: anObject [

	homeArtefact := anObject
]

{ #category : #'as yet unclassified' }
SBSelection >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap.
	
	self on: #keyStroke send: #keyStroke: to: self
]

{ #category : #'as yet unclassified' }
SBSelection >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> isBlockBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> isMethodBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> isSelection [

	^ true
]

{ #category : #'as yet unclassified' }
SBSelection >> isSingleArtefactView [

	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> keepForcesActivated [
	
	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> keyStroke: anEvent [
	"Abort the drag on an escape"

	anEvent keyCharacter = Character escape ifTrue: [self abortDrag: anEvent].
]

{ #category : #'as yet unclassified' }
SBSelection >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'as yet unclassified' }
SBSelection >> methodClass [
	
	^ methodClass ifNil: [nil class]
]

{ #category : #'as yet unclassified' }
SBSelection >> methodClass: aClass [
	
	methodClass := aClass
]

{ #category : #'as yet unclassified' }
SBSelection >> mode [

	^ #command
]

{ #category : #'as yet unclassified' }
SBSelection >> multiSelection [

	^ #()
]

{ #category : #'as yet unclassified' }
SBSelection >> object [

	self hasSubmorphs ifFalse: [^ nil].
	
	^ self submorphCount > 1
		ifTrue: [
			SBStBlockBody new statements: (self submorphs collect: [:morph | morph object])]
		ifFalse: [self firstSubmorph object]
]

{ #category : #'as yet unclassified' }
SBSelection >> onAbortUndoIn [

	^ onAbortUndoIn
]

{ #category : #'as yet unclassified' }
SBSelection >> onAbortUndoIn: aMorph [

	onAbortUndoIn := aMorph
]

{ #category : #'as yet unclassified' }
SBSelection >> parentSandblock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> rejectDropMorphEvent: anEvent [

	self abortDrag: anEvent
]

{ #category : #'as yet unclassified' }
SBSelection >> relatedClass [

	^ self methodClass
]

{ #category : #'as yet unclassified' }
SBSelection >> reportError: anError process: aProcess source: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBSelection >> sandblockEditor [

	^ self
]

{ #category : #'as yet unclassified' }
SBSelection >> selection [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> sourceBlock [

	^ sourceBlock
]

{ #category : #'as yet unclassified' }
SBSelection >> sourceBlock: aBlock [

	sourceBlock := aBlock
]

{ #category : #'as yet unclassified' }
SBSelection >> statements [

	^ #()
]

{ #category : #'as yet unclassified' }
SBSelection >> typeFor: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelection >> unpackSelection [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBSelection >> wantsInteractiveErrorCorrection [

	^ false
]

{ #category : #'as yet unclassified' }
SBSelection >> wantsToBeDroppedInto: aMorph [

	^ aMorph isSandblock
]

{ #category : #'as yet unclassified' }
SBSelection >> writeSourceOn: aStream [

	self submorphCount = 1
		ifTrue: [self firstSubmorph writeSourceOn: aStream]
		ifFalse: [
			aStream nextPut: ${.
			self submorphs do: [:m | m writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
			aStream nextPut: $}]
]
