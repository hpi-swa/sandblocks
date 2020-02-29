as yet unclassified
endPointsDo: aBlock

	^ aBlock
		value: (fromAlign = #none
			ifTrue: [from bounds line: (from bounds sideNearestTo: to center) do: [:a :b | to center nearestPointOnLineFrom: a to: b]]
			ifFalse: [from perform: (fromAlign, 'Center') asSymbol])
		value: (toAlign = #none
			ifTrue: [to bounds line: (to bounds sideNearestTo: from center) do: [:a :b | from center nearestPointOnLineFrom: a to: b]]
			ifFalse: [to perform: (toAlign, 'Center') asSymbol])