as yet unclassified
update: anAspect

	| points |
	points := self lineType = #curve ifTrue: [self curvePoints] ifFalse: [self endPointsDo: [:a :b | {a. b}]].
	self bounds: (Rectangle encompassing: points)