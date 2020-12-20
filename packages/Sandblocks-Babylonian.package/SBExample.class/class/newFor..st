as yet unclassified
newFor: aMessage

	^ self new
		self: aMessage arguments first statements first
		args: aMessage arguments second statements first
		label: aMessage arguments third contents