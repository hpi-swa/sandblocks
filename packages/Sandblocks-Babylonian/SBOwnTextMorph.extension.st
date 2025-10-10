Extension { #name : #SBOwnTextMorph }

{ #category : #'*Sandblocks-Babylonian' }
SBOwnTextMorph >> layoutedTaggedCopy [

	^ super layoutedTaggedCopy 
		font: self font;
		colorAlpha: self colorAlpha;
		emphasis: self emphasis;
		contents: '';
		yourself 
]
