as yet unclassified
valid

	^ (self parentSandblock isBlockBody and: [self parentSandblock isMethodBody]) and: [
		(self selector notEmpty and: true) and: [ | lastIndex |
			lastIndex := self parentSandblock statements indexOf: self.
			((self parentSandblock statements viewFrom: 1 to: lastIndex) allSatisfy: #isPragma) and: [self arguments allSatisfy: #isLiteralBlock]]]