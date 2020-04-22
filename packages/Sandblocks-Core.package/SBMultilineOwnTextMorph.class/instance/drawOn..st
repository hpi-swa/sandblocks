as yet unclassified
drawOn: aCanvas

	aCanvas
		paragraph: (self paragraph positionWhenComposed: self position)
		bounds: (self position extent: self paragraph extent)
		color: self color