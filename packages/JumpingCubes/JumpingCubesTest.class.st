Class {
	#name : #JumpingCubesTest,
	#superclass : #TestCase,
	#category : #JumpingCubes
}

{ #category : #'as yet unclassified' }
JumpingCubesTest >> testSplitValueAtEdge [

	| field |
	field := JumpingCubes new.
	field submorphs second value: 3.
	(field submorphs at: 11) value: 3.
	
	field firstSubmorph simulateMouseDownUp.
	field firstSubmorph simulateMouseUp.
	self assert: field firstSubmorph value = 1
]
