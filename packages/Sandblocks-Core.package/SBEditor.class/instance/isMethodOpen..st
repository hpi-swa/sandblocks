accessing
isMethodOpen: aCompiledMethod

	^ self methods anySatisfy: [:method | method selector = aCompiledMethod selector and: [method methodClass = aCompiledMethod methodClass]]