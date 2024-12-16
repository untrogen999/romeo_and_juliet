<?xml version="1.0" encoding="UTF-8"?>

<!-- Unified reading view stylesheet by Aania, Nidhi, and Avi. Aania's stylesheet was the basis
    for this file, while the color-coding-related templates and styling were Nidhi's work.
    Avi created this file and took whatever was needed from both files to combine the two reading
    view stylesheets into this one new stylesheet.
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
                    <link type="text/css" href="Colorcode.css" rel="stylesheet" />
                    <style>
                        /* AZ: Define the First Folio font so that it can be referenced in the rest of the file */
                        @font-face {
                            /* AZ: Full font name is "Shakespeare First Folio, Bold" */
                            font-family: "FirstFolio";
                            src: url("images/Shakespeare_First_Folio_Font.otf");
                            font-weight: normal;
                            font-style: normal;
                        }
                        
                        body {
                            font-family: "Times New Roman", "serif";
                            line-height: 1.6;
                            margin: 20px;
                        }
                        
                        .scene-nav {
                            position: fixed;
                            top: 10px;
                            left: 10px;
                            background: #f4f4f4;
                            border: 1px solid #ddd;
                            padding: 10px;
                            width: 200px;
                            height: calc(100vh - 20px);
                            overflow-y: auto;
                        }
                        
                        .scene-nav a {
                            display: block;
                            margin: 5px 0;
                            text-decoration: none;
                            color: black;
                        }
                        
                        .scene-nav a:hover {
                            text-decoration: underline;
                        }
                        
                        .content {
                            margin-left: 230px;
                            padding: 10px;
                        }
                        
                        h1, h2 {
                            color: #333;
                        }
                        
                        h1 {
                            font-size: 24px;
                            margin-top: 20px;
                        }
                        
                        h2 {
                            font-size: 20px;
                            margin-top: 20px;
                        }
                        
                        .speaker {
                            font-weight: bold;
                        }
                        
                        i {
                            color: #555;
                        }
                        
                        /* AZ: Titles gotta look old-fashioned */
                        .title {
                            font-family: "FirstFolio";
                        }
                        
                        /* AZ: Styles stage directions */
                        .stagedirection {
                            font-style: italic;
                        }
                        
                    </style>
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
        
        <!-- Sex attribute in paragraph element itself, house attribute in the inner span -->
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
