Extension { #name : #SBLineChart }

{ #category : #'*Sandblocks-Babylonian' }
SBLineChart >> layoutedTaggedCopy [

	^ self class new
		traceValues: self traceValues;
		targetHeight: self targetHeight;
		scaleY: self scaleY;
		extent: self extent;
		color: self color;
		layoutProperties: self layoutProperties;
		layoutPolicy: self layoutPolicy;
		borderStyle: self borderStyle;
		tag: self tag;
		yourself 
				
		
]
