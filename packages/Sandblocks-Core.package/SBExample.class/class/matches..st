as yet unclassified
matches: aMessage

	^ aMessage receiver isBinding and: [aMessage receiver contents = self name] and: [aMessage selector = 'self:args:label:']