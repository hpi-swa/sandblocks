[
  FileStream startUp: true.
  TranscriptStream redirectToStdOut: true.
  Deprecation showDeprecationWarnings: false.

  Installer ensureRecentMetacello.

  (Smalltalk at: #MetacelloPlatform) current authorName: 'sbGenerated'.

  (Smalltalk at: #Metacello) new
  baseline: 'Sandblocks';
  repository: 'tonel:///home/runner/work/sandblocks/sandblocks/packages';
  load: #default.

  "Prepare Image a little bit"
  Preferences disable: #showSharedFlaps.
  PluggableSystemWindow allInstances do: #abandon.
  PreferenceWizardMorph allInstances do: #abandon.

  (Smalltalk at: #BaselineOfSandblocks) createSAR.

  (Smalltalk at: #SBEditor) openExample.
  CodeHolder addSandblocks.

  "Wrap up the image and save it"
  TranscriptStream redirectToStdOut: false.
  Deprecation suppressed: false.

  SmalltalkImage current snapshot: true andQuit: true
] on: Error do: [:e |
  e printVerboseOn: FileStream stdout.
  SmalltalkImage current snapshot: false andQuit: true withExitCode: 1.
  FileStream stdout nextPutAll: 'not reached']
