<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Ici le document source (NOMPATIENT.xml) n'a PAS de namespace : pas de préfixe -->
    <xsl:template match="/patient">
        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <title>Fiche de <xsl:value-of select="prénom"/><xsl:text> </xsl:text><xsl:value-of select="nom"/></title>
                <link rel="stylesheet" type="text/css" href="../CSS/cabinet.css"/>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="prénom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="nom"/>
                </h1>

                <h2>Informations personnelles</h2>
                <ul>
                    <li>Sexe : <xsl:value-of select="sexe"/></li>
                    <li>Date de naissance : <xsl:value-of select="naissance"/></li>
                    <li>N° de sécurité sociale : <xsl:value-of select="numéroSS"/></li>
                    <li>Adresse : <xsl:apply-templates select="adresse"/></li>
                </ul>

                <h2>Mes visites</h2>
                <table border="1">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Intervenant</th>
                            <th>Soins</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="visite"/>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <!-- Adresse -->
    <xsl:template match="adresse">
        <xsl:if test="étage">
            <xsl:text>Étage </xsl:text>
            <xsl:value-of select="étage"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="numéro">
            <xsl:value-of select="numéro"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="rue"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="codePostal"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="ville"/>
    </xsl:template>

    <!-- Une visite = une ligne du tableau -->
    <xsl:template match="visite">
        <tr>
            <td><xsl:value-of select="@date"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="intervenant">
                        <xsl:value-of select="intervenant/prénom"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="intervenant/nom"/>
                    </xsl:when>
                    <xsl:otherwise>Non assigné</xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <ul>
                    <xsl:apply-templates select="acte"/>
                </ul>
            </td>
        </tr>
    </xsl:template>

    <!-- Un acte = un élément de liste -->
    <xsl:template match="acte">
        <li><xsl:value-of select="."/></li>
    </xsl:template>

</xsl:stylesheet>
