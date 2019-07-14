accessing
fixActions

	^ (self isDefined not and: [self isSendToSelf])
		ifTrue: [{SBCodeAction labeled: 'Create method' for: self do: [:node | SBEditor new method: (SBMethod new
			selector: self selector
			arguments: (self arguments collectWithIndex: [:arg :index | arg isName ifTrue: [arg veryDeepCopy] ifFalse: [SBDeclaration new contents: 'anObject', index asString]])
			class: self containingMethod methodClass;
			body: SBBlockBody new);
			openInWindow]}]
		ifFalse: [#()]