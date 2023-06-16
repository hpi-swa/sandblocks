Class {
	#name : #SBRowBlock,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRowBlock >> initialize [

	super initialize.
	self
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBRowBlock >> layoutCommands [

	^ SBAlgebraCommand container
		data: (self submorphs collect: [:s | s layoutCommands] separatedBy: [SBAlgebraCommand gap]);
		morph: self
]
