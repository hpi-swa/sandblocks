as yet unclassified
drawSubmorphsOn: aCanvas

	| clipRect |
	clipRect := self innerBounds.
	aCanvas transformBy: transform
		clippingTo: clipRect
		during: [:myCanvas | | drawBlock |
			drawBlock := [submorphs reverseDo:[:m | (m boundsInWorld intersects: clipRect) ifTrue: [myCanvas fullDrawMorph: m]]].
			(self angle ~= 0.0 or: [self scale ~= 1.0])
				ifTrue: [AbstractFont forceNonSubPixelDuring: drawBlock]
				ifFalse: drawBlock ] 
		smoothing: smoothing