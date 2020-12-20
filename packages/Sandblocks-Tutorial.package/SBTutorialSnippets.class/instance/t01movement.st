as yet unclassified
t01movement

	| y |
	SBLabel text: [
		'Move your selection by clicking or using hjkl.
To select larger parts, use shift+k and shift+j to make your selection smaller again.
 If anything breaks, use u to undo.

Try selecting the `12 squared` using only the keyboard.'].
	(true and: [false]) ifTrue: [5 squared].
	y := self size + super size.
	#($a #abc 'a' 1 1.0) do: [:each |
		Transcript showln: (each notNil ifTrue: [12 squared] ifFalse: [123])].
	^ 6 < y