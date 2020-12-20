actions
openClass: aClass

	| cl |
	cl := self open: aClass.
	aClass methodsDo: [:m | self open: m].
	^ cl