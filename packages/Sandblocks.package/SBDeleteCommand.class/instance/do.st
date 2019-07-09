as yet unclassified
do

	| nextSelection |
	oldOwner := target owner.
	nextSelection := (target submorphAfter ifNil: [target submorphBefore]) ifNotNil: [:m | m containingSandblock].
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	^ nextSelection ifNil: [oldOwner]