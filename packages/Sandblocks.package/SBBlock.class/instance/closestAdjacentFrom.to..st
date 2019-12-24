testing
closestAdjacentFrom: mySide to: theirSide

	| myPoint |
	myPoint := self perform: mySide.
	^ (self parentSandblock childSandblocks copyWithout: self) fold: [:a :b |
			((a perform: theirSide) squaredDistanceTo: myPoint) < ((b perform: theirSide) squaredDistanceTo: myPoint)
				ifTrue: [a] ifFalse: [b]]