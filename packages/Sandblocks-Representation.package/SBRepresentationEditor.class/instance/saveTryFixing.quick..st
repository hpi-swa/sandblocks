as yet unclassified
saveTryFixing: aBoolean quick: anotherBoolean

	(object isNil or: [object name ~= self classLabel contents]) ifTrue: [ | class |
		class := SBClass new.
		object
			ifNotNil: [class class: object]
			ifNil: [
				class
					category: 'Sandblocks-Representation';
					superClassName: 'SBRepresentation'].
		class className: self classLabel contents.
		(class saveTryFixing: aBoolean quick: anotherBoolean) ifFalse: [^ false].
		object := class relatedClass].
	object class compile: 'newFor: ', self argumentBlock contents, '

', self constructorBlock prettySourceString allButFirst allButLast.
	object class compile: 'matches: ', self argumentBlock contents, '
', self matcherBlock prettySourceString allButFirst allButLast.
	self capabilitiesList submorphsDo: [:symbol | object class compile: symbol contents, ' ^ true'].
	((self capabilitiesFrom: object) copyWithoutAll: ((self capabilitiesList submorphs collect: #contents) collect: #asSymbol)) do: [:selector | object class removeSelector: selector].
	^ true