as yet unclassified
moveCursorVertically: aNumber selecting: aBoolean ifAtBound: aBlock

	| data line |
	data := self lineNumberOfIndex: self cursor.
	
	(aNumber < 0 and: [(data first + aNumber) < 1])
		ifTrue: [
			self cursor: 1.
			aBlock value]
		ifFalse: [
			(aNumber > 0 and: [
				(data first + aNumber) > self paragraph numberOfLines])
				ifTrue: [
					self cursor: self contents size + 1.
					aBlock value]
				ifFalse: [
					line := data first + aNumber.
					data := self indexAtLine: line x: data second.
					
					self cursor: data first + data second]].
	
	aBoolean ifFalse: [self selectionBound: self cursor]