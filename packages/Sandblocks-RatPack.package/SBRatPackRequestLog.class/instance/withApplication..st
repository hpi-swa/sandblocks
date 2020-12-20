accessing
withApplication: aRPApplication

	self halt.
	aRPApplication addDependent: self.