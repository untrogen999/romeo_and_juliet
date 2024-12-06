<?xml version="1.0" encoding="UTF-8"?>

<!-- SVG work for the Romeo and Juliet project by Aania Khalid and Avi Zilberman, outputted as an HTML page. -->
<!-- Aania manually wrote the initial draft SVG as the basis, and Avi made this XSLT to generate a slightly modified version of it -->
<!-- Run this stylesheet on the play fixed_tagging XML file. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- AZ: HTML output with embedded SVG -->
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
    <!-- AZ: Variables unrelated to the axes -->
    <xsl:variable name="speechTotal" select="count(//speech)"/>
    <xsl:variable name="sceneTotal" select="count(//scene)"/>
    <!-- AZ: Count the lines in the scene with the most lines in it across the entire play. Add one to include the last line. -->
    <xsl:variable name="sceneMaxLines" select="max(//scene/count(.//br)) + 1"/>
    
    <!-- AZ: Variables related to the x-axis -->
    <xsl:variable name="xSpacer" select="$sceneMaxLines div $sceneTotal"/>
    <!-- AZ: Add the length by a little bit to extend the horizontal axis further right -->
    <xsl:variable name="xLength" select="$sceneMaxLines * $barScale + 50"/>
    <!-- AZ: Used for positioning the title text and horizontal axis label -->
    <xsl:variable name="xMiddle" select="$xLength div 2"/>
    
    <!-- AZ: Variables related to the y-axis -->
    <xsl:variable name="ySpacer" select="50"/>
    <xsl:variable name="yLength" select="$sceneTotal * $ySpacer"/>
    <!-- AZ: Used for positioning the vertical axis label -->
    <xsl:variable name="yMiddle" select="$yLength div 2"/>
    
    <!-- AZ: Styling variables -->
    <xsl:variable name="barScale" select="2"/>
    <!-- AZ: The empty space between any two scenes' bars -->
    <xsl:variable name="sceneSpacer" select="10"/>
    <!-- AZ: Set the width of the bar for each $sceneSpacer such that there is always $sceneSpacer
        pixels of empty space between the scenes' bars -->
    <xsl:variable name="barWidth" select="$ySpacer - $sceneSpacer"/>
    
    <!-- AZ: Variables regarding the graph's dimensions -->
    <xsl:variable name="chartBottom" select="$yLength + $barWidth"/>
    
    <!-- AZ: Everything in one big template -->
    <xsl:template match="/">
        <!-- AZ: Always output to a new SVG file with the given name -->
        <xsl:result-document href="../docs/lines_per_scene.html">
            <html>
                <head>
                    <title>Romeo and Juliet</title>
                    <link type="text/css" href="Romeo_and_Juliet.css" rel="stylesheet" />
                    <link type="text/css" href="Tabs.css" rel="stylesheet" />
                    <link type="text/css" href="dropdownMenu.css" rel="stylesheet" />
                </head>
                <body>
                    <a href="index.html">
                    <h1>Romeo and Juliet Analysis</h1>
                    </a>
                    
                    <nav>
                        <div><a href="index.html">Homepage</a></div>
                        <div class="dropdown">
                            <a href="analysisTab.html">Analysis</a>
                            <div class="dropdown-content">
                                <a href="lines_per_scene.html">Lines per Scene Bar Graph</a>
                                <a href="?.html">Table of Contents Reading View</a>
                                <a href="?.html">Color-coding Genders and House Reading View</a>
                            </div>
                        </div>
                        <div><a href="teamTab.html">Team Info</a></div>
                    </nav>
                       <!-- AZ: Extend the SVG's dimensions such that it's guaranteed to be scrollable if it's too large for the current monitor
                           Note that you shouldn't use percent (relative) values for the width and height.
                           That way leads to disaster when trying to make the SVG scrollable.
                       -->
                       <svg width="{$xLength + $xSpacer + 300}" height="{$chartBottom + 400}" overflow="scroll">
                           <!-- AZ: Move a little inwards the frame to make the axes easier to find.
                               Thus, the relative origin (0, 0) of elements within this group is the top-left corner of the vertical axis.
                           -->
                           <g font-family="sans-serif" alignment-baseline="baseline" transform="translate(150, 150)">
                               <g>
                                   <!-- AZ: Title text of the chart -->
                                   <text x="{$xMiddle}" y="-100" font-size="26" text-anchor="middle" font-weight="bold" text-decoration="underline">Lines per Scene in <tspan font-style="italic">Romeo and Juliet</tspan> Play</text>
                                   
                                   <!-- AZ: Vertical axis, its label and the label for the scenes' line counts -->
                                   <!-- AZ: Draw the y-axis at the left side of the chart -->
                                   <line x1="0" x2="0" y1="0" y2="{$chartBottom}" stroke="black" stroke-width="2"/>
                                   <text x="-50" y="{$yMiddle}" text-anchor="middle" font-weight="bold" transform="rotate(-90,-50,{$yMiddle})" font-size="16">Scenes</text>
                                   <text x="{$xLength}" y="-15" text-anchor="middle" font-size="18">Lines</text>
                                   
                                   <!-- AZ: Horizontal axis and its label. Draw the axis at the bottom of the chart, and draw the axis label both above y=0 of the chart and below -->
                                   <line x1="0" x2="{$xLength}" y1="{$chartBottom}" y2="{$chartBottom}" stroke="black" stroke-width="2"/>
                                   <text x="{$xMiddle}" y="-50" font-size="16" text-anchor="middle" font-weight="bold">Number of Lines</text>
                                   <text x="{$xMiddle}" y="{$chartBottom + 50}" font-size="16" text-anchor="middle" font-weight="bold">Number of Lines</text>
                               </g>
                               
                               <!-- AZ: Add the vertical grid lines -->
                               <g font-size="16" text-anchor="middle">
                                   <!-- AZ: The grid lines are at x-intervals of 50, so if the max number of lines
                                       across the entire play is for example 275, then this loop will iterate
                                       from 1 to 6 -->
                                   <xsl:for-each select="1 to (($sceneMaxLines + 1) idiv 50)">
                                       <!-- AZ: The actual value the grid line represents is in intervals of 50. -->
                                       <xsl:variable name="lineValue" select=". * 50"/>
                                       <!-- AZ: The x-coordinate needs to account for the fact that the bars may be scaled. -->
                                       <xsl:variable name="lineXPos" select="$lineValue * $barScale"/>
                                       
                                       <!-- AZ: The grid line goes to the bottom of the chart, where the x-axis is -->
                                       <line x1="{$lineXPos}" y1="0" x2="{$lineXPos}" y2="{$chartBottom}" stroke="gray" stroke-dasharray="5,5"/>
                                       <!-- AZ: Text for this grid line, above (0, 0) -->
                                       <text x="{$lineXPos}" y="-15"><xsl:value-of select="$lineValue"/></text>
                                       <!-- AZ: Text for this grid line, below the x-axis. Add some space between it and the and the bottom of the chart -->
                                       <text x="{$lineXPos}" y="{$chartBottom + 20}"><xsl:value-of select="$lineValue"/></text>
                                   </xsl:for-each>
                               </g>
                               
                               <!-- AZ: The meat of this stylesheet. Creates and spaces all the objects for each scene in the play. -->
                               <xsl:for-each select="//scene">
                                   <!-- AZ: The number of this scene in the current act -->
                                   <xsl:variable name="sceneNum" select="count(preceding::scene) + 1"/>
                                   <!-- AZ: The number of the act this scene is a part of -->
                                   <xsl:variable name="actNum" select="../position()"/>
                                   <!-- AZ: Count the number of lines for this scene.
                                       The number is the number of <br/> tags plus one to include the last line.
                                   -->
                                   <xsl:variable name="lineCount" select='(.//br => count()) + 1'/>
                                   <!-- AZ: Basis position of scene-related elements, vertically.
                                       Elements are shifted from this value, such as to manually adjust the position of elements or to add spacing between elements -->
                                   <xsl:variable name="yPos" select="position() * $ySpacer"/>
                                   
                                   <!-- text-anchor="middle" means position the text horizontally based off the middle of the text, horizontally, when treated as one block.
                                       dominant-baseline="middle" means position the text vertically based off the middle of the text, vertically, when treated as one block.
                                       See this Stack Overflow answer for the inspiration for dominant-baseline: https://stackoverflow.com/a/31522006
                                   -->
                                   <g font-size="12" text-anchor="middle" dominant-baseline="middle" transform="translate(0, {$yPos})">
                                       <!-- AZ: The x-coordinate of the right side of this scene's bar, after scaling the bar's length -->
                                       <xsl:variable name="barXPos" select="$lineCount * $barScale"/>
                                       
                                       <!-- AZ: This scene's number as a label, arranged in a column for all scenes -->
                                       <text x="-15" y="0" font-size="18"><xsl:value-of select="$sceneNum"/></text>
                                       
                                       <!-- AZ: The bar for this scene.
                                           Note the spacing was already determined in the definition of $barWidth to leave some
                                           space between this bar and the bars for the next and previous scenes.
                                       -->
                                       <line x1="0" x2="{$barXPos}" y1="0" y2="0" stroke="#9CAF88" stroke-width="{$barWidth}"/>
                                       
                                       <!-- AZ: The number of lines in each scene, all placed in a column -->
                                       <text x="{$xLength}" y="0" font-size="18"><xsl:value-of select="$lineCount"/></text>
                                   </g>
                               </xsl:for-each>
                           </g>
                       </svg>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>