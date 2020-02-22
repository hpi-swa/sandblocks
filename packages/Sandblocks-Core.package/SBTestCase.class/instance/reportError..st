as yet unclassified
reportError: anError

	(anError signalerContext findContextSuchThat: [:context | context method selector = self selector and: [context method methodClass = self methodClass]])
		ifNotNil: [:context | (self blockForPC: context previousPc) attachDecorator: (errorIndicator := SBErrorDecorator new message: anError asString)]