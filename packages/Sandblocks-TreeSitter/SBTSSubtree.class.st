Class {
	#name : #SBTSSubtree,
	#superclass : #ExternalStructure,
	#category : #'Sandblocks-TreeSitter-FFI'
}

{ #category : #'as yet unclassified' }
SBTSSubtree class >> fields [

	^ #(
		(ignore 'uint8_t')
		(symbol 'uint8_t')
	)
]
