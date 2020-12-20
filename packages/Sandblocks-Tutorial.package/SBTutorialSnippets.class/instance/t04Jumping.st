as yet unclassified
t04Jumping

	| y |
	SBLabel text: [
		'In a large method, you can navigate faster by using g and G to jump to the start or end.

Try selecting the `6 < y` at the end and pressing ma. This will place a marker on it.
With the marker in place, select the previous tutorial, then press ''a to jump back to the marker.
Pressing m on the marker again will delete it.'].
	(true and: [false]) ifTrue: [5 squared].
	y := self size + super size.
	#($a #abc 'a' 1 1.0) do: [:each |
		Transcript showln: (each notNil ifTrue: [12 squared] ifFalse: [123])].
	^ 6 < y