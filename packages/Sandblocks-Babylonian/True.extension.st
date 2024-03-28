Extension { #name : #True }

{ #category : #'*Sandblocks-Babylonian' }
True >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	"This has to return a container block"
	"Objects can choose if they want to apply a changed extent" 
		
	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorphBack: ToolIcons testGreen asMorph;
		yourself
]
