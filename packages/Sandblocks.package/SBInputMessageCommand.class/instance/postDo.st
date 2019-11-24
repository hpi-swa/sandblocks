as yet unclassified
postDo

	" if we just changed from unary to keyword message, instead of editing the message edit the new argument "
	(previousSelector asSymbol isUnary and: [newSelector asSymbol isKeyword])
		ifTrue: [
			select sandblockEditor
				select: newArguments first;
				startInput: newArguments first at: 1 replacingContents: false]
		ifFalse: [
			editInputIndex ifNotNil: [
				select sandblockEditor startInput: select at: 1 replacingContents: false.
				select signature focusPartAt: editInputIndex]]