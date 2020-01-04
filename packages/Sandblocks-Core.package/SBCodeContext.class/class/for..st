as yet unclassified
for: aContext

	^ self new
		pc: aContext pc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself