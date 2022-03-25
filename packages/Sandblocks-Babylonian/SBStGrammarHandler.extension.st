Extension { #name : #SBStGrammarHandler }

{ #category : #'*Sandblocks-Babylonian' }
SBStGrammarHandler >> addExample [
	<action>

	| method class |
	self block isExample ifTrue: [^ self block toggleRunning].
	
	method := self block containingArtefact.
	class := method methodClass.
	
	self block sandblockEditor do: (SBInsertCommand new
		container: method body;
		index: 2;
		morph: (SBExample new
			self: (method isClassSide ifTrue: [SBStName contents: class theNonMetaClassName] ifFalse: [
				SBStMessageSend new
					receiver: (SBStName contents: class name)
					selector: (method selector = #initialize ifTrue: [#basicNew] ifFalse: [#new])])
			args: (SBStArray new
				type: #dynamic
				contents: (Array streamContents: [:str | method arguments size timesRepeat: [str nextPut: self block newNullBlock]]))
			label: 'example'))
]
