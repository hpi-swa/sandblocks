"
A SBClippingTransformMorph is a transform morph that only queues drawing commands for children whose bounds are within the visible rectangle. This may cause incorrect drawing for children that draw outside their bounds.
"
Class {
	#name : #SBClippingTransformMorph,
	#superclass : #TransformMorph,
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBClippingTransformMorph >> drawSubmorphsOn: aCanvas [

	| clipRect |
	clipRect := self innerBounds.
	aCanvas transformBy: transform
		clippingTo: clipRect
		during: [:myCanvas | | drawBlock clipRectInWorld |
			clipRectInWorld := self bounds: clipRect in: self world.
			drawBlock := [submorphs reverseDo:[:m | (m boundsInWorld intersects: clipRectInWorld) ifTrue: [myCanvas fullDrawMorph: m]]].
			(self angle ~= 0.0 or: [self scale ~= 1.0])
				ifTrue: [AbstractFont forceNonSubPixelDuring: drawBlock]
				ifFalse: drawBlock ] 
		smoothing: smoothing
]
