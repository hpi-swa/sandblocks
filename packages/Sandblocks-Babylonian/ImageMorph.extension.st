Extension { #name : #ImageMorph }

{ #category : #'*Sandblocks-Babylonian' }
ImageMorph >> applyResize: aPoint [
	
	| form |
	form := self form.
	form := form applyResize: aPoint.
	^ form asMorph
]

{ #category : #'*Sandblocks-Babylonian' }
ImageMorph >> layoutedTaggedCopy [

	^ super layoutedTaggedCopy
		image: self image;
		yourself
				
		
]
