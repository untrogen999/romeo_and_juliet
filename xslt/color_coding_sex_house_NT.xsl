<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- Output description  -->
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- The play's XML file -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    
    <!-- variables,sex&house -->
    <xsl:variable name="speakerFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <!-- main template--> 
    <xsl:template match='/'>
        <!-- AZ: Replace the file name with whatever you want to name your HTML webpage -->
        <xsl:result-document href="../docs/Color_Coding_sex_house.html">
            <html>
                <head>
                    <title>Reading View - Color Coding</title>
                    <link type="text/css" href="Romeo_and_Juliet.css" rel="stylesheet" />
                    <link type="text/css" href="Tabs.css" rel="stylesheet" />
                    <link type="text/css" href="dropdownMenu.css" rel="stylesheet" />
                    <link type="text/css" href="Play.css" rel="stylesheet" />
                    <link type="text/css" href="Colorcode.css" rel="stylesheet" />
                </head>
                <body>
                    <!-- Link to homepage -->
                    <a href="index.html">
                        <h1>Romeo and Juliet Analysis</h1>
                    </a>
                    
                    <!-- Navigation bar -->
                    <nav>
                        <div><a href="index.html">Homepage</a></div>
                        <div class="dropdown">
                            <a href="analysisTab.html">Analysis</a>
                            <div class="dropdown-content">
                                <a href="play_speech_percentages_chart.html">Speeches per Character Bar Graph</a>
                                <a href="lines_per_scene.html">Lines per Scene Bar Graph</a>  
                                <a href="color_coding_sex_house.html"> Reading View - Color-coding Sex and House</a>
                            </div>
                        </div>
                        <div><a href="teamTab.html">Team Info</a></div>
                    </nav>
                    
                    <!-- grabs the play's contents -->
                    <xsl:apply-templates select="$playFile//ShakespearPlay"/>     
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="$playFile//ShakespearPlay">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Act titles: <h1> -->
    <xsl:template match="$playFile//act/title">
        <h1 class="act-title">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <!-- Scene titles:<h2> -->
    <xsl:template match="$playFile//scene/title">
        <h2 class="scene-title">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <!-- speeches with color coding -->
    <xsl:template match="$playFile//speech"> 
        <xsl:variable name="char" select="speaker/@char"/>
        <xsl:variable name="sex" select="speaker/@sex"/>
        <xsl:variable name="house" select="speaker/@house"/>
        
        <p>
            <xsl:attribute name="class">
                <xsl:value-of select="$sex"/>
            </xsl:attribute>
            <span> 
                <xsl:attribute name="class">
                    <xsl:value-of select="$house"/>
                </xsl:attribute>
                <b><xsl:value-of select="speaker"/></b>
                <xsl:text>: </xsl:text>
                <xsl:apply-templates/>
            </span>
        </p>
        
    </xsl:template>
           
    <!-- applying classes based on speakers-->
    <xsl:template match="speaker">
        <b><xsl:apply-templates/>
            <xsl:text>: </xsl:text> </b>
    </xsl:template>
 
    <xsl:template match="$playFile//br">
        <br/>
    </xsl:template>
    
<!-- stage direction-->
    <xsl:template match="$playFile//stagedirection">
        <span class="stagedirection">[<xsl:apply-templates/>]</span>
    </xsl:template>
</xsl:stylesheet>