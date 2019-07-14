as yet unclassified
newFrom: aMessage

	^ self new
		self: aMessage arguments first statements first
		args: aMessage arguments second statements first