<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version='1.0'>
 <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>
 <xsl:output method="html" encoding="UTF-8" indent="no" />
 <xsl:param name="chunker.output.encoding">UTF-8</xsl:param>
 <xsl:param name="html.stylesheet" select="'iphone.css'"/>
 <xsl:param name="base.dir" select="'chunked/'"></xsl:param>
 <xsl:param name="toc.section.depth">1</xsl:param>

 <xsl:template name="user.head.content">
   <meta name="viewport" content="width=480, user-scalable=yes" />
 </xsl:template>

 <xsl:param name="chunk.section.depth" select="1"></xsl:param>
</xsl:stylesheet>
