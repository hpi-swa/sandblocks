as yet unclassified
minExtentOf: aMorph in: aRectangle

	| state initial commands minExtent |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	commands := self commandsForRoot: aMorph.
	(commands type = #morph and: [commands data = aMorph]) ifTrue: [^ aRectangle extent].
	
	initial := ((SBAlgebraState new offset: aRectangle topLeft) startX: aRectangle left).
	measure := true.
	state := self layoutDocument: commands at: initial limit: aRectangle right wrap: false.
	measure := false.
	
	" bit of a hack here: since our height depends on our width, we cannot generally just report
	  the final result, as this would for example give us too much height. instead we choose a
	  small threshold that we can assume our layout will be able to be condensed into and
	  only start reporting proper min widths if the provided space is less than that "
	minExtent := state extentFrom: initial.
	^ minExtentCache := "aRectangle width <= minExtent x"true
		ifTrue: [state extentFrom: initial]
		ifFalse: [50 @ (state extentFrom: initial) y]