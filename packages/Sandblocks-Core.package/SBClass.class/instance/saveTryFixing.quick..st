as yet unclassified
saveTryFixing: aBoolean quick: aQuickBoolean

	| oldClass environment newClassName |
	self valid ifFalse: [^ false].
	
	oldClass := self shownClass.
	newClassName := self shownClassName.
	environment := oldClass ifNotNil: #environment ifNil: [self environment].
	
	((oldClass isNil or: [oldClass theNonMetaClass name asString ~= newClassName])
		and: [environment includesKey: newClassName asSymbol]) ifTrue:
			[(self confirm: ((newClassName , ' is an existing class in this system.
Redefining it might cause serious problems.
Is this really what you want to do?') asText makeBoldFrom: 1 to: newClassName size))
				ifFalse: [^ false]].
	
	oldClass ifNotNil: [oldClass := oldClass superclass].
	class := environment beCurrentDuring: [oldClass subclassDefinerClass
		evaluate: self definitionString
		in: environment
		notifying: nil
		logged: false].
	
	^ true