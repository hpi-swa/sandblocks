as yet unclassified
binding: aString for: block class: aClass ifPresent: aBlock

	^ (self isInActiveBlockBody: block)
		ifTrue: [super binding: aString for: block class: aClass ifPresent: aBlock]
		ifFalse: [
			block isDeclaration
				ifTrue: [nil]
				ifFalse: [
					aBlock value: (SBName new
						contents: aString;
						behavior: SBDeclarationForLocalVariable new;
						yourself)]]