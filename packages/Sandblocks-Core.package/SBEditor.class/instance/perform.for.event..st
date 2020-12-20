shortcuts
perform: anAction for: aBlock event: anEvent
	"
	we used to have a distinction in action that are valid only in input or select mode
	
	((mode = #selection or: [mode = #continuousSelection]) and: [(method pragmaAt: #multiSelectAction) notNil]) or: [
		(mode = #command and: [
		(method pragmaAt: #multiSelectAction) notNil or: [(method pragmaAt: #action) notNil]]) or: [
		mode = #input and: [(method pragmaAt: #inputAction) notNil]]]]."

	(aBlock lookupAction: anAction) ifNotNil: [:method | | validShortcut validMode validInvocation |
		validShortcut := mode ~= #input or: [anEvent anyModifierKeyPressed or: [anEvent keyCharacter isLikelyUnmodifiedOnKeyboard not]].
		validMode := method pragmas anySatisfy: [:p | (mode = #input ifTrue: [#(#action #inputAction #multiSelectAction)] ifFalse: [#(#action #multiSelectAction)]) includes: p keyword].
		validInvocation := (method pragmaAt: #actionValidIf:) ifNotNil: [:pragma | aBlock perform: pragma arguments first] ifNil: [true].
		
		(validShortcut and: [validMode and: [validInvocation]]) ifTrue: [
			aBlock performAction: anAction.
			^ true]].
	^ false