Extension { #name : #TransformMorph }

{ #category : #'*Sandblocks-Babylonian' }
TransformMorph >> layoutedTaggedCopy [

	^ super layoutedTaggedCopy
		transform: self transform;
		smoothing: self smoothing;
		color: Color transparent;
		borderWidth: 0; 
		yourself
		
]
