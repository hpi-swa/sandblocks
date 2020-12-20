as yet unclassified
doLayoutIn: aRectangle

	| directions |
	directions := #(#bottomRight #bottomLeft #topLeft #topRight).
	self evade caseOf: {
		[#none] -> [conditions center: aRectangle center].
		[#left] -> [
			conditions center: ((Bezier3Segment perform: #from:via:and:to: withArguments: self curvePointsForEvade) valueAt: 0.4)].
		[#right] -> [
			conditions center: ((Bezier3Segment perform: #from:via:and:to: withArguments: self curvePointsForEvade) valueAt: 0.6)]
	}.
	super doLayoutIn: aRectangle