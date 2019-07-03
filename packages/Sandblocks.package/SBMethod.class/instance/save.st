as yet unclassified
save

	| text |
	text := self prettySourceString.
	self methodClass compile: text asText