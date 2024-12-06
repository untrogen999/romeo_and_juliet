<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:f="addTermTags"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- AZ: Store the index file as a variable -->
    <xsl:variable name="indexFile" select="document('../xml/avi_index_markup.xml')"/>
    <!--<xsl:key name="indexEntries" match="$indexFile//entry" use="term/text()"/>-->
    <xsl:variable name="indexEntries" select="$indexFile//entry/term/text()"/>
    
    
    <!-- AZ: Make a top-level template to be able to use <xsl:result-document> to output a
        single output file. -->
    <!-- AZ: See this wrox.com thread for an example: https://p2p.wrox.com/xslt/87315-result-document-output-problem-s-identity-transform.html -->
    <xsl:template match='/'>
        <!-- AZ: Always output to a new XML file with the given name -->
        <xsl:result-document href="../docs/reading_view_index_test.html">
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
        <xsl:apply-templates select="act[1]"/>
    </xsl:template>
    
    <xsl:template match="act">
        <!-- AZ: Special heading for the title of acts -->
        <h1><xsl:apply-templates select="title/text()"/></h1>
        <xsl:apply-templates select="scene[1]"/>
    </xsl:template>
    
    <xsl:template match="scene">
        <!-- AZ: Special heading for the title of scenes -->
        <h2><xsl:apply-templates select="title/text()"/></h2>
        <xsl:apply-templates select="speech"/>
    </xsl:template>
    
    <!-- AZ: Put speeches in an HTML paragraph -->
    <xsl:template match="speech">
        <p>
            <!-- AZ: Replace all terms in the speech text and output the resulting text -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!--WHC: can I add an xsl:for-each around here to look for each word in the index file and act on it in the output?-->
    
    <!-- AZ: For each piece of text in the speech -->
    <xsl:template match="speech/text()">        
        <xsl:analyze-string select="." regex="[-'A-Za-z]+">
            <xsl:matching-substring>
                <!-- AZ: NOTE TO SELF: run "tokenize(., '\s')". You will see that it doesn't exclude periods and commas! -->
                <!-- Maybe strip them out somehow? Or at least concat them as-is back. -->
                <xsl:value-of select="f:addTermTags(tokenize(., '\s.'))"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        
        
        <!--<xsl:variable name="text" select="."/>-->
        
        <!-- AZ: Sort the terms primary by the number of words in it (determined by a space) -->
        <!-- AZ: If two terms have the same number of words, sort them both the number of characters they each have -->
        <!--<xsl:for-each select="indexEntries">
            <xsl:sort select=". => tokenize('\s')" order="descending"/>
            <xsl:sort select=". => string-length()" order="descending"/>
            
            
            
            <xsl:choose>
                <xsl:when test="">
                    <span class="term"><xsl:value-of select="."/></span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>-->
    </xsl:template>
    
    <xsl:function name="f:addTermTags" as="item()">
        <xsl:param name="word" as="xs:string"/>
        
        <xsl:choose>
            <!-- AZ: Test if the current word is in the index -->
            <xsl:when test="$indexEntries[$word]">
                Hi when!
            </xsl:when>
            <xsl:otherwise>
                Hi other!
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
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
    
</xsl:stylesheet>