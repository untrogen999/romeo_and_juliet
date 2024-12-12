<?xml version="1.0" encoding="UTF-8"?>

<!-- SVG 3 work by Avi Zilberman -->
<!-- This stylesheet outputs an SVG file embedded in an HTML file that shows the percentage of speeches
    each speaker made, across the whole play -->
<!-- The play and list of speakers XML files are already grabbed automatically, so just run this stylesheet on any XML file to make oXygen process it. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <!-- This is an HTML document -->
    <xsl:output method="xhtml" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes" indent="yes"/>
    
    <!-- AZ: Input files stored as variables -->
    <xsl:variable name="playFile" select="document('../xml/thePlay_MJB_fixed_tagging.xml')"/>
    <xsl:variable name="speakersFile" select="document('../xml/avi_list_of_speakers.xml')"/>
    
    <!-- AZ: Variables unrelated to the axes -->
    <xsl:variable name="speakerCount" select="count($speakersFile//ch)"/>
    <xsl:variable name="speechTotal" select="count($playFile//speech)"/>
    
    <!-- AZ: Variables related to the x-axis -->
    <xsl:variable name="xSpacer" select="50"/>
    <xsl:variable name="xLength" select="$speakerCount * $xSpacer"/>
    <!-- AZ: Used for positioning the title text -->
    <xsl:variable name="xMiddle" select="($speakerCount div 2) * $xSpacer"/>
    
    <!-- AZ: Variables related to the y-axis -->
    <xsl:variable name="ySpacer" select="50"/>
    <xsl:variable name="yLength" select="$speakerCount * $ySpacer"/>
    
    <!-- AZ: Styling variables -->
    <xsl:variable name="barScale" select="7"/>
    <!-- AZ: The empty space between any two speakers' bars -->
    <xsl:variable name="speakerSpacer" select="15"/>
    <!-- AZ: Set the width of the bar for each $speakerSpacer such that there is always $speakerSpacer
        pixels of empty space between the speakers' bars -->
    <!-- Remember the bar extends both above and below, so divide the spacing in half to reflect this -->
    <xsl:variable name="barWidth" select="$ySpacer - $speakerSpacer"/>
    
    <!-- AZ: Everything in one big template -->
    <xsl:template match="/">
        <!-- AZ: Always output to a new SVG file with the given name -->
        <xsl:result-document href="../docs/play_speech_percentages_chart.html">
            <html>
            <head>
                <title>Speaker Speech Percentages Chart</title>
            </head>
            <body>
                <!-- AZ: Extend the SVG's dimensions such that it's guaranteed to be scrollable if it's too large for the current monitor
                    Note that you shouldn't use percent (relative) values for the width and height.
                    That way leads to disaster when trying to make the SVG scrollable.
                -->
                <svg width="{$xLength + $xSpacer + 300}" height="{$yLength + $ySpacer + 400}" overflow="scroll">
                    <!-- AZ: Move a little inwards the frame to make the axes easier to find.
                        Thus, the relative origin (0, 0) of elements within this group is the top-left corner of the vertical axis.
                    -->
                    <g alignment-baseline="baseline" transform="translate(150, 150)">
                        <!-- AZ: Title text of the chart -->
                        <text x="{$xMiddle}" y="-75" text-anchor="middle" font-family="sans-serif" font-size="30">Percentage of Speeches Across the Entire Play, per Speaker</text>
                        
                        <!-- AZ: Vertical axis, its label and the label for the speakers' speech counts -->
                        <!-- AZ: Draw the y-axis one spacer further down so that it's
                            below the label and bar for the last speaker. -->
                        <line x1="0" x2="0" y1="0" y2="{$yLength + $ySpacer}" stroke="black" stroke-width="2"/>
                        <text x="0" y="-15" text-anchor="middle" font-family="sans-serif" font-size="18">Speakers</text>
                        <!-- AZ: Move the title of the speech counts column a little left to make it appear more towards the center -->
                        <text x="{$xLength - 10}" y="-15" text-anchor="middle" font-family="sans-serif" font-size="18">Speeches</text>
                        
                        <!-- AZ: Horizontal axis and its label. Place them one interval further down so that they're
                            below the label and bars for the last speaker. -->
                        <line x1="0" x2="{$xLength}" y1="{$yLength + $ySpacer}" y2="{$yLength + $ySpacer}" stroke="black" stroke-width="2"/>
                        <text x="{$xLength + 10}" y="{$yLength + $ySpacer + 5}" font-family="sans-serif" font-size="18">Number of Speeches</text>
                        
                        <!-- AZ: The meat of this stylesheet. Creates and spaces all the objects for each speaker in the play. -->
                        <xsl:for-each select="$speakersFile//ch">
                            <!-- AZ: This speaker's name, as a variable since "speakerName" is a bit clearer than "text()" -->
                            <xsl:variable name="speakerName" select="text()"/>
                            <!-- AZ: Count the speeches for this speaker -->
                            <xsl:variable name="speechCount" select='$playFile//speaker[@char=$speakerName] => count()'/>
                            <!-- AZ: Basis position of speaker-related elements, vertically.
                                Elements are shifted from this value, such as to manually adjust the position of elements or to add spacing between elements -->
                            <xsl:variable name="yPos" select="position() * $ySpacer"/>
                            
                            <g transform="translate(0, {$yPos})">
                                <!-- AZ: The x-coordinate of the right side of this speaker's bar, after scaling the bar's length -->
                                <xsl:variable name="barXPos" select="$speechCount * $barScale"/>
                                
                                <!-- AZ: This speaker's name as a label, arranged in a column for all speakers
                                    "text-anchor" here positions the text horizontally to ensure the right ends of all speaker names are aligned in a column
                                    "dominant-baseline" here positions the text vertically to ensure that this speaker's name is aligned at the center of this
                                    speaker's bar.
                                    See this Stack Overflow answer for the inspiration for dominant-baseline: https://stackoverflow.com/a/31522006
                                -->
                                <text x="-15" y="0" text-anchor="end" dominant-baseline="middle" font-family="sans-serif" font-size="18"><xsl:value-of select="$speakerName"/></text>
                                
                                <!-- AZ: The bar for this speaker.
                                    Note the spacing was already determined in the definition of $barWidth to leave some
                                    space between this bar and bar for the next and previous speakers.
                                -->
                                <line x1="0" x2="{$barXPos}" y1="0" y2="0" stroke="green" stroke-width="{$barWidth}"/>
                                
                                <!-- AZ: The number of speeches for each speakers, textual, and all placed in a column and aligned horizontally and vertically
                                    in the center.
                                    See the comment for the speaker labels for what "dominant-baseline" does.
                                    See this link for inspiration on rounding/formatting numbers: https://itexpertsconsultant.wordpress.com/2015/08/14/how-to-rounding-numbers-to-a-specified-precision-in-xslt-1-0/
                                -->
                                <text x="{$xLength - 10}" y="0" text-anchor="middle" dominant-baseline="middle" font-family="sans-serif" font-size="18"><xsl:value-of select="format-number(($speechCount div $speechTotal) * 100, '#.#')"/>%</text>
                            </g>
                        </xsl:for-each>
                    </g>
                </svg>
            </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>