actions
pasteAboveOrBelow: anAboveBoolean

	| copyBuffer |
	copyBuffer := self sandblockEditor copyBuffer ifNil: [^ self].
	copyBuffer wrapsAround ifTrue: [^ self wrapSelectionWith: copyBuffer].
	SBToggledCode
		comment: ''
		active: 2
		do: {
			[
				self sandblockEditor do: (SBCombinedCommand newWith: (copyBuffer submorphs reversed collect: [:target | | index adjacent morph actualTarget |
					actualTarget := self parentThatAccepts: target ifNone: [^ self].
					index := adjacent getIndexInOwner.
					morph := actualTarget veryDeepCopy
						topCenter: self bottomCenter;
						postDuplicate;
						yourself.
					(adjacent parentSandblock containingArtefact ifNil: [SBInsertCommand newNonEdit] ifNotNil: [:artefact | SBInsertCommand newFor: artefact])
						index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
						container: adjacent owner;
						morph: morph;
						yourself]))].
			[
				copyBuffer submorphs withIndexDo: [:target :index |
					target object
						safeRepresentationThat: (self parentSandblock contextAcceptedRepresentationAt: (anAboveBoolean ifTrue: [self childIndex] ifFalse: [self childIndex + index]))
						do: [:repr |
							self sandblockEditor do: ((self containingArtefact = self ifFalse: [SBInsertCommand newFor: self containingArtefact] ifTrue: [SBInsertCommand newNonEdit])
								morph: (repr center: self center);
								container: self owner;
								index: (anAboveBoolean ifTrue: [self submorphIndex] ifFalse: [self submorphIndex + index]);
								shouldMergeWithNext: index < copyBuffer submorphCount).
							repr postDuplicateSelf]
						ifNone: [SBLabel text: ['undo last command?']].
					anAboveBoolean ifTrue: [self submorphBefore select] ifFalse: [self submorphAfter select]]]
		}