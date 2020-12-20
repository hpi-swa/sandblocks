as yet unclassified
veryDeepCopyWith: aCopier

	" ensure that we not duplicate our observed object, this may consequences and will usually not be our intent "
	| oldObject copy |
	oldObject := object.
	object := nil.
	copy := super veryDeepCopyWith: aCopier.
	object := oldObject.
	copy object: object.
	^ copy