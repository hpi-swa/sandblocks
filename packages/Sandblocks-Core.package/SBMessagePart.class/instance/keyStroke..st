as yet unclassified
keyStroke: anEvent

	"(anEvent keyCharacter = Character space or: [
		self actualContents notEmpty and: [
			self isBinary not and: [anEvent keyCharacter isSpecial]]]) ifTrue: [^ self wrapInMessageSend: anEvent]."
	
	((anEvent keyCharacter isAlphaNumeric or: [#($' $#) includes: anEvent keyCharacter]) and: [self isBinary]) ifTrue: [^ self continueInputInArgument: anEvent].
	
	anEvent keyCharacter = $: ifTrue: [^ self insertUnknownAfterAndInput: true].
	
	(({Character backspace. Character delete. $_} includes: anEvent keyCharacter) or: [
		(anEvent keyCharacter isSpecial and: [self actualContents isEmpty or: [self isBinary]]) or: [
			anEvent keyCharacter isAlphaNumeric and: [
				self actualContents isEmpty or: [self isBinary not]]]]) ifTrue: [
		text keyStroke: anEvent.
		(anEvent keyCharacter isSpecial and: [
			self actualContents size = 1 and: [self isFirstPart]]) ifTrue: [^ self insertUnknownAfterAndInput: false].
		^ self updateSuggestions].
	
	SBSmalltalkGrammarHandler new perform: anEvent keyCharacter for: self parentSandblock empty: false