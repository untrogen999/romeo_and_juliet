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
    
    <!-- Output an XML file -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8"/>
    
    <!-- AZ: Store the list of speakers file as a variable -->
    <xsl:variable name="speakersFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <!-- AZ: Always output to a new XML file with the given name -->
        <xsl:result-document href="../xml/thePlay_MJB_added_speakers_sex_house.xml">
            <!-- AZ: Select the schema association itself -->
            <xsl:apply-templates select="processing-instruction('xml-model')"/>
            
            <xsl:apply-templates select="ShakespearPlay"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- AZ: Match on the name of the schema association -->
    <xsl:template match="processing-instruction('xml-model')">
        <!-- AZ: This obscure version of a schema association is written like this because if
            we type out the output schema association as-is, literally nothing will be output despite this
            template being matched on the schema association.
            Thus, the angle brackets < and > are escaped by "&lt;" and "&gt;" so the contents are not treated
            as a node or element.
            Also, by default "disable-output-escaping" is set to "no", meaning that "&lt;" and "&gt;"
            will NOT be converted to the actual angle brackets in the output. Thus we need to set it to "yes".
            "&#xa;" is the newline character and one is added both before and after the schema association.
        -->
        <xsl:text disable-output-escaping="yes">&#xa;&lt;?xml-model href="../schema/thePlay_MJB_sex_house.rnc" type="application/relax-ng-compact-syntax"?&gt;&#xa;</xsl:text>
    </xsl:template>
    
    <!-- AZ: Template to add attributes to speakers -->
    <xsl:template match="speaker">
        <!-- AZ: Look up the sex and belonging house of each speaker in "$speakersFile" -->
        <!-- AZ: To work around an issue with referencing "@char" in "$speakerSex" and "$speakerHouse",
            I had to save "@char" to its own variable first. -->
        <xsl:variable name="character" select="@char"/>
        <xsl:variable name="sex" select="$speakersFile//set[ch/text() = $character]/@sex"/>
        <xsl:variable name="house" select="$speakersFile//set[ch/text() = $character]/@house"/>
        
        <speaker char="{$character}" sex="{$sex}" house="{$house}">
            <xsl:apply-templates/>
        </speaker>
    </xsl:template>
    
</xsl:stylesheet>