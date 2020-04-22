as yet unclassified
update: anAspect

	| points |
	(self isInWorld and: [from isInWorld not or: [to isInWorld not]]) ifTrue: [^ self delete].
	points := self lineType = #curve ifTrue: [self curvePoints] ifFalse: [self endPointsDo: [:a :b | {a. b}]].
	self bounds: (Rectangle encompassing: points)