Extension { #name : #SBEditor }

{ #category : #'*Sandblocks-Babylonian' }
SBEditor >> sendNewPermutationNotification [
	
	self allMorphsDo: [:morph | morph listensToPermutations ifTrue: [morph updateStyling]]
	
	 
]
