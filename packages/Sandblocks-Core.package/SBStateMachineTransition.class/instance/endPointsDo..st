as yet unclassified
endPointsDo: aBlock

	^ super endPointsDo: [:a :b |
		a = b
			ifTrue: [aBlock value: a value: b]
			ifFalse: [ | direction |
				direction := (b - a) normalized * 3.
				aBlock value: a + direction value: b - direction]]