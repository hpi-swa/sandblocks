accessing
showUsageInfo

	self actualReceiver guessedClass
		ifNotNil: [:class |  | method |
			method := class lookupSelector: self selector asSymbol.
			method ifNil: [^ self].
			Transcript showln: method]