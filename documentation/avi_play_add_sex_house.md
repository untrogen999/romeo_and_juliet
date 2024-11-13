Stepfile by Avi Zilberman to add sex and house attributes to all speakers in the play's XML.

For an XSLT solution, run the "xslt/avi_add_attributes_to_speakers.xsl" XSLT file on "xml/thePlay_MJB.xml". It does the same replacements as in this file, but automatically.

***

Speakers have any of the following sexes, or neither:

* "F" - Female
* "M" - Male
* "N" - Neither, unknown, or not given

Speakers also are in either of the houses, or neither:

* "M" - House of Montague
* "C" - House of Capulet
* "N" - Neither, unknown, or not given

I looked at the *DRAMATIS PERSONÆ* section and looked at all the unique "@char" values, but didn't do anything more to get the character names.

***

# Step 0

Make a copy of the play XML file that Nidhi fixed in the same folder with a different name.

***

# Step 1

## Add attributes for all male speakers who are in neither house.

List of male speakers in neither house:

* Prince
* Paris
* Mercutio
* Friar Laurence
* Friar John

Find  
	`<speaker char="PERSON_NAME">`  
to replace with  
	`<speaker char="PERSON_NAME" sex="M" house="N">`,  
inserting "PERSON_NAME" for every person in the above list.

***

There are no female speakers who are in neither house.

***

# Step 2

## Add attributes to all speakers in neither house with an unknown/un-given sex.

List of speakers in neither house and with an unknown/un-given sex:

* Apothecary
* 1 Musician
* 2 Musician
* 3 Musician
* Page

Find  
	`<speaker char="PERSON_NAME">`  
to replace with  
	`<speaker char="PERSON_NAME" sex="N" house="N">`,  
inserting "PERSON_NAME" for every person in the above list.

***

# Step 3

## Add attributes to all male speakers in the Montague house.

List of male speakers in Montague's house:

* Montague
* Romeo
* Benvolio
* Balthasar
* Abram

Find  
	`<speaker char="PERSON_NAME">`  
to replace with  
	`<speaker char="PERSON_NAME" sex="M" house="M">`,  
inserting "PERSON_NAME" for every person in the above list.

***

# Step 4

## Add attributes to Lady Montague's speaker element.

Lady Montague is the only female speaker from the Montague house.

Find  
	`<speaker char="Lady Montague">`  
to replace with  
	`<speaker char="Lady Montague" sex="F" house="M">`.

***

There are no speakers with an unknown sex in Montague's house.

***

# Step 5

## Add attributes to all male speakers in the Capulet house.

* Capulet
* Tybalt
* Sampson
* Gregory
* Peter

Find  
	`<speaker char="PERSON_NAME">`  
to replace with  
	`<speaker char="PERSON_NAME" sex="M" house="C">`,  
inserting "PERSON_NAME" for every person in the above list.

***

# Step 6

## Add attributes to all female speakers in the Capulet house.

List of female speakers in Capulet's house:

* Juliet
* Lady Capulet

Find  
	`<speaker char="PERSON_NAME">`  
to replace with  
	`<speaker char="PERSON_NAME" sex="F" house="C">`,  
inserting "PERSON_NAME" for every person in the above list.

***

# Step 7

## Add attributes to all speakers in Capulet's house with an unknown/un-given sex.

List of speakers in the Capulet house with an unknown/un-given sex:

The Nurse to Juliet is the only character in the Capulet house with an unknown sex.

Find  
	`<speaker char="Nurse">`  
to replace with  
	`<speaker char="Nurse" sex="N" house="C">`.

