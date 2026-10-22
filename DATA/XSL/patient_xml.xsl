<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cb="http://www.univ-grenoble-alpes.fr/l3miage/medical"
    xmlns:act="http://www.univ-grenoble-alpes.fr/l3miage/actes"
    exclude-result-prefixes="cb act">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- nom du patient (Alécole par défaut) -->
    <xsl:param name="destinedName">Alécole</xsl:param>

    <!-- Accès au fichier actes.xml (même dossier que cabinet.xml) -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>

    <!-- Template principal  -->
    <xsl:template match="/">
        <xsl:apply-templates select="cb:cabinet/cb:patients/cb:patient[cb:nomP=$destinedName]"/>
    </xsl:template>

    <!-- Le patient -->
    <xsl:template match="cb:patient">
        <patient>
            <nom><xsl:value-of select="cb:nomP"/></nom>
            <prénom><xsl:value-of select="cb:prenomP"/></prénom>
            <sexe><xsl:value-of select="cb:sexe"/></sexe>
            <naissance><xsl:value-of select="cb:naissance"/></naissance>
            <numéroSS><xsl:value-of select="cb:numeroP"/></numéroSS>
            <xsl:apply-templates select="cb:adresseP"/>
            <!-- Visites triées par date -->
            <xsl:apply-templates select="cb:visite">
                <xsl:sort select="@date"/>
            </xsl:apply-templates>
        </patient>
    </xsl:template>

    <!--  L'adresse (étage et numéro seulement s'ils existent)  -->
    <xsl:template match="cb:adresseP">
        <adresse>
            <xsl:if test="cb:etage">
                <étage><xsl:value-of select="cb:etage"/></étage>
            </xsl:if>
            <xsl:if test="cb:numero">
                <numéro><xsl:value-of select="cb:numero"/></numéro>
            </xsl:if>
            <rue><xsl:value-of select="cb:rue"/></rue>
            <codePostal><xsl:value-of select="cb:codePostal"/></codePostal>
            <ville><xsl:value-of select="cb:ville"/></ville>
        </adresse>
    </xsl:template>

    <!-- Une visite  -->
    <xsl:template match="cb:visite">
        <visite>
            <xsl:attribute name="date">
                <xsl:value-of select="@date"/>
            </xsl:attribute>

            <!-- L'intervenant n'est affiché que s'il a été affecté -->
            <xsl:if test="@intervenant">
                <xsl:variable name="idInt" select="@intervenant"/>
                <xsl:variable name="inf"
                    select="/cb:cabinet/cb:infirmiers/cb:infirmier[@idI=$idInt]"/>
                <intervenant>
                    <nom><xsl:value-of select="$inf/cb:nomI"/></nom>
                    <prénom><xsl:value-of select="$inf/cb:prenomI"/></prénom>
                </intervenant>
            </xsl:if>

            <xsl:apply-templates select="cb:acte"/>
        </visite>
    </xsl:template>

    <!-- Un acte : son libellé en clair  -->
    <xsl:template match="cb:acte">
        <xsl:variable name="id" select="@idA"/>
        <acte>
            <xsl:value-of select="normalize-space($actes/act:actes/act:acte[@id=$id])"/>
        </acte>
    </xsl:template>

</xsl:stylesheet>
