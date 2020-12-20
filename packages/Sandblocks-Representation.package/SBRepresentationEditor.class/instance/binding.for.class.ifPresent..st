as yet unclassified
binding: aString for: block class: aClass ifPresent: aBlock

	aString = self argumentBlock contents ifTrue: [^ aBlock value: self argumentBlock].
	^ super binding: aString for: block class: aClass ifPresent: aBlock