as yet unclassified
canMoveCursorDirection: aNumber

	^ ((self cursor = (self contents size + 1) and: [aNumber > 0]) or: [self cursor = 1 and: [aNumber < 0]]) not