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
                    <title>Reading View - Romeo and Juliet</title>
                    <style>
                        body {
                        font-family: Times New Roman, serif;
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
    
    <!-- Stage Directions -->
    <xsl:template match="stagedirection">
        <i>[<xsl:apply-templates/>]</i>
    </xsl:template>
</xsl:stylesheet>
