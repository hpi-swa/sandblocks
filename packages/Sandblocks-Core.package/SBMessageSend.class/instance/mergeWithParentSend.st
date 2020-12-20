actions
mergeWithParentSend
	<action>
	<actionValidIf: #parentIsKeywordSend>

	| signature |
	
	signature := self parentSandblock signature.
	self sandblockEditor do: (SBCombinedCommand newWith: (self messageParts
		with: self arguments
		collect: [:part :arg |
			{
				((SBMoveCommand newFor: self containingArtefact)
					container: signature;
					index: signature submorphCount + 900000000;
					morph: part).
				((SBMoveCommand newFor: self containingArtefact)
					container: signature;
					index: signature submorphCount + 900000000;
					morph: arg)
			}]) flatten, {
		((SBReplaceCommand newFor: self containingArtefact)
			target: self;
			replacer: self receiver)
	})