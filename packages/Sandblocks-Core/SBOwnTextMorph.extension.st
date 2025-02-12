Extension { #name : #SBOwnTextMorph }

{ #category : #'*Sandblocks-Core' }
SBOwnTextMorph >> fontToUse [

	^ (font ifNil: [TextStyle defaultFont]) emphasized: self effectiveEmphasis emphasisCode
]
