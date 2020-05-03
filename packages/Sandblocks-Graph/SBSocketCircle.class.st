Class {
	#name : #SBSocketCircle,
	#superclass : #Morph,
	#instVars : [
		'type'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBSocketCircle >> acceptDroppingMorph: aMorph event: anEvent [

	aMorph connectTo: self.
	self triggerEvent: #connected
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> bubbleSize [

	^ 12 asPoint * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> connectTo: aSocket [

	^ SBConnector new connectFrom: self to: aSocket; yourself
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> drawOn: aCanvas [

	(type = #flowIn or: [type = #flowOut])
		ifTrue: [
			aCanvas drawPolygon: (type =  #flowIn
				ifTrue: [{self topLeft. self topRight. self bottomCenter - (0 @ self height / 2)}]
				ifFalse: [{self bottomLeft. self bottomRight. self topCenter + (0 @ self height / 2)}]) fillStyle: Color red]
		ifFalse: [
			aCanvas clipBy: self bounds during: [:canvas |
				canvas fillOval: (self bounds translateBy: self width / 2 * (type = #output ifTrue: [1] ifFalse: [-1]) @ 0) color: self color]]
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> handlesMouseOverDragging: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> initialize [

	super initialize.
	
	self
		extent: self bubbleSize;
		color: Color black
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> mouseEnter: anEvent [

	
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> mouseEnterDragging: anEvent [

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: anEvent]) ifTrue: [
		anEvent hand firstSubmorph valid: true]
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> mouseLeaveDragging: anEvent [

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: SBDragProxy]) ifTrue: [
		anEvent hand firstSubmorph valid: false]
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> node [

	^ self ownerThatIsA: SBNewNode
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> notifyConnectTo: aSocket [

	self owner notifyConnectTo: aSocket.
	self node update
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> notifyDisconnectFrom: aSocket [

	self owner notifyDisconnectFrom: aSocket.
	self node update
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> startDrag: anEvent [

	| line |
	line := SBConnector new startNow: self.
	self node owner addMorphBack: line.
	
	anEvent hand attachMorph: (SBDragProxy new line: line from: self)
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> type: aSymbol [

	type := aSymbol
]

{ #category : #'as yet unclassified' }
SBSocketCircle >> wantsDroppedMorph: aMorph event: anEvent [

	^ (aMorph isKindOf: SBDragProxy) and: [aMorph type = self type]
]
