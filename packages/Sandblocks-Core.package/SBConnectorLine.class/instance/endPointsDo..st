as yet unclassified
endPointsDo: aBlock

	^ aBlock
		value: (from bounds line: (from bounds sideNearestTo: to center) do: [:a :b | to center nearestPointOnLineFrom: a to: b])
		value: (to bounds line: (to bounds sideNearestTo: from center) do: [:a :b | from center nearestPointOnLineFrom: a to: b])