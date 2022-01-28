Class {
	#name : #SBPopup,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPopup >> checkClose: aSelectedBlock [

	| editor |
	editor := self sandblockEditor ifNil: [^ self delete].
	aSelectedBlock ifNil: [^ self delete].
	((aSelectedBlock hasOwner: self) not and: [aSelectedBlock ~= self]) ifTrue: [^ self delete]
]

{ #category : #'as yet unclassified' }
SBPopup >> delete [

	self sandblockEditor ifNotNil: [:editor | editor removeActionsWithReceiver: self].
	super delete
]

{ #category : #'as yet unclassified' }
SBPopup >> initialize [

	super initialize.
	self
		changeTableLayout;
		listDirection: #leftToRight;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		color: (Color r: 1 g: 1 b: 1);
		layoutInset: 4;
		disableLayout: true;
		addDropShadow
]

{ #category : #'as yet unclassified' }
SBPopup >> morphicLayerNumber [

	^ 99
]

{ #category : #'as yet unclassified' }
SBPopup >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBPopup >> showBelow: aBlock closeOnDeselect: aBoolean [

	| editor |
	editor := aBlock sandblockEditor.
	self assert: editor notNil.
	aBlock ensureLayouted.
	self position: aBlock bottomLeft.
	editor openMorph: self.
	
	aBoolean ifTrue: [
		self select.
		editor when: #selectionChanged send: #checkClose: to: self]
]
