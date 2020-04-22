as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	self value: self value not.
	self triggerEvent: #toggled.
	^ nil