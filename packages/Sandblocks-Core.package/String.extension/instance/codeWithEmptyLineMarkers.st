*Sandblocks-Core
codeWithEmptyLineMarkers

	| ranges crPositions write |
	SBExample self: ['resultClass

	^ TestResult.'] args: [{}] label: 'short'.
	SBExample self: ['a.

b.
c.
''asdasd

asdas''.

^ d'] args: [{}] label: 'long'.
	SBLabel text: [
		'FIXME: the allButLast is a hack to fix the case where there''s comments after a return statement'].
	ranges := (Array streamContents: [:stream |
		Scanner new
			scanTokenPositionsIn: self
			into: [:start :end |
				start <= end ifTrue: [stream nextPut: (start to: end)]]]) allButLast.
	
	crPositions := Array streamContents: [:stream |
		stream nextPut: 1.
		ranges overlappingPairsDo: [:first :second |
			(first size = 1 and: [
				(self at: first start) = $. and: [
					((self viewFrom: first stop + 1 to: second start) occurrencesOf: Character cr) > 1]]) ifTrue: [
				stream nextPut: ((self viewFrom: first stop + 1 to: second start) lastIndexOf: Character cr) + first stop]]].
	
	write := '' writeStream.
	crPositions overlappingPairsDo: [:start :end |
		write nextPutAll: (self copyFrom: start to: end - 1).
		write nextPutAll: '#sbEmptyLine.'].
	write nextPutAll: (self copyFrom: crPositions last to: self size).
	
	^ write contents