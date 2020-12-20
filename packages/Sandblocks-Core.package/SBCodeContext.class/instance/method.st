as yet unclassified
method

	^ self methodClass methodDict at: self selector ifAbsent: [nil]