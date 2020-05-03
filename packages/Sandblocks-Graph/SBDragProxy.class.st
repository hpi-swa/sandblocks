Class {
	#name : #SBDragProxy,
	#superclass : #Morph,
	#instVars : [
		'line',
		'socket',
		'type'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBDragProxy >> connectTo: aMorph [

	line connectFrom: socket owner to: aMorph owner.
	socket triggerEvent: #connected
]

{ #category : #'as yet unclassified' }
SBDragProxy >> drawOn: aCanvas [

	aCanvas fillOval: self bounds color: self color
]

{ #category : #'as yet unclassified' }
SBDragProxy >> initialize [

	super initialize.
	
	self
		extent: 12 asPoint * self scalingFactor;
		color: Color black
]

{ #category : #'as yet unclassified' }
SBDragProxy >> justDroppedInto: aMorph event: anEvent [

	(aMorph respondsTo: #connectTo:) ifFalse: [line delete].
	self delete
]

{ #category : #'as yet unclassified' }
SBDragProxy >> line: aMorph from: aNodeSocket [

	line := aMorph.
	socket := aNodeSocket.
	
	aMorph end: self.
	
	type := aNodeSocket type caseOf: {[#flowIn] -> [#flowOut]. [#flowOut] -> [#flowIn]. [#input] -> [#output]. [#output] -> [#input]}
]

{ #category : #'as yet unclassified' }
SBDragProxy >> notifyDisconnectFrom: aLink [
]

{ #category : #'as yet unclassified' }
SBDragProxy >> step [

	"line end: self center"
	line updateConnection
]

{ #category : #'as yet unclassified' }
SBDragProxy >> stepTime [

	^ 0
]

{ #category : #'as yet unclassified' }
SBDragProxy >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBDragProxy >> valid: aBoolean [

	self color: (aBoolean ifTrue: [Color green] ifFalse: [Color black])
]
