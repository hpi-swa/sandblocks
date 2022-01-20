Class {
	#name : #SBPreferencesEditor,
	#superclass : #SBBlock,
	#instVars : [
		'themes'
	],
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
SBPreferencesEditor >> addTheme: aTheme [

	| preview checkbox |
	preview := (SBStMethod new
		selector: 'step' arguments: #() class: Object;
		body: (SBStBlockBody new in: [:b | b statements: {'self = 5 ifTrue: [5 squared]' parseAsSandblock}]))
		layoutInset: 2;
		localColorPolicy: aTheme.
	SBSelection new addMorphBack: preview.
	
	checkbox := SBCheckbox new
		value: SBEditor defaultColorPolicy = aTheme;
		radioButtonLook: true.
	checkbox when: #toggled evaluate: [
		themes childSandblocksDo: [:check | check value: check = checkbox].
		SBEditor defaultColorPolicy: aTheme.
		self sandblockEditor colorPolicy: aTheme new].
	themes addMorphBack: (SBRow new
		cellGap: 10;
		addMorphBack: preview imageForm asMorph;
		addMorphBack: checkbox)
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
		addMorphBack: (SBRow new
			changeTableLayout;
			hResizing: #spaceFill;
			cellPositioning: #leftCenter;
			addMorphBack: (SBStringMorph new
				contents: 'Settings';
				bold);
			addMorphBack: (Morph new
				height: 0;
				color: Color transparent;
				hResizing: #spaceFill);
			addMorphBack: (SBButton new
				icon: SBIcon iconCogs
					shortcut: nil
					do: [PreferenceBrowser open selectedCategory: 'Sandblocks'];
				balloonText: 'Browse all settings'));
		addSeparator.
	
	self addPreference: #drawOnCanvas of: SBPreferences.
	self addPreference: #addSandblocksDefault of: CodeHolder.
	self addPreference: #suggestionsOnClick of: SBPreferences.
	self addPreference: #largeInsets of: SBPreferences.
	
	self
		addSpacer;
		addMorphBack: (SBStringMorph new
			contents: 'Themes';
			bold);
		addSeparator.
	
	self addMorphBack: (themes := SBColumn new
		hResizing: #spaceFill;
		changeTableLayout).
	self addTheme: SBLightPlusTheme.
	self addTheme: SBSolarizedTheme.
	self addTheme: SBSolarizedDarkTheme.
	self addTheme: SBColorMinimalPolicy.
	self addTheme: SBTextColorPolicy.
	self addTheme: SBScratchColorPolicy
]
