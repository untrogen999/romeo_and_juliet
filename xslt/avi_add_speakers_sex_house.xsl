<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet to auto-add sex and house attributes to all speakers, by Avi Zilberman -->
<!-- Make sure to select the "thePlay_MJB.xml" file in oXygen before running this stylesheet -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- AZ: Tells oXygen to just copy and output all XML with no matching templates as-is. -->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- AZ: Store the list of speakers file as a variable -->
    <xsl:variable name="speakersFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <xsl:result-document href="../xml/thePlay_MJB_added_speakers_sex_house.xml">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- AZ: Template to add attributes to speakers -->
    <xsl:template match="speaker">
        <!-- AZ: Look up the sex and belonging house of each speaker in "$speakersFile" -->
        <!-- AZ: To work around an issue with referencing "@char" in "$speakerSex" and "$speakerHouse",
            I had to save "@char" to its own variable first. -->
        <xsl:variable name="character" select="@char"/>
        <xsl:variable name="speakerSex" select="$speakersFile//set[ch/text() = $character]/@sex"/>
        <xsl:variable name="speakerHouse" select="$speakersFile//set[ch/text() = $character]/@house"/>
        
        <speaker char="{$character}" sex="{$speakerSex}" house="{$speakerHouse}">
            <xsl:apply-templates/>
        </speaker>
    </xsl:template>
    
</xsl:stylesheet>