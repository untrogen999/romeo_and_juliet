<?xml version="1.0" encoding="UTF-8"?>

<!-- AZ: This stylesheet is for everyone to use as a basis to output their own
    HTML reading view -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- Specify options for the output document -->
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- AZ: The play's XML file -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    
    <!-- AZ: Store the list of speakers file as a variable -->
    <!-- AZ: You can look at this file to look at things like sex/gender and house -->
    <xsl:variable name="speakerFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <!-- AZ: Replace the file name with whatever you want to name your HTML webpage -->
        <xsl:result-document href="../docs/OUTPUT_FILENAME.html">
            <html>
                <head>
                    <title>Avi's Romeo and Juliet Reading View</title>
                </head>
                <body>
                    <xsl:apply-templates select="$playFile//ShakespearPlay"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="$playFile//ShakespearPlay">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- AZ: Act titles go in an <h1> -->
    <xsl:template match="$playFile//act/title">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <!-- AZ: Scene titles go in an <h2> -->
    <xsl:template match="$playFile//scene/title">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <!-- AZ: Speeches go in a <p> -->
    <xsl:template match="$playFile//speech">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- AZ: You may want to style speaker names in some special way -->
    <xsl:template match="$playFile//speaker">
        <!-- AZ: Replace with the class Myles sets up for styling speakers -->
        <span class="special-class-for-styling-speakers">
            <xsl:apply-templates/>
            <xsl:text>: </xsl:text>
        </span>
    </xsl:template>
    
    <!-- AZ: The HTML equivalent of <br/> is exactly the same element -->
    <!-- AZ: This needs to be added to keep the <br/> tags in the output -->
    <xsl:template match="$playFile//br">
        <br/>
    </xsl:template>
    
    <!-- AZ: Stage directions are italicized and in square brackets ([]) -->
    <xsl:template match="$playFile//stagedirection">
        <i>[<xsl:apply-templates/>]</i>
    </xsl:template>
</xsl:stylesheet>