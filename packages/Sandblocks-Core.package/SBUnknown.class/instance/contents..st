as yet unclassified
contents: aString

	aString ifNotEmpty: [ | editor |
		editor := self sandblockEditor.
		self acceptCharacter: aString first.
		editor currentInput contents: editor currentInput contents, aString allButFirst]