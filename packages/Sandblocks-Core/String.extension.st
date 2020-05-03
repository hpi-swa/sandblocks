Extension { #name : #String }

{ #category : #'*Sandblocks-Core' }
String >> parseAsSandblock [

	| parser class methodNode |
	SBExample self: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements first expr asSandblock
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
