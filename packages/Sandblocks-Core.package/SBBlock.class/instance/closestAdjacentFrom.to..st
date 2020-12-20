hierarchy
closestAdjacentFrom: mySide to: theirSide

	| myPoint direction component candidates |
	SBToggledCode
		comment: 'center is likely more permissive, but mySide might be more accurate'
		active: 1
		do: {[myPoint := self perform: mySide]. [myPoint := self center]}.
	direction := ({#leftCenter. #topCenter} includes: mySide) ifTrue: [#<] ifFalse: [#>].
	component := ({#leftCenter. #rightCenter} includes: mySide) ifTrue: [#x] ifFalse: [#y].
	candidates := self parentSandblock childSandblocks select: [:block |
		block ~= self and: [
			((block perform: mySide) perform: component) perform: direction with: (myPoint perform: component)]].
	^ candidates
		ifEmpty: [self]
		ifNotEmpty: [
			candidates fold: [:a :b |
				((a perform: theirSide) squaredDistanceTo: myPoint) < ((b perform: theirSide) squaredDistanceTo: myPoint) ifTrue: [a] ifFalse: [b]]]