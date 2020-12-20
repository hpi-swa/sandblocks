as yet unclassified
do

	| nextSelection nextBlock |
	nextBlock := target containingSandblock.
	oldOwner := target owner.
	nextSelection := (target submorphAfter ifNil: [target submorphBefore]) ifNotNil: [:m | m containingSandblock].
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	^ nextBlock focusAfterDeleteIfNone: [nextSelection ifNil: [oldOwner containingSandblock]]