actions
deleteAround
	<action>

	| editor target |
	editor := self sandblockEditor.
	target := self parentSandblock.
	editor countModifier - 1 timesRepeat: [target := target parentSandblock].
	
	target parentSandblock ifNil: [^ self].
	
	" if we have multiple siblings and our destination can take multiple children, move all "
	(self parentSandblock childSandblocks size > 1 and: [target parentHasDynamicNumberOfChildren and: [self isStatement]]) ifTrue: [ 
		SBPastePlaceholder forAll: self parentSandblock childSandblocks root: target copyIn: editor.
		
		editor do: ((SBRecordedCommand newFor: self containingArtefact) record: [:recorder |
			recorder moveAll: self parentSandblock childSandblocks in: target owner at: target submorphIndex + 1.
			recorder remove: target]).
		^ self].
	
	(self hasRepresentationThat: (target parentSandblock contextAcceptedRepresentationAt: target childIndex)) ifTrue: [ | replacer |
		SBPastePlaceholder for: self root: target copyIn: editor.
		
		replacer := self veryDeepCopy.
		editor do: ((SBReplaceCommand newFor: self containingArtefact)
			target: target;
			replacer: replacer).
		replacer postDuplicate]