<?xml version="1.0" encoding="UTF-8"?>

<!-- This is a draft! -->

<!-- Stylesheet to generate a reading view that styles terms/phrases in the index, by Avi Zilberman -->
<!-- Run this stylesheet on the XML file "thePlay_MJB_fixed_tagging.xml" in oXygen -->

<!-- AZ: Notice I define my own project namespace -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:az="replaceTerms"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- AZ: Tells oXygen to just copy and output all XML with no matching templates as-is, I think. -->
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- Specify options for the output document -->
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- AZ: Store the index file as a variable -->
    <xsl:variable name="indexFile" select="document('../xml/avi_index_markup.xml')"/>
    <xsl:key name="indexEntries" match="$indexFile//entry" use="term/text()"/>
    
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <!-- AZ: Always output to a new XML file with the given name -->
        <xsl:result-document href="../docs/reading_view_index.html">
            <html>
                <head>
                    <title>Avi's Romeo and Juliet Reading View</title>
                </head>
                <body>
                    <xsl:apply-templates select="ShakespearPlay"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- AZ: Don't output the element itself, just its contents -->
    <xsl:template match="ShakespearPlay">
        <xsl:apply-templates select="act"/>
    </xsl:template>
    
    <xsl:template match="act">
        <!-- AZ: Special heading for the title of acts -->
        <h1><xsl:apply-templates select="title/text()"/></h1>
        <xsl:apply-templates select="scene"/>
    </xsl:template>
    
    <xsl:template match="scene">
        <!-- AZ: Special heading for the title of scenes -->
        <h2><xsl:apply-templates select="title/text()"/></h2>
        <xsl:apply-templates select="speech"/>
    </xsl:template>
    
    <!-- AZ: Put speeches in an HTML paragraph -->
    <xsl:template match="speech">
        <p>
            <xsl:apply-templates select="speaker"/>
            <!-- AZ: Replace all terms in the speech text and output the resulting text -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- AZ: For each piece of text in the speech -->
    <xsl:template match="speech/text()">
        <xsl:apply-templates select="az:replaceTerms(., key('indexEntries', ''))"/>
    </xsl:template>
    
    <!-- AZ: Style the speakers in a special way -->
    <xsl:template match="speaker">
        <span style='color: red;'>
            <xsl:apply-templates/>
            <xsl:text>: </xsl:text>
        </span>
    </xsl:template>
    
    <!-- AZ: The HTML equivalent of <br/> is exactly the same element --> 
    <xsl:template match="br">
        <br/>
    </xsl:template>
    
    
    <!-- AZ: Custom function. Looks for terms in the given text, then
        replaces any that are found in the given index.
        See this link for how to make your own functions: http://dh.obdurodon.org/xslt-functions.xhtml -->
    <xsl:function name="az:replaceTerms">
        <xsl:param name="text"/>
        <xsl:param name="terms"/>
        
        <xsl:choose>
            <!-- AZ: If there are no terms from the index found in the given text, just
                return the text as-is -->
            <xsl:when test="empty($terms)">
                <xsl:value-of select="$text"/>
            </xsl:when>
            <!-- AZ: Otherwise, replace the first term from the index found in the text,
                then call this function recursively with the next term in the index -->
            <xsl:otherwise>
                <!-- AZ: Remember the current and remaining terms -->
                <xsl:variable name="term" select="$terms[1]"/>
                <xsl:variable name="remainingTerms" select="$terms[position() > 1]"/>
                
                <!-- AZ: The variables needed to replace the text -->
                <xsl:variable name="replacement">
                    <!-- Test replacement. Intended to make it obvious that a term was found and replaced -->
                    <xsl:value-of select="upper-case($term)"/>
                    
                    <!-- The "true" replacement. Uncomment after testing replacement above
                        is not needed anymore -->
                    <!-- <span style="font-weight: bold;"> -->
                    <!--<xsl:text disable-output-escaping="yes">&lt;span style=&quot;font-weight: bold;&quot;&gt;</xsl:text>-->
                    <!--<xsl:value-of select="$term"/>-->
                    <!-- </span> -->
                    <!--<xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>-->
                </xsl:variable>
                <xsl:variable name="updatedText" select="replace($text, $term, $replacement)"/>
                
                <!-- AZ: Recursively call this same function with the updated text, but don't
                    include the term we just replaced.
                    This function will stop calling itself (reach the base case) if there are no
                    terms left in the text to replace -->
                <xsl:value-of select="az:replaceTerms($updatedText, $remainingTerms)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>