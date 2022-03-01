generate-html
exampleHTMLTemplateForExample: aJsObject withCaptures: aDictWithBlockCaptures

	| usedComponentReplacements usedReactComponentsSourceStrings aJsObjectString |
	usedComponentReplacements := (aDictWithBlockCaptures at: 'class') collectJSXElementReplacements asOrderedCollection.
	usedReactComponentsSourceStrings := usedComponentReplacements
		ifEmpty: ['']
		ifNotEmpty: [(usedComponentReplacements collect: [:aSBJsComponentUsageReplacement | aSBJsComponentUsageReplacement componentWrapper sourceString]) joinSeparatedBy: ' '].
	aJsObjectString := aDictWithBlockCaptures
		at: 'shared_example_props'
		ifPresent: [:anotherJsObject | anotherJsObject sourceString]
		ifAbsent: ['sharedExampleProps = {}'].
	^ '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />

    <meta
      name="description"
      content="component testing example page"
    />
   <script src="https://unpkg.com/react@17.0.2/umd/react.production.min.js"></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
<link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
<style>
 	/* Here is the place to add static CSS.*/
	body {
        margin: 0;
        font-family: Arial, Helvetica, sans-serif;
      }

      .topnav {
        background-color: #333;
        position: sticky;
        top: 0px;
        width: 100%;
        height: 48px;
      }

      .topnav > a,
      .topnav > span,
      .topnav > div {
        float: left;
        color: #f2f2f2;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        font-size: 17px;
      }

      .topnav > a:hover,
      .topnav > span:hover,
      .topnav > div:hover {
        background-color: #ddd;
        color: black;
      }

      .main-content {
        text-align: center;
        padding: 40px 25%;
      }

      .topnav a.active {
        background-color: #04aa6d;
        color: white;
      }

      table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
      }

      td,
      th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 8px;
      }

      tr:nth-child(even) {
        background-color: #dddddd;
      }
      .search-container input[type="text"] {
        padding: 6px;
        margin-top: 8px;
        font-size: 17px;
        border-color: #ddd;
        border-style: double;
      }

      .search-container button {
        padding: 8px 10px;
        margin-top: 8px;
        margin-right: 16px;
        background: #ddd;
        font-size: 17px;
        border: none;
        cursor: pointer;
      }

      @keyframes spin {
        100% {
          transform: rotate(360deg);
        }
      }

      #snackbar {
        visibility: hidden;
        min-width: 250px;
        margin-left: -125px;
        background-color: #555;
        color: #fff;
        text-align: center;
        border-radius: 2px;
        padding: 16px;
        position: fixed;
        z-index: 1;
        left: 50%;
        bottom: 30px;
        font-size: 17px;
      }

      #snackbar.show {
        visibility: visible;
        -webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
        animation: fadein 0.5s, fadeout 0.5s 2.5s;
      }

      @-webkit-keyframes fadein {
        from {
          bottom: 0;
          opacity: 0;
        }
        to {
          bottom: 30px;
          opacity: 1;
        }
      }

      @keyframes fadein {
        from {
          bottom: 0;
          opacity: 0;
        }
        to {
          bottom: 30px;
          opacity: 1;
        }
      }

      @-webkit-keyframes fadeout {
        from {
          bottom: 30px;
          opacity: 1;
        }
        to {
          bottom: 0;
          opacity: 0;
        }
      }

      @keyframes fadeout {
        from {
          bottom: 30px;
          opacity: 1;
        }
        to {
          bottom: 0;
          opacity: 0;
        }
      }

      .dropbtn {
        background-color: #4caf50;
        color: white;
        padding: 16px;
        font-size: 16px;
        border: none;
        cursor: pointer;
      }

      .dropdown {
        position: relative;
        display: inline-block;
      }

      .dropdown-content {
        position: absolute;
        right: 0;
        background-color: #ddd;
        padding: 8px;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
        z-index: 10;
      }

      .dropdown-background {
        position: fixed;
        width: 100%;
        height: 100%;
        top: 0px;
        left: 0px;
        z-index: 9;
        background-color: rgba(0, 0, 0, 0.2);
      }

      .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
      }

      .dropdown-content a:hover {
        background-color: #f1f1f1;
      }

      .dropdown:hover .dropbtn {
        background-color: #3e8e41;
      }
      hr {
        display: block;
        height: 1px;
        border: 0;
        border-top: 1px solid #ccc;
        margin: 1em 0;
        padding: 0;
      }
      .login-wrapper {
        display: inline-block;
      }
      .login-wrapper .div {
        padding: 12px;
        text-align: left;
      }
      .error {
        color: red;
      }
	</style>
    <title>Example</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">failed loading component ...</div>
    <script type="text/babel">
', usedReactComponentsSourceStrings, (aDictWithBlockCaptures at: 'class') sourceString, '
	const ', aJsObjectString, ';
	const { componentProps, parentProps } = ', aJsObject sourceString, ';
      ReactDOM.render(
		<div {...parentProps}>
            	<', (aDictWithBlockCaptures at: 'class_name') contents, ' {...componentProps} />
  	       </div>, 
		document.getElementById("root"));
    </script>
  </body>
</html>'