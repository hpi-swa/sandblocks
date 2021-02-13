Extension { #name : #String }

{ #category : #'*Sandblocks-Core' }
String >> codeWithEmptyLineMarkers [

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
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsMethod [

	| parser class methodNode |
	SBExample self: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: false notifying: nil ifFail: nil.
	^ methodNode
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsMethodFor: aClass [

	| parser methodNode |
	SBExample self: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	parser := aClass newParser.
	methodNode := parser parse: self class: aClass noPattern: false notifying: nil ifFail: nil.
	^ methodNode
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsNode [

	| parser class methodNode |
	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements size > 1 ifTrue: [methodNode block] ifFalse: [methodNode block statements first expr]
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsSandblock [

	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	^ self parseAsNode asSandblock
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsSandblockWithoutSubstitution [

	| parser class methodNode |
	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements first expr asSandblockWithoutSubstitution
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsScheme: converter [
	"<convert>"

	converter
		do: [SBScmModule fromString: self]
]

{ #category : #'*Sandblocks-Core' }
String >> parseInMethod [
	" convenience method making it easier to construct a valid environment for code blocks "

	| block |
	block := self parseAsSandblock.
	SBTest methodFor: block.
	^ block
]

{ #category : #'*Sandblocks-Core' }
String >> sandblockMatch: aString [
	" matching specific to what appears a good heuristic in auto completion "

	" first two letters are exact match, afterwards allow any combination of successive letters "
	^ self size > 1 and: [aString size > 1] and: [self first = aString first] and: [self second = aString second] and: [ | rhsIndex |
		rhsIndex := 3.
		3 to: self size do: [:lhsIndex |
			rhsIndex > aString size ifTrue: [^ true].
			(self at: lhsIndex) asLowercase = (aString at: rhsIndex) asLowercase ifTrue: [rhsIndex := rhsIndex + 1]].
		rhsIndex > aString size]
]

{ #category : #'*Sandblocks-Core' }
String >> truncateMiddleTo: aNumber [

	self size <= aNumber ifTrue: [^ self].
	^ ((self first: (aNumber * 0.3) floor), '...'), (self last: (aNumber * 0.7) floor)
]
