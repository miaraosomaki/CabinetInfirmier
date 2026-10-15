<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cb="http://www.univ-grenoble-alpes.fr/l3miage/medical"
                exclude-result-prefixes="cb">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Cabinet Médical : <xsl:value-of select="cb:cabinet/cb:nomC"/></title>
                <link rel="stylesheet" type="text/css" href="../CSS/cabinet.css"/>
            </head>
            <body>
                Hello world
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>