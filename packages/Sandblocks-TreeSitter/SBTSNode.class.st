Class {
	#name : #SBTSNode,
	#superclass : #ExternalStructure,
	#category : #'Sandblocks-TreeSitter-FFI'
}

{ #category : #'as yet unclassified' }
SBTSNode class >> fields [

	^ #(
		(context 'uint32_t[4]')
		(id 'void*')
		(tree 'void*')
	)
]
