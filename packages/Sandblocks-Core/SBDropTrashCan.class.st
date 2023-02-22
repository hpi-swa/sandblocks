Class {
	#name : #SBDropTrashCan,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDropTrashCan >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphFront: (SBIcon iconTrash size: 40)
]

{ #category : #'as yet unclassified' }
SBDropTrashCan >> objectInterfaceForChild: aBlock [

	^ SBInterfaces always
]

{ #category : #'as yet unclassified' }
SBDropTrashCan >> specialDropCommand: aBlock [
	"noop, meaning we just absorp it"

	^ SBDoItCommand new
]
