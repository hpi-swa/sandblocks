Class {
	#name : #SBNodeSocket,
	#superclass : #Morph,
	#instVars : [
		'type'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBNodeSocket >> acceptDroppingMorph: aMorph event: anEvent [

	aMorph connectTo: self.
	self triggerEvent: #connected
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> bubbleSize [

	^ 12 asPoint * self scalingFactor
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> connectTo: aSocket [

	^ SBConnector new connectFrom: self to: aSocket; yourself
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> drawOn: aCanvas [

	(type = #flowIn or: [type = #flowOut])
		ifTrue: [
			aCanvas drawPolygon: (type =  #flowIn
				ifTrue: [{self topLeft. self topRight. self bottomCenter}]
				ifFalse: [{self bottomLeft. self bottomRight. self topCenter}]) fillStyle: Color red]
		ifFalse: [
			aCanvas clipBy: self bounds during: [:canvas |
				canvas fillOval: (self bounds translateBy: self width / 2 * (type = #output ifTrue: [1] ifFalse: [-1]) @ 0) color: self color]]
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> handlesMouseOver: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> handlesMouseOverDragging: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> initialize [

	super initialize.
	
	self
		extent: self bubbleSize;
		color: Color black
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> mouseDown: anEvent [

	anEvent hand waitForClicksOrDrag: self event: anEvent
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> mouseEnter: anEvent [

	
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> mouseEnterDragging: anEvent [

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: anEvent]) ifTrue: [
		anEvent hand firstSubmorph valid: true]
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> mouseLeaveDragging: anEvent [

	(anEvent hand hasSubmorphs and: [self wantsDroppedMorph: anEvent hand firstSubmorph event: SBDragProxy]) ifTrue: [
		anEvent hand firstSubmorph valid: false]
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> node [

	^ self ownerThatIsA: SBNode
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> notifyConnectTo: aLink [
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> notifyDisconnectFrom: aLink [
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> startDrag: anEvent [

	| line |
	line := SBConnector new startNow: self.
	self node owner addMorphBack: line.
	
	anEvent hand attachMorph: (SBDragProxy new line: line from: self)
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> type: aSymbol [

	type := aSymbol
]

{ #category : #'as yet unclassified' }
SBNodeSocket >> wantsDroppedMorph: aMorph event: anEvent [

	^ (aMorph isKindOf: SBDragProxy) and:  [aMorph type = type]
]
