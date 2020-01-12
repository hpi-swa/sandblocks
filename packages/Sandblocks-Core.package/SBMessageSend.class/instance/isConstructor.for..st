as yet unclassified
isConstructor: aString for: aClass

	^ self receiver isBinding and: [self receiver contents = aClass name] and: [self selector = aString]