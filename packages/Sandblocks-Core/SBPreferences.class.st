Class {
	#name : #SBPreferences,
	#superclass : #Object,
	#classVars : [
		'DrawOnCanvas',
		'EdgePanSpeed',
		'EdgePanZone',
		'EnableForceLayout',
		'HideIndicators',
		'LargeInsets',
		'PreviewDropInsert',
		'RightClickContextMenu',
		'ShowHoverDecorator',
		'SuggestionsOnClick'
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
SBPreferences class >> edgePanSpeed [
	<preference: 'Edge Pan Speed' category: 'sandblocks' description: 'Speed at which the view will move when dragging a block near the edge of the screen.' type: #Number>
	
	^ EdgePanSpeed ifNil: [500]
]

{ #category : #accessing }
SBPreferences class >> edgePanSpeed: aNumber [
	EdgePanSpeed := aNumber
]

{ #category : #accessing }
SBPreferences class >> edgePanZone [
	<preference: 'Edge Pan Zone Size' category: 'sandblocks' description: 'From the edge of the editor, the length at which panning starts, as a divisor of the editors size' type: #Number>
	
	^ EdgePanZone ifNil: [16]
]

{ #category : #accessing }
SBPreferences class >> edgePanZone: aNumber [
	EdgePanZone := aNumber
]

{ #category : #accessing }
SBPreferences class >> enableForceLayout [
	<preference: 'Enable force-driven layout for blocks' category: 'sandblocks' description: '' type: #Boolean>

	^ EnableForceLayout ifNil: [true]
]

{ #category : #accessing }
SBPreferences class >> enableForceLayout: aBoolean [

	EnableForceLayout := aBoolean
]

{ #category : #accessing }
SBPreferences class >> hideIndicators [
	<preference: 'Hide always-visible offscreen indicators' category: 'sandblocks' description: '' type: #Boolean>

	^ HideIndicators ifNil: [false]
]

{ #category : #accessing }
SBPreferences class >> hideIndicators: aBoolean [
	HideIndicators := aBoolean
]

{ #category : #accessing }
SBPreferences class >> largeInsets [
	<preference: 'Increase size of insets around blocks' category: 'sandblocks' description: 'Increase size of insets so that blocks are easier to distinguish' type: #Boolean>

	^ LargeInsets ifNil: [false]
]

{ #category : #accessing }
SBPreferences class >> largeInsets: aBoolean [

	LargeInsets := aBoolean.
	
	SBEditor allSubInstancesDo: [:editor |
		editor colorPolicy ifNotNil: [:c |
			c enlarge: aBoolean.
			editor allMorphsDo: #layoutChanged]]
]

{ #category : #accessing }
SBPreferences class >> previewDropInsert [
	<preference: 'Preview block positions while dragging' category: 'sandblocks' description: 'Preview the block that would be inserted when dragging' type: #Boolean>

	^ PreviewDropInsert ifNil: [false]
]

{ #category : #accessing }
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

{ #category : #accessing }
SBPreferences class >> suggestionsOnClick [
	<preference: 'Show suggestions menu on click' category: 'sandblocks' description: 'Show the suggestions menu when a message send is clicked, not just when starting to type.' type: #Boolean>

	^ SuggestionsOnClick ifNil: [false]
]

{ #category : #accessing }
SBPreferences class >> suggestionsOnClick: aBoolean [

	SuggestionsOnClick := aBoolean
]
