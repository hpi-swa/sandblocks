as yet unclassified
averageColorInQuadOfSize: aNumber at: aPoint from: aForm

	| alpha blue green num red |
	red := 0.
	green := 0.
	blue := 0.
	alpha := 0.
	num := 0.
	
	(aPoint x - aNumber max: 0) to: (aPoint x + aNumber min: aForm width - 1) do: [:x |
		(aPoint y - aNumber max: 0) to: (aPoint y + aNumber min: aForm height - 1) do: [:y | | p |
			p := aForm pixelValueAt: x @ y.
			red := red + ((p bitShift: -16) bitAnd: 16rFF).
			green := green + ((p bitShift: -8) bitAnd: 16rFF).
			blue := blue + (p bitAnd: 16rFF).
			alpha := alpha + (p bitShift: -24).
			num := num + 1]].
	^ (Color r: red / num g: green / num b: blue / num range: 255) alpha: alpha asFloat / num / 255.0