drawing
drawOn: aCanvas

	| max x height |
	max := data max max: 1.
	x := 0.
	height := self height - 1.
	
	data do: [:value | | nowY |
		nowY := (value / max * self height) ceiling.
		aCanvas fillRectangle: (x - self gap @ (height - nowY + 1) + self position extent: self gap @ nowY) color: Color red.
		x := x + self gap].
	
	aCanvas drawString: label, ' (', data last asString, '/', max asString, ')' at: self position font: nil color: labelColor