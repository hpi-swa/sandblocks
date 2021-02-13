Class {
	#name : #SBPreferences,
	#superclass : #Object,
	#classVars : [
		'DrawOnCanvas',
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
	^ DrawOnCanvas ifNil: [true]
]

{ #category : #accessing }
SBPreferences class >> drawOnCanvas: aBoolean [

	DrawOnCanvas := aBoolean
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