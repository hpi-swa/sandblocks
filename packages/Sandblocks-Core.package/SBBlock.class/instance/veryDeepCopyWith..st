event handling
veryDeepCopyWith: aCopier

	| new previousDecorators |
	new := super veryDeepCopyWith: aCopier.
	previousDecorators := new decorators copy.
	previousDecorators do: #detach.
	previousDecorators do: [:decorator | new attachDecorator: decorator].
	^ new