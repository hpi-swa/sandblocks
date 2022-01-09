Class {
	#name : #SBGitPackageWatcher,
	#superclass : #Object,
	#classVars : [
		'Packages'
	],
	#category : #'Sandblocks-Git'
}

{ #category : #packages }
SBGitPackageWatcher class >> clearTouchedFor: aPackage [

	^ (self recordsFor: aPackage) at: 'touched' put: Set new
]

{ #category : #private }
SBGitPackageWatcher class >> event: anEvent [

	anEvent itemKind = SystemChangeNotifier methodKind ifTrue: [ | method |
		method := anEvent item methodReference.
		self watchedPackages keysAndValuesDo: [:packageName :records | | package isInMyPackage isInMyExtensionCategory methodCategory isInMyOverrideMethods wasInMyExtensionCategory |
			package := PackageInfo named: packageName.
			methodCategory := method category.
			isInMyPackage := package systemCategories includes: method actualClass category.
			isInMyExtensionCategory := package isYourClassExtension: methodCategory.
			wasInMyExtensionCategory := methodCategory isNil and: [(self extensionMethodsFor: package name) includes: method].
			
			" TODO: this slows down saving quite a bit :( "
			isInMyOverrideMethods := false and: [method compiledMethod notNil and: [(package isYourClassExtension: methodCategory) not and: [(package changeRecordForOverriddenMethod: method) notNil]]].
			
			isInMyExtensionCategory
				ifTrue: [(records at: 'extensions') add: method]
				ifFalse: [(records at: 'extensions') remove: method ifAbsent: []].
			
			isInMyOverrideMethods
				ifTrue: [(records at: 'overrides') add: method]
				ifFalse: [(records at: 'overrides') remove: method ifAbsent: []].
			
			(isInMyPackage or: [wasInMyExtensionCategory or: [isInMyExtensionCategory]]) ifTrue: [
				(records at: 'touched') add: method.
				self triggerEvent: #packageTouched withArguments: {package. method}]]]
]

{ #category : #packages }
SBGitPackageWatcher class >> extensionMethodsFor: aPackage [

	^ (self recordsFor: aPackage) at: 'extensions'
]

{ #category : #packages }
SBGitPackageWatcher class >> overridenMethodsFor: aPackage [

	^ (self recordsFor: aPackage) at: 'overrides'
]

{ #category : #private }
SBGitPackageWatcher class >> recordsFor: aPackage [

	^ self watchedPackages at: aPackage ifAbsent: [self watchPackage: aPackage]
]

{ #category : #packages }
SBGitPackageWatcher class >> touchedArtefactsFor: aPackage [

	^ (self recordsFor: aPackage) at: 'touched'
]

{ #category : #packages }
SBGitPackageWatcher class >> unwatchPackage: aPackageName [

	self watchedPackages removeKey: aPackageName ifAbsent: [].
	self watchedPackages ifEmpty: [SystemChangeNotifier uniqueInstance noMoreNotificationsFor: self]
]

{ #category : #private }
SBGitPackageWatcher class >> watchPackage: aString [

	| package |
	self watchedPackages ifEmpty: [
		SystemChangeNotifier uniqueInstance
			notify: self
			ofAllSystemChangesUsing: #event:].
	self assert: aString isString.
	package := PackageInfo named: aString.
	^ self watchedPackages at: aString put: (Dictionary newFrom: {
		'extensions' -> package extensionMethods asSet.
		'overrides' -> package overrideMethods asSet.
		'touched' -> Set new})
]

{ #category : #private }
SBGitPackageWatcher class >> watchedPackages [

	^ Packages ifNil: [Packages := Dictionary new]
]
