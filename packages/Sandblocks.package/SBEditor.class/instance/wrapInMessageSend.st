as yet unclassified
wrapInMessageSend

	self do: (SBWrapCommand new
		outer: SBMessageSend new;
		inner: self selection;
		wrap: [:outer :inner | outer receiver: inner selector: #'' arguments: #()];
		yourself)