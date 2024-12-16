<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- Output specification -->
    <xsl:output method="xhtml" encoding="UTF-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- Variables -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    
    <!-- Main Template -->
    <xsl:template match="/">
        <xsl:result-document href="../docs/reading_view_with_navigation.html">
            <html>
                <head>
                    <title>Reading View with Navigation</title>
                    <link type="text/css" href="Romeo_and_Juliet.css" rel="stylesheet" />
                    <link type="text/css" href="Tabs.css" rel="stylesheet" />
                    <link type="text/css" href="dropdownMenu.css" rel="stylesheet" />
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
                                <a href="reading_view_with_navigation.html">Reading View - Scene Navigation</a>
                                <a href="color_coding_sex_house.html">Reading View - Color-coding Sex and House</a>
                            </div>
                        </div>
                        <div><a href="teamTab.html">Team Info</a></div>
                    </nav>
                    
                    <!-- Scene Navigation -->
                    <div class="scene-nav">
                        <h2>Scene Navigation</h2>
                        <xsl:for-each select="$playFile//act">
                            <!-- Act Title -->
                            <h3>
                                <a href="#{generate-id()}">
                                    <xsl:value-of select="title"/>
                                </a>
                            </h3>
                            <!-- Scenes under the act -->
                            <xsl:for-each select="scene">
                                <a href="#scene-{generate-id()}">Scene <xsl:value-of select="@n"/></a>
                            </xsl:for-each>
                        </xsl:for-each>
                    </div>
                    
                    <!-- Content Area -->
                    <div class="content">
                        <xsl:apply-templates select="$playFile//ShakespearPlay"/>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Process Acts -->
    <xsl:template match="act">
        <h1 id="{generate-id()}">
            <xsl:value-of select="title"/>
        </h1>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Process Scene Titles -->
    <xsl:template match="scene">
        <h2 id="scene-{generate-id()}">
            Scene <xsl:value-of select="@n"/>
        </h2>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Process Speeches -->
    <xsl:template match="speech">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- Style Speaker Names -->
    <xsl:template match="speaker">
        <span class="speaker">
            <xsl:apply-templates/>
            <xsl:text>: </xsl:text>
        </span>
    </xsl:template>
    
    <!-- Line Breaks -->
    <xsl:template match="br">
        <br/>
    </xsl:template>
</xsl:stylesheet>
