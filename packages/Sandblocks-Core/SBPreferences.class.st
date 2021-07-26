Class {
	#name : #SBPreferences,
	#superclass : #Object,
	#classVars : [
		'DrawOnCanvas',
		'EnableForceLayout',
		'PreviewDropInsert',
		'RightClickContextMenu',
		'ShowHoverDecorator'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBPreferences class >> drawOnCanvas [
	<preference: 'Left-click on canvas begins drawing'
	category: 'sandblocks'
	description: ''
	type: #Boolean>
	^ DrawOnCanvas ifNil: [false]
]

{ #category : #accessing }
SBPreferences class >> drawOnCanvas: aBoolean [

	DrawOnCanvas := aBoolean
]

{ #category : #accessing }
SBPreferences class >> enableForceLayout [
	<preference: 'Enable force-driven layout for blocks' category: 'sandblocks' description: '' type: #Boolean>

	^ EnableForceLayout ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBPreferences class >> enableForceLayout: aBoolean [

	EnableForceLayout := aBoolean
]

{ #category : #'as yet unclassified' }
SBPreferences class >> previewDropInsert [
	<preference: 'Preview block positions while dragging' category: 'sandblocks' description: 'Preview the block that would be inserted when dragging' type: #Boolean>

	^ PreviewDropInsert ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBPreferences class >> previewDropInsert: aBoolean [

	PreviewDropInsert := aBoolean
]

{ #category : #accessing }
SBPreferences class >> rightClickContextMenu [
	<preference: 'Right-click opens actions menu'
	category: 'sandblocks'
	description: 'Opens the actions menu on a right-clicked block. Disables right-click to move the canvas unless the canvas itself is clicked'
	type: #Boolean>
	^ RightClickContextMenu ifNil: [true]
]

{ #category : #accessing }
SBPreferences class >> rightClickContextMenu: aBoolean [
	
	RightClickContextMenu := aBoolean
]

{ #category : #accessing }
SBPreferences class >> showHoverDecorator [
	<preference: 'Show an outline around hovered blocks' category: 'sandblocks' description: 'Show an outline around the currently hovered block to help drag-and-drop' type: #Boolean>

	^ ShowHoverDecorator ifNil: [false]
]

{ #category : #accessing }
SBPreferences class >> showHoverDecorator: aBoolean [

	ShowHoverDecorator := aBoolean
]

{ #category : #'as yet unclassified' }
SBPreferences class >> useNewCursor [

	^ true
]
