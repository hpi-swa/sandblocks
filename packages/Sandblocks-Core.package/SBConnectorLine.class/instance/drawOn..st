as yet unclassified
drawOn: aCanvas

	self lineType = #line
		ifTrue: [
			self endPointsDo: [:a :b |  | rotated |
				rotated := Point r: self arrowSize degrees: (a - b) theta radiansToDegrees + 45.
				aCanvas line: a to: b width: 3 color: self color.
				self drawArrowOn: aCanvas origin: b delta: rotated]].
	self lineType = #curve
		ifTrue: [ | delta controlSize controlPoint fromControl toControl points rotated |
			points := self curvePoints.
			rotated := Point r: self arrowSize degrees: (points fourth - points third) theta radiansToDegrees - 135.
			aCanvas asBalloonCanvas
				 aaLevel: 4;
				 drawBezier3Shape: points color: Color transparent borderWidth: 2 withScalingFactor borderColor: self color.
			self drawArrowOn: aCanvas origin: points last delta: rotated.
			aCanvas line: points last to: points last + rotated leftRotated width: 3 color: self color]