actions
pasteString
	<action>

	| doIt block baseIndex |
	doIt := Parser new parse: Clipboard clipboardText class: nil class noPattern: true notifying: nil ifFail: [^ nil].
	block := doIt block statements last expr asSandblock.
	baseIndex := self containingStatement owner submorphIndexOf: self containingStatement.
	
	self sandblockEditor do: ((SBCombinedCommand newFor: self containingArtefact)
		commands:
			{(SBReplaceCommand newFor: self containingArtefact) target: self; replacer: block},
			(doIt block statements allButLast withIndexCollect: [:statement :index |
				(SBInsertCommand newFor: self containingArtefact)
					index: baseIndex + index - 1;
					container: self containingStatement owner;
					morph: statement asSandblock])).
	block postDuplicate