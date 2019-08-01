as yet unclassified
drawOn: aCanvas

	aCanvas fillRectangle: self bounds color: Color white.
	aCanvas drawString: text at: self topLeft + 4.
	
	points overlappingPairsDo: [:start :end | | direction |
		direction := self directionFrom: start to: end.
		aCanvas fillOval: ((6 asPoint center: start) translateBy: self position) color: Color red.
		aCanvas line: start + self position to: end + self position width: 2 color: (direction caseOf: {
			[#left] -> [Color red].
			[#right] -> [Color green].
			[#up] -> [Color blue].
			[#down] -> [Color lightGray].
		})]