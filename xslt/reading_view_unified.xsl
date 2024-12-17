<?xml version="1.0" encoding="UTF-8"?>

<!-- Unified reading view stylesheet by the entire team. Aania's stylesheet was the basis
    for this file, while the color-coding-related templates and styling were Nidhi's work.
    Pieces of Myles' site HTML and CSS were used to add and style a navigation bar to the view, based off
    of Nidhi's styling of it for her own reading view.
    Avi created this file and took whatever was needed to combine everything into this one new stylesheet.
-->

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
        <xsl:result-document href="../docs/reading_view_unified.html">
            <html>
                <head>
                    <title>Unified Reading View - Romeo and Juliet</title>
                    <!-- Colors -->
                    <link type="text/css" href="Unified.css" rel="stylesheet" />
                </head>
                <body>
                    <!-- Navigation Sidebar -->
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
                    <main class="content">
                        <!-- AZ: Added id to modify this link specifically -->
                        <a href="index.html">
                            <h1 id="homepage-link">Romeo and Juliet Analysis</h1>
                        </a>
                        
                        <nav>
                            <div><a href="index.html">Homepage</a></div>
                            <div class="dropdown">
                                <a href="analysisTab.html">Analysis</a>
                                <div class="dropdown-content">
                                    <a href="play_speech_percentages_chart.html">Speeches per Character Bar Graph</a>
                                    <a href="lines_per_scene.html">Lines per Scene Bar Graph</a>
                                    <a href="reading_view_with_navigation_AK.html">Table of Contents Reading View</a>
                                    <a href="Color_Coding_sex_house.html">Color-coding Genders and House Reading View</a>
                                    <a href="reading_view_unified.html">Unified Reading View with Table of Contents and Color-coding</a>
                                </div>
                            </div>
                            <div><a href="aboutTab.html">About</a></div>
                            <div><a href="teamTab.html">Team Info</a></div>
                        </nav>
                        
                        <xsl:apply-templates select="$playFile//ShakespearPlay"/>
                    </main>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Process Acts -->
    <xsl:template match="act">
        <!-- Id for linking to, class for styling -->
        <h1 id="{generate-id()}" class="title">
            <xsl:value-of select="title"/>
        </h1>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Process Scene Titles -->
    <xsl:template match="scene">
        <!-- Id for linking to, class for styling -->
        <h2 id="scene-{generate-id()}" class="title">
            Scene <xsl:value-of select="@n"/>
        </h2>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Process Speeches, add color coding -->
    <xsl:template match="speech"> 
        <xsl:variable name="char" select="speaker/@char"/>
        <xsl:variable name="sex" select="speaker/@sex"/>
        <xsl:variable name="house" select="speaker/@house"/>
        
        <!-- AZ: Sex attribute in paragraph element itself, house attribute in the inner span -->
        <p class="{$sex}">
            <span class="{$house}"> 
                <xsl:apply-templates/>
            </span>
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
    
    <!-- Stage Directions -->
    <xsl:template match="stagedirection">
        <span class="stagedirection">[<xsl:apply-templates/>]</span>
    </xsl:template>
</xsl:stylesheet>
