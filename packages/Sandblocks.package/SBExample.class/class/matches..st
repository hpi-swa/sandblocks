as yet unclassified
matches: aMessage

	^ aMessage receiver isBinding and: [aMessage receiver contents = 'SBExample'] and: [aMessage selector = 'self:args:']