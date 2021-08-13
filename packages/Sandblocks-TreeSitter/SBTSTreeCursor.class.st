Class {
	#name : #SBTSTreeCursor,
	#superclass : #ExternalStructure,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTSTreeCursor class >> fields [

	^ #(#('tree' 'void*') #('id' 'void*') #('context' 'uint32_t[2]'))
]
