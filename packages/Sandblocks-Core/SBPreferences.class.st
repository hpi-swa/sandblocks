Class {
	#name : #SBPreferences,
	#superclass : #Object,
	#classVars : [
		'DrawOnCanvas',
		'PreviewDropInsert',
		'RightClickContextMenu'
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
