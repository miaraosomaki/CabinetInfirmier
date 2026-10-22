<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cb="http://www.univ-grenoble-alpes.fr/l3miage/medical"
                xmlns:act="http://www.univ-grenoble-alpes.fr/l3miage/actes"
                exclude-result-prefixes="cb act">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <!-- Paramètre global : identifiant de l'infirmière (001 par défaut) -->
    <xsl:param name="destinedId">001</xsl:param>

    <!-- Accès au fichier actes.xml (même dossier que cabinet.xml) -->
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>

    <!-- Template principal : la page  -->
    <xsl:template match="/">
        <xsl:variable name="infirmier"
                      select="cb:cabinet/cb:infirmiers/cb:infirmier[@idI=$destinedId]"/>
        <xsl:variable name="mesPatients"
                      select="cb:cabinet/cb:patients/cb:patient[cb:visite/@intervenant=$destinedId]"/>

        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <title>Cabinet <xsl:value-of select="cb:cabinet/cb:nomC"/></title>
                <link rel="stylesheet" type="text/css" href="../CSS/cabinet.css"/>
                <!-- Script fourni par le sujet, intégré dans l'entête -->
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
                    var width = 500;
                    var height = 300;
                    if (window.innerWidth) {
                    var left = (window.innerWidth - width) / 2;
                    var top = (window.innerHeight - height) / 2;
                    } else {
                    var left = (document.body.clientWidth - width) / 2;
                    var top = (document.body.clientHeight - height) / 2;
                    }
                    var factureWindow = window.open('', 'facture', 'menubar=yes, scrollbars=yes, top=' + top + ', left=' + left + ', width=' + width + ', height=' + height + '');
                    factureText = "Facture pour : " + prenom + " " + nom;
                    factureWindow.document.write(factureText);
                    }
                </script>
            </head>
            <body>
                <!-- Étape b : phrase d'accueil -->
                <h1>Bonjour <xsl:value-of select="$infirmier/cb:prenomI"/>,</h1>
                <p>
                    Aujourd'hui, vous avez
                    <xsl:value-of select="count($mesPatients)"/>
                    patient(s)
                </p>

                <!-- Étape c : liste des patients (ordre du document ; l'ordre optimisé viendra plus tard) -->
                <xsl:apply-templates select="$mesPatients"/>
            </body>
        </html>
    </xsl:template>

    <!-- Un patient  -->
    <xsl:template match="cb:patient">
        <div class="patient">
            <h2>
                <xsl:value-of select="cb:prenomP"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="cb:nomP"/>
            </h2>

            <xsl:apply-templates select="cb:adresseP"/>

            <p>Soins à effectuer :</p>
            <ul>
                <xsl:apply-templates select="cb:visite[@intervenant=$destinedId]/cb:acte"/>
            </ul>

            <!-- Étape d : bouton Facture -->
            <xsl:element name="button">
                <xsl:attribute name="onclick">
                    <xsl:text>openFacture('</xsl:text>
                    <xsl:value-of select="cb:prenomP"/>
                    <xsl:text>', '</xsl:text>
                    <xsl:value-of select="cb:nomP"/>
                    <xsl:text>', '</xsl:text>
                    <xsl:apply-templates select="cb:visite[@intervenant=$destinedId]/cb:acte" mode="ids"/>
                    <xsl:text>')</xsl:text>
                </xsl:attribute>
                <xsl:text>Facture</xsl:text>
            </xsl:element>
        </div>
    </xsl:template>

    <!--  L'adresse d'un patient  -->
    <xsl:template match="cb:adresseP">
        <p class="adresse">
            <xsl:if test="cb:etage">
                <xsl:text>Étage </xsl:text>
                <xsl:value-of select="cb:etage"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="cb:numero">
                <xsl:value-of select="cb:numero"/>
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="cb:rue"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="cb:codePostal"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="cb:ville"/>
        </p>
    </xsl:template>

    <!--  Un acte : libellé pris dans actes.xml  -->
    <xsl:template match="cb:acte">
        <xsl:variable name="id" select="@idA"/>
        <li>
            <xsl:value-of select="normalize-space($actes/act:actes/act:acte[@id=$id])"/>
        </li>
    </xsl:template>

    <!-- Un acte (mode ids) : seulement son identifiant, pour le bouton  -->
    <xsl:template match="cb:acte" mode="ids">
        <xsl:value-of select="@idA"/>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
