<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes"/>
  <xsl:strip-space elements="*"/>
  
  <xsl:key name="items" match="training/*" use="concat(generate-id(..),name())"/>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="training">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="*[not(self::ignore)][count(.|key('items',concat(generate-id(..),name()))[1])=1]">
        <xsl:sort select="name()"/>
        <xsl:copy>
          <xsl:apply-templates select="key('items',concat(generate-id(..),name()))"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="training/*">
    <xsl:if test="position() > 1">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:template>
  
</xsl:stylesheet>
