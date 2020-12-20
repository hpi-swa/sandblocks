accessing
fixActions

	^ self isDefined not
		ifTrue: [ | class |
			class := self actualReceiver guessClassExpensive.
			{
				(SBCodeAction
					labeled: 'Create method on ', (class ifNotNil: #name ifNil: ['...'])
					for: self
					do: [:node | 
						self sandblockEditor openMorphInView: (SBMethod new
							selector: self selector
								arguments: (self arguments collectWithIndex: [:arg :index | arg isName ifTrue: [arg veryDeepCopy] ifFalse: [SBName contents: 'anObject', index asString]])
								class: (class ifNil: [UIManager default chooseClassOrTrait ifNil: [^ self]]);
							body: SBBlockBody new;
							hasUnsavedChanges: true)])
			}]
		ifFalse: [#()]