Class {
	#name : #SBColor,
	#superclass : #SBSubstitution,
	#instVars : [
		'indicator'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBColor class >> matches: aMessage [

	SBExample
		self: [SBColor]
		args: [{(SBMessageSend new receiver: (SBName contents: 'Color') selector: #orange)}]
		label: 'matching'.
	SBExample
		self: [SBColor]
		args: [{(SBMessageSend new receiver: (SBName contents: 'Color') selector: #fromUser)}]
		label: 'non matching'.
		
	(aMessage receiver isBinding and: [#('Color' 'ECSColor') includes: aMessage receiver contents]) ifFalse: [^ false].
	^ aMessage selector asSymbol isUnary
		ifTrue: [
			(Color respondsTo: aMessage selector asSymbol)
				and: [#('named colors' 'named colors - crayons') includes: (Color class organization categoryOfElement: aMessage selector asSymbol)]]
		ifFalse: [(aMessage selector = 'r:g:b:' or: [aMessage selector = 'r:g:b:a:']) and: [aMessage arguments allSatisfy: #isLiteralBlock]]
]

{ #category : #'as yet unclassified' }
SBColor class >> newFrom: aMessage [

	^ self new colorContents: (Color perform: aMessage selector asSymbol withArguments: (aMessage arguments collect: [:arg | arg contents asNumber] as: Array))
]

{ #category : #'as yet unclassified' }
SBColor >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBColor >> click: anEvent [

	super click: anEvent
]

{ #category : #'as yet unclassified' }
SBColor >> colorContents: aColor [

	indicator color: aColor
]

{ #category : #'as yet unclassified' }
SBColor >> colorContentsUpdate: aColor [

	self colorContents: aColor.
	self sandblockEditor batchedChangeStep: self
]

{ #category : #'as yet unclassified' }
SBColor >> doubleClick: anEvent [

	self flag: #todo. " we dont know when we're closed so we can't create a proper command for undo "
	(NewColorPickerMorph on: self originalColor: indicator color setColorSelector: #colorContentsUpdate:) openNear: self
]

{ #category : #'as yet unclassified' }
SBColor >> guessedClass [

	^ Color
]

{ #category : #'as yet unclassified' }
SBColor >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 withScalingFactor;
		addMorphBack: (indicator := Morph new
			extent: 16 asPoint * self scalingFactor;
			color: Color red)
]

{ #category : #'as yet unclassified' }
SBColor >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBColor >> printOn: aStream [

	indicator color printOn: aStream
]

{ #category : #'as yet unclassified' }
SBColor >> writeSourceOn: aStream [

	aStream nextPut: $(.
	indicator color printOn: aStream.
	aStream nextPut: $)
]
