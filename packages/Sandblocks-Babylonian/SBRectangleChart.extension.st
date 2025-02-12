Extension { #name : #SBRectangleChart }

{ #category : #'*Sandblocks-Babylonian' }
SBRectangleChart >> layoutedTaggedCopy [

	^ self class new
		traceValues: self traceValues;
		targetHeight: self targetHeight;
		scaleY: self scaleY;
		scaleX: self scaleX;
		extent: self extent;
		color: self color;
		layoutProperties: self layoutProperties;
		layoutPolicy: self layoutPolicy;
		borderStyle: self borderStyle;
		tag: self tag;
		yourself 
				
		
]
