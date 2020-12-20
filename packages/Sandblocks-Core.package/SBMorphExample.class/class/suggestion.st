as yet unclassified
suggestion

	^ [:block | | setUp |
		setUp := SBBlockBody empty.
		block sandblockEditor selectedArtefact relatedClass ifNotNil: [:class |
			setUp statements: {SBMessageSend new
				receiver: (SBName contents: class name)
				selector: #new}].
		block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
			target: block;
			replacer: ((SBMorphExample new
				setUp: setUp
				cases: {}
				extent: 300 asPoint)
					addCase: ((SBBlockBody emptyWithDeclarations: {'m'}) statements: {SBName contents: 'm'}) name: 'example 1');
					yourself)]