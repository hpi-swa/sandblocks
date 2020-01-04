as yet unclassified
drawOn: aCanvas

	"aCanvas line: source center to: destination center width: 2 * self scalingFactor color: Color black"
	(source type = #flowIn or: [source type = #flowOut])
		ifTrue: [ | controlHeight |
			controlHeight := (destination left - source left * 0.5) abs.
			aCanvas asBalloonCanvas
				aaLevel: 4;
				drawBezier3Shape: {
					source center.
					source center + (0 @ controlHeight * (source type = #flowIn ifTrue: [-1] ifFalse: [1])).
					destination center + (0 @ controlHeight * (destination type = #flowIn ifTrue: [-1] ifFalse: [1])).
					destination center}
				color: Color transparent
				borderWidth: 2 * self scalingFactor
				borderColor: Color red]
		ifFalse: [ | controlWidth |
			controlWidth := (destination left - source left * 0.5) abs.
			aCanvas asBalloonCanvas
				drawBezier3Shape: {
					source center.
					source center + (controlWidth @ 0 * (source type = #input ifTrue: [-1] ifFalse: [1])).
					destination center + (controlWidth @ 0 * (destination type = #input ifTrue: [-1] ifFalse: [1])).
					destination center}
				color: Color transparent
				borderWidth: 2 * self scalingFactor
				borderColor: Color black]