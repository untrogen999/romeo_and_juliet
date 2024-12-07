<?xml version="1.0" encoding="UTF-8"?>

<!-- Template stylesheet for making reading views, by Avi Zilberman -->
<!-- This stylesheet is for everyone to use as a basis to output their own
    HTML reading view -->
<!-- Since the play and list of speaker XML files are grabbed as variables, you can just reference them
    in your XSLT and just give a random XML file to oXygen so it can run this stylesheet -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- Specify options for the HTML output -->
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- AZ: The play's XML file -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    
    <!-- AZ: Store the list of speakers file as a variable -->
    <!-- AZ: You can either look in the play itself or look in this file to grab the sex/gender and house -->
    <xsl:variable name="speakerFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <xsl:template match='/'>
        <!-- AZ: Replace the file name with whatever you want to name your HTML webpage -->
        <xsl:result-document href="../docs/OUTPUT_FILENAME.html">
            <html>
                <head>
                    <!-- AZ: Change the page title to whatever you want -->
                    <title>YOUR WEBPAGE TITLE</title>
                    <link type="text/css" href="Romeo_and_Juliet.css" rel="stylesheet" />
                    <link type="text/css" href="Tabs.css" rel="stylesheet" />
                    <link type="text/css" href="dropdownMenu.css" rel="stylesheet" />
                    <!-- See the "Play.css" file for the classes you can reference in your reading view.
                        Not all of them are used in this template; you'll have to add them yourself if you want them
                    -->
                    <link type="text/css" href="Play.css" rel="stylesheet" />
                </head>
                <body>
                    <!-- AZ: Link to homepage -->
                    <a href="index.html">
                    <h1>Romeo and Juliet Analysis</h1>
                    </a>
                    
                    <!-- AZ: Navigation bar -->
                    <nav>
                        <div><a href="index.html">Homepage</a></div>
                        <div class="dropdown">
                            <a href="analysisTab.html">Analysis</a>
                            <div class="dropdown-content">
                                <a href="play_speech_percentages_chart.html">Speeches per Character Bar Graph</a>
                                <a href="lines_per_scene.html">Lines per Scene Bar Graph</a>
                                
                                <!-- AZ: Change the relevant URL and text to whatever your reading view is about -->
                                <a href="?.html">Table of Contents Reading View</a>
                                <a href="?.html">Color-coding Genders and House Reading View</a>
                            </div>
                        </div>
                        <div><a href="teamTab.html">Team Info</a></div>
                    </nav>
                    
                    <!-- AZ: This actually grabs the play's contents -->
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
        <h1 class="act-title">
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <!-- AZ: Scene titles go in an <h2> -->
    <xsl:template match="$playFile//scene/title">
        <!-- AZ: You can add other classes to the attribute value if you separate them all with a space -->
        <h2 class="scene-title">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <!-- AZ: You may want to style speeches in some special way -->
    <xsl:template match="$playFile//speech">
        <!-- AZ: You can add other classes to the attribute value if you separate them all with a space -->
        <p class="speech">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- AZ: You may want to style speaker names in some special way -->
    <xsl:template match="$playFile//speaker">
        <!-- AZ: You can add other classes to the attribute value if you separate them all with a space -->
        <span class="speaker">
            <xsl:apply-templates/>
            <xsl:text>: </xsl:text>
        </span>
    </xsl:template>
    
    <!-- AZ: The HTML equivalent of <br/> is exactly the same element -->
    <!-- AZ: This template needs to be added to keep the <br/> tags in the output -->
    <xsl:template match="$playFile//br">
        <br/>
    </xsl:template>
    
    <!-- AZ: Stage directions are italicized and in square brackets ([]) -->
    <!-- AZ: You can do something special with this if you want -->
    <xsl:template match="$playFile//stagedirection">
        <!-- AZ: You can add other classes to the attribute value if you separate them all with a space -->
        <span class="stagedirection">[<xsl:apply-templates/>]</span>
    </xsl:template>
</xsl:stylesheet>