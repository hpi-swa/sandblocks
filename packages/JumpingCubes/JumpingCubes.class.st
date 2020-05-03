Class {
	#name : #JumpingCubes,
	#superclass : #Morph,
	#category : 'JumpingCubes'
}

{ #category : #'as yet unclassified' }
JumpingCubes >> example [

	SBMorphExample
		setUp: [JumpingCubes new]
		cases: {
			(SBMorphExampleCase
				name: 'example'
				caseBlock: [:m | 
					m submorphs second value: 3.
					(m submorphs at: 11) value: 3.
					m world doOneCycleNow.
					m firstSubmorph simulateMouseDown.
					m firstSubmorph simulateMouseUp.
					self assert: m firstSubmorph value = 1])
		}
		extent: 365 @ 351
]

{ #category : #'as yet unclassified' }
JumpingCubes >> fieldSize [

	^ 10
]

{ #category : #'as yet unclassified' }
JumpingCubes >> initialize [

	super initialize.
	1
		to: self fieldSize
		do: [:y | 1 to: self fieldSize do: [:x | self addMorphBack: (JCTile new tilePosition: x @ y)]].
	self submorphsDo: #findNeighbors.
	self extent: (Rectangle merging: (self submorphs collect: #bounds)) extent
]

{ #category : #'as yet unclassified' }
JumpingCubes >> tileAt: aPoint [

	^ (aPoint x < 1 or: [aPoint y < 1 or: [aPoint x > self fieldSize or: [aPoint y > self fieldSize]]]) ifFalse: [self submorphs at: ((aPoint y - 1) * self fieldSize) + aPoint x]
]
