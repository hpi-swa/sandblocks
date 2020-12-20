as yet unclassified
do: aBlock identifier: aNumber

	^ self cache
		at: aNumber
		ifAbsent: [ | value |
			value := aBlock value.
			self cache at: aNumber put: value.
			self triggerEvent: #cacheChanged with: aNumber.
			value]