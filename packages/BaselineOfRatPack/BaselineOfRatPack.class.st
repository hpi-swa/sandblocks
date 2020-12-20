Class {
	#name : #BaselineOfRatPack,
	#superclass : #BaselineOf,
	#category : #BaselineOfRatPack
}

{ #category : #baseline }
BaselineOfRatPack >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec configuration: 'KomHttpServer' with: [
			spec
				version: #stable;
				repository: 'http://www.squeaksource.com/MetacelloRepository'].
		spec
			package: 'RatPack-Core' with: [spec requires: #('KomHttpServer' 'RatPack-Help' 'RatPack-Templating' 'RatPack-UI')];
			package: 'RatPack-Examples' with: [spec requires: #('default')];
			package: 'RatPack-Help';
			package: 'RatPack-Templating';
			package: 'RatPack-Testing' with: [spec requires: #('default')];
			package: 'RatPack-UI'].

	spec for: #squeak do: [
		spec package: 'Cryptography' with: [
			spec repository: 'http://www.squeaksource.com/Cryptography' ].
		spec package: 'PostgresV2' with: [
			spec repository: 'http://www.squeaksource.com/PostgresV2';
				file: 'PostgresV2-EdwinDH.29'].
		spec package: 'VB-Regex' with: [
			spec repository: 'http://www.squeaksource.com/Regex' ].
		spec package: 'JSON' with: [
			spec repository: 'http://www.squeaksource.com/JSON' ].
		spec package: 'RatPack-Core' with: [
			spec requires: #('KomHttpServer' 'VB-Regex' 'JSON' 'Cryptography' 'PostgresV2').
			spec postLoadDoIt: #squeakRegisterInWorldMenu].
	spec
				group: 'default' with: #('RatPack-Core');
				group: 'example' with: #('RatPack-Examples');
				group: 'TravisCI' with: #('RatPack-Testing')];
				yourself

]

{ #category : #doits }
BaselineOfRatPack >> squeakRegisterInWorldMenu [

	Smalltalk globals
		at: #TheWorldMenu
		ifPresent: [:class |
			class
				registerOpenCommand:
					{'RatPack Control Panel'.
					{(Smalltalk at: #RPControlPanel).
					#open}.
					'The RatPack Control Panel allows managing RatPack applications'} ]
]
