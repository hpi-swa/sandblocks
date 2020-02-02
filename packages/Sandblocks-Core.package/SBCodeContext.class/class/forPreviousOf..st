as yet unclassified
forPreviousOf: aContext

	
	^ self new
		pc: aContext previousPc;
		methodClass: aContext methodClass;
		selector: aContext selector;
		stringRepresentation: aContext asString;
		yourself