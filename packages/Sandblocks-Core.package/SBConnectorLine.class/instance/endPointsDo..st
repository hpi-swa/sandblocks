as yet unclassified
endPointsDo: aBlock

	^ aBlock
		value: (fromAlign = #none
			ifTrue: [ | side |
				side := from bounds sideNearestTo: to center.
				from bounds
					line: side
					do: [:a :b |
						(from bounds line: side do: [:a2 :b2 | ((b2 - a2) // 2) + a2]) nearestPointOnLineFrom: a to: b]]
			ifFalse: [from perform: (fromAlign, 'Center') asSymbol])
		value: (toAlign = #none
			ifTrue: [ | side |
				side := to bounds sideNearestTo: from center.
				to bounds
					line: side
					do: [:a :b |
						(to bounds line: side do: [:a2 :b2 | ((b2 - a2) // 2) + a2]) nearestPointOnLineFrom: a to: b]]
			ifFalse: [to perform: (toAlign, 'Center') asSymbol])