<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet to fix some tagging decisions in the play, by Avi Zilberman -->
<!-- Run this stylesheet on the XML file with the sex and house attributes added to it already -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- AZ: Tells oXygen to just copy and output all XML with no matching templates as-is, I think. -->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- Output an XML file -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8"/>
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <!-- AZ: Always output to a new XML file with the given name -->
        <xsl:result-document href="../xml/thePlay_MJB_fixed_tagging_automated_draft.xml">
            <xsl:apply-templates select="ShakespearPlay"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- AZ: Turn <line> elements into <speech> and add <br/> tags -->
    <xsl:template match="line">
        <!-- AZ: I found some inspiration for this code here: https://www.thecodingforums.com/threads/replacing-lt-with-using-xslt.294084/post-1566570
            What this code does is look for lines where the last character is NOT '>' (i.e. not the end of
            an element, like </speech>). Then it reinserts the last character of those lines before ending the line
            with "<br/>\n", written in one regex as "$1&lt;br/&gt;&#xa;" since you can't have angle brackets in the "select" attribute.
            "disable-output-escaping" is set to "yes" so that the angle bracket and newline identifiers get
            converted to the actual characters in the output.
        -->
        <speech><xsl:value-of
            disable-output-escaping="yes"
            select="replace(
                string(),
                '([^>\s])\n',
                '$1&lt;br/&gt;&#xa;'
            )"/></speech>
    </xsl:template>
</xsl:stylesheet>