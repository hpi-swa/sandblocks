as yet unclassified
drawOn: aCanvas

	self lineType = #line ifTrue: [
		self endPointsDo: [:a :b | 
			aCanvas asBalloonCanvas
				aaLevel: 4;
				line: a to: b width: 3 color: self color.
			self drawConnectorsOn: aCanvas alignBetween: a and: b]].
	self lineType = #curve ifTrue: [ | delta controlSize controlPoint fromControl toControl points |
		points := self curvePoints.
		aCanvas asBalloonCanvas
			aaLevel: 4;
			drawBezier3Shape: points color: Color transparent borderWidth: 2 withScalingFactor borderColor: self color.
		self drawConnectorsOn: aCanvas alignBetween: points last and: points third]