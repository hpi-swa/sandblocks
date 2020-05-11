as yet unclassified
t01movement

	| y |
	SBLabel text: [
		'move your selection by clicking or using hjkl.
 If anything breaks, use u to undo'].
	(true and: [false]) ifTrue: [self halt].
	y := self size + super size.
	{$a. #a. 'a'. 1. 1.0} do: [:each |
		Transcript showln: (each notNil ifTrue: [self halt] ifFalse: [123])].
	^ 6 < y