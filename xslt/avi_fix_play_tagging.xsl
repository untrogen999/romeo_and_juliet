<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet to fix some tagging decisions in the play and add @sex and @house attributes
    to speakers, by Avi Zilberman -->
<!-- Run this stylesheet on the XML file "thePlay_MJB.xml" in oXygen -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- AZ: Tells oXygen to just copy and output all XML with no matching templates as-is, I think. -->
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
        <xsl:result-document href="../xml/thePlay_MJB_fixed_tagging.xml">
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
        <xsl:text disable-output-escaping="yes">&#xa;&lt;?xml-model href="../schema/thePlay_MJB_fixed_tagging.rnc" type="application/relax-ng-compact-syntax"?&gt;&#xa;</xsl:text>
    </xsl:template>
    
    <!-- AZ: Add @sex and @house attributes to speakers -->
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
    
    <!-- AZ: Add <br/> tags in the text of *all* elements with multiple lines (not each element as one whole)
        This excludes elements that are only a single line and it excludes the last line of
        elements that have multiple lines, because the last line always ends with a ">" character that closes the element.
        This template also only works on the text, so child elements (ex. <stagedirection> inside a <line>)
        are passed through as-is.
    -->
    <xsl:template match="*/text()">
        <!-- AZ: What this code does is look for lines where the last character is NOT '>' (i.e. not the end of
            an element, like </speech>). Then it reinserts the last character of those lines before ending the line
            with "<br/>\n", written in one regex as "$1&lt;br/&gt;&#xa;" since you can't have angle brackets in the "select" attribute.
            "disable-output-escaping" is set to "yes" so that the angle bracket and newline identifiers get
            converted to the actual characters in the output.
            I found some inspiration for this code here: https://www.thecodingforums.com/threads/replacing-lt-with-using-xslt.294084/post-1566570
        -->
        <xsl:value-of
            disable-output-escaping="yes"
            select="replace(
                .,
                '([^>\s])\n',
                '$1&lt;br/&gt;&#xa;'
            )"
        />
    </xsl:template>
    
    <!-- AZ: Convert all <line> elements to <speech> --> 
    <xsl:template match="line">
        <speech><xsl:apply-templates/></speech>
    </xsl:template>
</xsl:stylesheet>