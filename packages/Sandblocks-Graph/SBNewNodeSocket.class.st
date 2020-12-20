Class {
	#name : #SBNewNodeSocket,
	#superclass : #Morph,
	#instVars : [
		'socket',
		'label',
		'connectedNodes',
		'connectedLinks'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> connectedLink [

	self assert: self connectedLinks size <= 1.
	^ self connectedLinks ifEmpty: [nil] ifNotEmpty: #first
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> connectedLinks [

	^ connectedLinks
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> delete [

	self connectedLinks do: #delete.
	super delete
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> initialize [

	super initialize.
	
	connectedLinks := OrderedCollection new.
	
	self
		changeTableLayout;
		listCentering: #topLeft;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		color: Color transparent;
		addMorphBack: (socket := SBSocketCircle new);
		addMorphBack: (label := StringMorph new);
		label: ''
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> label: aString [

	label contents: aString.
	self listCentering: (aString ifEmpty: [#center] ifNotEmpty: [#topLeft])
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> node [

	^ socket node
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> notifyConnectTo: aLink [

	self connectedLinks add: aLink
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> notifyDisconnectFrom: aLink [

	self connectedLinks remove: aLink ifAbsent: []
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> socket [

	^ socket
]

{ #category : #'as yet unclassified' }
SBNewNodeSocket >> type: aSymbol [

	socket type: aSymbol.
	self listDirection: (aSymbol = #output ifTrue: [#rightToLeft] ifFalse: [#leftToRight])
]
