*Sandblocks-Core
sandblockMatch: aString
	" matching specific to what appears a good heuristic in auto completion "

	^ self size > 1 and: [aString size > 1] and: [self first = aString first] and: [self second = aString second] and: [ | rhsIndex |
		rhsIndex := 3.
		3 to: self size do: [:lhsIndex |
			rhsIndex > aString size ifTrue: [^ true].
			(self at: lhsIndex) asLowercase = (aString at: rhsIndex) asLowercase ifTrue: [rhsIndex := rhsIndex + 1]].
		rhsIndex > aString size]