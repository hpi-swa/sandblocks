Extension { #name : #ParseNode }

{ #category : #'*Sandblocks-Smalltalk' }
ParseNode >> asSandblock [

	^ (self accept: SBStMethodToBlocks new) applyReplacements
]
