as yet unclassified
t01movement

	| y |
	SBLabel text: [
		'move your selection by clicking or using hjkl.
 If anything breaks, use u to undo. Try selecting the `12 squared`.

To move faster, you can use H and L to jump between message sends.'].
	(true and: [false]) ifTrue: [5 squared].
	y := self size + super size.
	#($a #abc 'a' 1 1.0) do: [:each |
		Transcript showln: (each notNil ifTrue: [12 squared] ifFalse: [123])].
	^ 6 < y