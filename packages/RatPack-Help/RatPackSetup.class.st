Class {
	#name : #RatPackSetup,
	#superclass : #RatPackHelp,
	#category : #'RatPack-Help'
}

{ #category : #accessing }
RatPackSetup class >> bookName [ 

	^ 'Setting up the environment'
]

{ #category : #pages }
RatPackSetup class >> overview [
	^HelpTopic 
		title: 'Overview'
		contents: 'In this section, we will go over initial steps that should be taken in order to efficiently use RatPack.' 
]

{ #category : #pages }
RatPackSetup class >> page0 [

	^HelpTopic
		title: '0. Baseline Setup Command'
		contents: 
'Baseline Setup Command

To properly setup the baseline for RatPack use this in your workspace: 

	Metacello new
		repository: ''github://hpi-swa-teaching/RatPack2.0:develop/packages'';
		baseline: ''RatPack'';
		load' 

]

{ #category : #pages }
RatPackSetup class >> page1 [
	
	^HelpTopic
		title: '1. Setting up PostgreSQLl'
		contents: 
'RatPack currently support two database backends, PostgreSQL and a virtual database that stores all data as objects in your squeak image.

If you don''t specify a database for a web application based on RatPack, it will use a image database by default.
		
To run the tests, it''s necessary to set up the postgres backend. We also recommend using this for production environments.
The tests expect the postgres server at 

	localhost:5432
	user ''postgres''
	password ''bird'' 
	database name ''squeakdb''.
		
On Windows, we recommend using the graphical installer by BigSQL:

	https://www.openscg.com/bigsql/postgresql/installers.jsp/

On Linux, we recommend using the package manager.
	For installation on arch Linux, see this page: 	
		
		https://wiki.archlinux.org/index.php/PostgreSQL
		
	For installation on Ubuntu or Debian, a simple 
	
		''sudo apt install postgresql''
		 
	should be enough.
	
Afterwards, you need to create the database called ''squeakdb'' and set the password of the ''postgres'' user to ''bird''.
On Linux, this can be done with:
	
	sudo su - postgres # access postgres user
	createdb squeakdb  # create database needed by ratpack tests
	psql -s squeakdb   # enter SQL prompt
	alter user postgres with password ''bird'';
	
On Windows, do equivalent actions in the tools provided.
!'
]

{ #category : #accessing }
RatPackSetup class >> pages [
	^#(overview page0 page1)
]

{ #category : #accessing }
RatPackSetup class >> priority [ 

	^ 1
]
