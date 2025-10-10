Extension { #name : #StringMorph }

{ #category : #'*Sandblocks-Babylonian' }
StringMorph >> layoutedTaggedCopy [

	^ super layoutedTaggedCopy 
		font: self font;
		emphasis: self emphasis;
		contents: '';
		yourself 
]
