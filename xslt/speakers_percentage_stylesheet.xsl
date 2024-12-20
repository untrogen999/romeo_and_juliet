<?xml version="1.0" encoding="UTF-8"?>

<!-- SVG work for the Romeo and Juliet project by Aania Khalid and Avi Zilberman, outputted as an HTML page. -->
<!-- Makes an SVG embedded in HTML of a bar graph showing the percentage of speeches each character made across the whole play -->
<!-- Aania manually wrote the initial draft SVG of the lines per scene SVG as the basis, and Avi made this XSLT to generate an SVG from his XSLT Assignment 3 work with similar styling -->
<!-- This stylesheet doesn't need to be run on any particular XML file, as the play XML is grabbed automatically.
    Just pick any XML file in oXygen to run this stylesheet.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- AZ: SVG is embedded in an HTML page -->
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>
    
    <!-- AZ: The play's XML file -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    
    <!-- AZ: Variables unrelated to the axes -->
    <xsl:variable name="speakerTotal" select="count(distinct-values($playFile//speaker))"/>
    <xsl:variable name="speechTotal" select="count($playFile//speech)"/>
    <!-- AZ: Stores a sequence of the number of speeches each speaker made in the play -->
    <!-- AZ: The "as" parameter is needed to force the result to be a sequence of numbers -->
    <xsl:variable name="speakerCounts" as="xs:integer*">
        <!-- AZ: Group speeches by the character who speaks them -->
        <xsl:for-each-group select="$playFile//speech" group-by="speaker/@char">
            <!-- AZ: Count the number of speeches this character made -->
            <xsl:value-of select="count(current-group())"/>
        </xsl:for-each-group>
    </xsl:variable>
    <!-- AZ: Used to calculate how far along to the right the bar chart should extend -->
    <xsl:variable name="speakerMaxLines" select="max($speakerCounts)"/>
    
    <!-- AZ: Variables related to the x-axis -->
    <xsl:variable name="xSpacer" select="$speakerMaxLines div $speechTotal"/>
    <!-- AZ: Add the length by a little bit to extend the horizontal axis further right -->
    <xsl:variable name="xLength" select="$speakerMaxLines * $barScale + 50"/>
    <!-- AZ: Used for positioning the title text and horizontal axis label -->
    <xsl:variable name="xMiddle" select="$xLength div 2"/>
    
    <!-- AZ: Variables related to the y-axis -->
    <xsl:variable name="ySpacer" select="50"/>
    <xsl:variable name="yLength" select="$speakerTotal * $ySpacer"/>
    <!-- AZ: Used for positioning the vertical axis label -->
    <xsl:variable name="yMiddle" select="$yLength div 2"/>
    
    <!-- AZ: Styling variables -->
    <xsl:variable name="barScale" select="3"/>
    <!-- AZ: The empty space between any two speakers' bars -->
    <xsl:variable name="speakerSpacer" select="10"/>
    <!-- AZ: Set the width of the bar for each $speakerSpacer such that there is always $speakerSpacer
        pixels of empty space between the speakers' bars -->
    <xsl:variable name="barWidth" select="$ySpacer - $speakerSpacer"/>
    
    <!-- AZ: Variables regarding the graph's dimensions -->
    <xsl:variable name="chartBottom" select="$yLength + $barWidth"/>
    
    <!-- AZ: Everything in one big template -->
    <xsl:template match="/">
        <!-- AZ: Always output a new HTML file with the given name -->
        <xsl:result-document href="../docs/play_speech_percentages_chart.html">
            <html>
                <head>
                    <title>Speaker Speech Percentages Bar Graph</title>
                    <link type="text/css" href="Romeo_and_Juliet.css" rel="stylesheet" />
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
                    
                    <!-- AZ: Extend the SVG's dimensions such that it's guaranteed to be scrollable if it's too large for the current monitor
                       Note that you shouldn't use percent (relative) values for the width and height.
                       That way leads to disaster when trying to make the SVG scrollable.
                    -->
                    <svg width="{$xLength + $xSpacer + 300}" height="{$chartBottom + 400}" overflow="scroll">
                       <!-- AZ: Move a little inwards the frame to make the axes easier to find.
                           Thus, the relative origin (0, 0) of elements within this group is the top-left corner of the vertical axis.
                       -->
                       <g font-family="sans-serif" alignment-baseline="baseline" transform="translate(150, 150)">
                           <!-- AZ: Setup the bar graph -->
                           <g>
                               <!-- AZ: Title text of the chart -->
                               <text x="{$xMiddle}" y="-100" font-size="26" text-anchor="middle" font-weight="bold" text-decoration="underline">Speeches per Character Across <tspan font-style="italic">Romeo and Juliet</tspan></text>
                               
                               <!-- AZ: Vertical axis and its label -->
                               <!-- AZ: Draw the y-axis at the left side of the chart -->
                               <line x1="0" x2="0" y1="0" y2="{$chartBottom}" stroke="black" stroke-width="2"/>
                               <text x="-120" y="{$yMiddle}" text-anchor="middle" font-weight="bold" transform="rotate(-90,-120,{$yMiddle})" font-size="16">Characters</text>
                               
                               <!-- AZ: Uncomment if you want to have the percentage of speeches to be to the right of the x-axis -->
                               <!--<text x="{$xLength}" y="-15" text-anchor="middle" font-size="18">Percentage of Speeches</text>-->
                               
                               <!-- AZ: Horizontal axis and its label. Draw the axis at the bottom of the chart, and draw the axis label both above y=0 of the chart and below -->
                               <line x1="0" x2="{$xLength}" y1="{$chartBottom}" y2="{$chartBottom}" stroke="black" stroke-width="2"/>
                               <text x="{$xMiddle}" y="-50" font-size="16" text-anchor="middle" font-weight="bold">Percentage of Speeches</text>
                               <text x="{$xMiddle}" y="{$chartBottom + 50}" font-size="16" text-anchor="middle" font-weight="bold">Percentage of Speeches</text>
                           </g>
                           
                           <!-- AZ: Add the vertical grid lines -->
                           <g font-size="16" text-anchor="middle">
                               <!-- AZ: The grid lines are at x-intervals of 50, so if the max number of speeches
                                   any character spoke across entire play is for example 275, then this loop will iterate
                                   from 1 to 6 where 50*6 = 300 -->
                               <xsl:for-each select="1 to (($speakerMaxLines + 1) idiv 50)">
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
                           
                           <!-- AZ: The meat of this stylesheet. Creates and spaces all the objects for each character in the play. -->
                           <xsl:for-each select="distinct-values($playFile//speaker/@char)">
                               <!-- AZ: Ordered by who gave the most speeches -->
                               <xsl:sort select="count($playFile//speech[speaker/@char=current()])" order="descending"/>
                               
                               <!-- AZ: Name of the speaker -->
                               <xsl:variable name="speakerName" select="."/>
                               
                               <!-- AZ: The number of speeches this character made -->
                               <xsl:variable name="speechCount" select="$playFile//speaker[@char=$speakerName] => count()"/>
                               
                               <!-- AZ: Basis position of speech-related elements, vertically.
                                   Elements are shifted from this value, such as to manually adjust the position of elements or to add spacing between elements -->
                               <xsl:variable name="yPos" select="position() * $ySpacer"/>
                               
                               <!-- text-anchor="middle" means position the text horizontally based off the middle of the text, horizontally, when treated as one block.
                                   dominant-baseline="middle" means position the text vertically based off the middle of the text, vertically, when treated as one block.
                                   See this Stack Overflow answer for the inspiration for dominant-baseline: https://stackoverflow.com/a/31522006
                               -->
                               <g font-size="12" text-anchor="middle" dominant-baseline="middle" transform="translate(0, {$yPos})">
                                   <!-- AZ: The x-coordinate of the right side of this character's bar, after scaling the bar's length -->
                                   <xsl:variable name="barXPos" select="$speechCount * $barScale"/>
                                   
                                   <!-- AZ: This character's name as a label, arranged in a column for all characters -->
                                   <text x="-10" y="0" text-anchor="end" font-size="18"><xsl:value-of select="$speakerName"/></text>
                                   
                                   <!-- AZ: The bar for this character.
                                       Note the spacing was already determined in the definition of $barWidth to leave some
                                       space between this bar and the bars for the next and previous characters.
                                   -->
                                   <line x1="0" x2="{$barXPos}" y1="0" y2="0" stroke="#9CAF88" stroke-width="{$barWidth}"/>
                                   
                                   <!-- AZ: AZ: The percentage of speeches this character spoke, placed inside the (horizontal) middle of the bar.
                                       See this link for inspiration on rounding/formatting numbers: https://itexpertsconsultant.wordpress.com/2015/08/14/how-to-rounding-numbers-to-a-specified-precision-in-xslt-1-0/
                                   -->
                                   <text x="{$barXPos + 10}" y="0" text-anchor="start" font-size="18"><xsl:value-of select="format-number(($speechCount div $speechTotal) * 100, '#.#')"/>%</text>
                                   
                                   <!-- AZ: The percentage of speeches this character spoke, placed to the right of the bar -->
                                   <!-- AZ: Uncomment if you want to have the percentage of speeches to be to the right of the x-axis -->
                                   <!--<text x="{$xLength}" y="0" font-size="18"><xsl:value-of select="format-number(($speechCount div $speechTotal) * 100, '#.#')"/></text>-->
                               </g>
                           </xsl:for-each>
                       </g>
                    </svg>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>