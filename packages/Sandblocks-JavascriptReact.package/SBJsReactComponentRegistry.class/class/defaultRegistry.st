accessing
defaultRegistry

	^ DefaultRegistry ifNil: [DefaultRegistry := self new]