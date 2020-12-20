as yet unclassified
matches: aMessage

	(super matches: aMessage) ifFalse: [^ false].
	
	^ aMessage receiver isBinding and: [aMessage receiver contents = self name] and: [aMessage selector = 'self:args:label:']