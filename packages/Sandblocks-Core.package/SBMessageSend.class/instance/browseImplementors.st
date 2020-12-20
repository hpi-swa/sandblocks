as yet unclassified
browseImplementors
	<action>

	self actualReceiver guessClassExpensive
		ifNotNil: [:class |
			(class lookupSelector: self selector asSymbol) ifNotNil: [:m |
				^ self sandblockEditor open: m]].
	
	super browseImplementors