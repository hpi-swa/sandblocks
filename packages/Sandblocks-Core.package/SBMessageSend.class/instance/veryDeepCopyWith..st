as yet unclassified
veryDeepCopyWith: deepCopier

	" assure that copies of us have a unique id "
	| new |
	new := super veryDeepCopyWith: deepCopier.
	self receiver ifNil: [
		self assert: self isInCascade.
		new receiver: self owner receiver veryDeepCopy].
	^ new