as yet unclassified
correctColorFromPixelValue: p
	" Color class' colorFromPixelValue:depth: thinks colors are transparent when they're black "

	| alpha b g r |
	r := (p bitShift: -16) bitAnd: 16rFF.
	g := (p bitShift: -8) bitAnd: 16rFF.
	b := p bitAnd: 16rFF.
	alpha := p bitShift: -24.
	alpha = 0 ifTrue: [^Color transparent].
	^ (Color r: r g: g b: b range: 255) alpha: (alpha asFloat / 255.0)