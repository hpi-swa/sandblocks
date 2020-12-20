as yet unclassified
matchesEvent: anEvent

	| shiftedKeys |
	SBToggledCode
		comment: 'needs to be adapted per keyboard layout'
		active: 1
		do: {
			[
				shiftedKeys := #($: $" $! $$ $% $/ $( $) $= $; $_ $* $')]
		}.
	^ anEvent keyCharacter = character and: [
		command = (anEvent commandKeyPressed or: [anEvent controlKeyPressed]) and: [
			anEvent optionKeyPressed = self option and: [
				(shift or: [character isUppercase]) = anEvent shiftPressed or: [
					(anEvent keyCharacter <= 32 and: [shift = anEvent shiftPressed]) or: [shiftedKeys includes: anEvent keyCharacter]]]]]