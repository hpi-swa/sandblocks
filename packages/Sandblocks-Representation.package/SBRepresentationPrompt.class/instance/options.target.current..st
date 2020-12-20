as yet unclassified
options: aCollection target: anObject current: aRepresentation

	SBExample
		self: [SBRepresentationPrompt new]
		args: [{5 representationsThat: #isToplevelMorph. 5. nil}]
		label: 'example'.
	currentRepresentation := aRepresentation.
	target := anObject.
	
	aCollection do: [:option |
		options addMorphBack: (SBTextBubble new
			prefix: (option causesSideEffects ifTrue: ['/!\ '] ifFalse: [nil]);
			contents: option prettyName;
			setProperty: #representation toValue: option;
			when: #selected send: #useRepresentation: to: self with: option)].
	currentRepresentation ifNotNil: [
		currentRepresentation
			when: #positionChanged send: #updatePosition to: self;
			when: #extentChanged send: #updatePosition to: self].
	SBToggledCode
		comment: ''
		active: 1
		do: {
			[
				Project current addDeferredUIMessage: [
					self addAlarm: #delete after: 2 seconds asMilliSeconds.
					currentRepresentation ifNotNil: #select]]
		}.
	self select: (aCollection findFirst: [:option | option causesSideEffects not]).
	self allMorphsDo: #layoutChanged