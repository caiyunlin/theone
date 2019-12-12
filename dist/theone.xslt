<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--以下示例是将 &quot; 为 " -->
  <xsl:template name="root" match ="/">
    <xsl:variable name="abc">
      <xsl:variable name="x">&quot;</xsl:variable>
      <xsl:variable name="y">%22</xsl:variable>
      <xsl:call-template name="replaceFunc">
        <xsl:with-param name ="text" select="//abc"/>
        <xsl:with-param name ="replace" select="$x"/>
        <xsl:with-param name ="by" select="$y"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$abc"/>
  </xsl:template>
  <xsl:template name="replaceFunc">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$by"/>
        <xsl:call-template name="replaceFunc">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  </xsl:stylesheet>