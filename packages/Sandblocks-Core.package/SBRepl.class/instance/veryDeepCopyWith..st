artefact protocol
veryDeepCopyWith: deepCopier

	| new previousReceiver |
	previousReceiver := self receiver.
	new := super veryDeepCopyWith: deepCopier.
	new receiver: previousReceiver.
	receiver := previousReceiver.
	^ new