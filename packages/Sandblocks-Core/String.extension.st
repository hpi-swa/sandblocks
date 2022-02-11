Extension { #name : #String }

{ #category : #'*Sandblocks-Core-converting' }
String >> inStringView: converter [
	<convert>

	converter
		if: [self isSymbol not and: [self size < 1000]]
		do: [SBStringView new string: self]
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsMethod [

	| parser class methodNode |
	self example: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: false notifying: nil ifFail: nil.
	^ methodNode
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsMethodFor: aClass [

	| methodNode |
	self example: ['test 5 + 12 squared'] args: [{}] label: 'simple'.
	methodNode := PPParser new parse: self class: aClass noPattern: false notifying: nil ifFail: nil.
	^ methodNode
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsNode [

	| parser class methodNode |
	self example: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements size > 1 ifTrue: [methodNode block] ifFalse: [methodNode block statements first expr]
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsSandblock [

	self example: ['5 + 12 squared'] args: [{}] label: 'simple'.
	^ self parseAsNode asSandblock
]

{ #category : #'*Sandblocks-Core' }
String >> parseAsSandblockWithoutSubstitution [

	| parser class methodNode |
	self example: ['5 + 12 squared'] args: [{}] label: 'simple'.
	class := UndefinedObject.
	parser := class newParser.
	methodNode := parser parse: self class: class noPattern: true notifying: nil ifFail: nil.
	^ methodNode block statements first expr accept: SBStMethodToBlocks new
]

{ #category : #'*Sandblocks-Core-converting' }
String >> parseAsScheme: converter [
	<convert>

	converter
		if: [false and: [[SBScmModule fromString: self. true] on: Error do: [false]]]
		do: [SBScmModule fromString: self]
]

{ #category : #'*Sandblocks-Core-converting' }
String >> parseAsSmalltalk: converter [
	<convert>

	converter
		if: [[self parseAsMethod. true] on: Error do: [false]]
		do: [self parseAsMethod asSandblock]
]

{ #category : #'*Sandblocks-Core-converting' }
String >> parseAsSmalltalkExpression: converter [
	<convert>

	converter
		if: [
			[
				self parseAsSandblock.
				true]
				on: Error
				do: [false]]
		do: [self parseAsSandblock asSandblock]
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
String >> sandblockBeginsWith: aString [

	aString ifEmpty: [^ true].
	^ self beginsWith: aString
]

{ #category : #'*Sandblocks-Core' }
String >> sandblockMatch: aString [
	" matching specific to what appears a good heuristic in auto completion "
	" first two letters are exact match, afterwards allow any combination of successive letters "

	aString ifEmpty: [^ true].
	self size < aString size ifTrue: [^ false].
	(aString size < 2 or: [self size < 2]) ifTrue: [^ self asLowercase beginsWith: aString asLowercase].
	^ aString size > 1 and: [
		self first = aString first and: [
			self second = aString second and: [ | rhsIndex |
				rhsIndex := 3.
				3 to: self size do: [:lhsIndex |
					rhsIndex > aString size ifTrue: [^ true].
					(self at: lhsIndex) asLowercase = (aString at: rhsIndex) asLowercase ifTrue: [rhsIndex := rhsIndex + 1]].
				rhsIndex > aString size]]]
]

{ #category : #'*Sandblocks-Core' }
String >> truncateMiddleTo: aNumber [

	self size <= aNumber ifTrue: [^ self].
	^ ((self first: (aNumber * 0.3) floor), '...'), (self last: (aNumber * 0.7) floor)
]

{ #category : #'*Sandblocks-Core' }
String >> withSBShortcuts [

	^ self copyWithRegex: '<#\w+>' matchesTranslatedUsing: [:match | | shortcut |
		shortcut := SBEditor anyShortcutForAction: (match copyFrom: 3 to: match size - 1) asSymbol.
		'<', ((shortcut isCollection ifTrue: [shortcut anyOne] ifFalse: [shortcut]) ifNotNil: #displayString ifNil: ['not bound']), '>']
]
