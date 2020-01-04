as yet unclassified
autoPlace

	| root min max |
	root := self nodes detect: [:morph | morph hasFlowIn not and: [morph outputSockets first connectedLinks isEmpty]].
	
	root autoPlaceFlow.
	
	min := 0 @ 0.
	self nodes do: [:morph |
		morph left < min x ifTrue: [min := morph left @ min y].
		morph top < min ifTrue: [min := min x @ morph top]].
	self nodes do: [:morph |
		morph position: self position + morph position + min negated].
	
	max  := 0 @ 0.
	self nodes do: [:morph |
		morph left > max x ifTrue: [max := morph left @ max y].
		morph top > max y ifTrue: [max := max x @ morph top]].
	self extent: max