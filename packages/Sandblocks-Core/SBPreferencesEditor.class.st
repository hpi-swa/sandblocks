Class {
	#name : #SBPreferencesEditor,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPreferencesEditor >> addPreference: aSymbol of: aClass [

	| pragma |
	pragma := (aClass class lookupSelector: aSymbol) pragmas first.
	
	self
		addToggle: aSymbol
		description: pragma arguments first
		active: (aClass perform: aSymbol)
		onToggle: [:active | aClass perform: aSymbol asSimpleSetter with: active]
]

{ #category : #nil }
SBPreferencesEditor >> addSeparator [

	self addMorphBack: (Morph new
		height: 1;
		hResizing: #spaceFill;
		color: (Color r: 0.0 g: 0.0 b: 0.0))
]

{ #category : #'as yet unclassified' }
SBPreferencesEditor >> addSpacer [

	self addMorphBack: (Morph new
		height: 10;
		color: Color transparent)
]

{ #category : #'as yet unclassified' }
SBPreferencesEditor >> addToggle: aTitlteString description: aString active: aBoolean onToggle: aBlock [

	| checkbox |
	checkbox := SBCheckbox new value: aBoolean.
	checkbox when: #toggled evaluate: [aBlock value: checkbox value].
	^ self addMorphBack: (SBRow new
		cellGap: 8;
		changeTableLayout;
		hResizing: #spaceFill;
		addMorphBack: (SBColumn new
			hResizing: #spaceFill;
			addMorphBack: (SBStringMorph new
				contents: aTitlteString;
				bold);
			addMorphBack: (SBMultilineOwnTextMorph new
				contents: aString;
				maxWidth: 300));
		addMorphBack: checkbox)
]

{ #category : #'as yet unclassified' }
SBPreferencesEditor >> example [

	SBMorphExample
		setUp: [self class new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 400 @ 284
]

{ #category : #'as yet unclassified' }
SBPreferencesEditor >> initialize [

	super initialize.
	
	self
		attachDecorator: SBForceMoveDecorator newConfigured;
		changeTableLayout;
		listDirection: #topToBottom;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 8;
		cellGap: 10;
		addMorphBack: (SBStringMorph new
			contents: 'Plugins';
			bold);
		addSeparator.
	
	SBBlock allSubclassesDo: [:cl |
		Pragma withPragmasIn: cl class do: [:pragma |
			pragma keyword = #plugin: ifTrue: [ | pluginClass |
				pluginClass := pragma methodClass theNonMetaClass.
				self
					addToggle: pluginClass name
					description: pragma arguments first
					active: (SBEditor isPluginActive: pluginClass)
					onToggle: [:active |
						SBEditor setPlugin: pluginClass active: active.
						active
							ifTrue: [self sandblockEditor activatePlugin: pluginClass]
							ifFalse: [self sandblockEditor deactivatePlugin: pluginClass]]]]].
	
	
	self
		addSpacer;
		addMorphBack: (SBStringMorph new
			contents: 'Settings';
			bold);
		addSeparator.
	
	self addPreference: #drawOnCanvas of: SBPreferences.
	self addPreference: #addSandblocksDefault of: CodeHolder
]