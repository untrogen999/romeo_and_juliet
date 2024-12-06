<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
  <xsl:template match="/">
      <html>
        <head><title>Romeo and Juliet</title></head>
          <body>
              <h1><xsl:value-of select="introduction/Title" /></h1>
                    <h2>Preface</h2>
                        <xsl:for-each select="introduction/preface/p">
                            <p><xsl:value-of select="@number" />. 
                                <xsl:value-of select="." /></p>
                        </xsl:for-each>
                     </body>         
            </html>
        </xsl:template>
    </xsl:stylesheet>
    