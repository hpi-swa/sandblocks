as yet unclassified
isAllowedExternalCall: aMethod

	| module call |
	module := (aMethod literalAt: 1) at: 1.
	call := (aMethod literalAt: 1) at: 2.
	^ module = #LargeIntegers or: [(module = #MiscPrimitivePlugin and: [#(#primitiveStringHash #primitiveCompareString #primitiveIndexOfAsciiInString) includes: call]) or: [#(#primitiveUtcWithOffset) includes: call]]