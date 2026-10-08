<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cb="https://www.univ-grenoble-alpes.fr/l3miage/medical"
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
                <header class="app-header">
                    <h1>Cabinet Médical : <xsl:value-of select="cb:cabinet/cb:nomC"/></h1>
                </header>

                <div class="tabs-container">
                    <!-- Boutons radio pour changer de vue en CSS pur -->
                    <input type="radio" name="tab-nav" id="tab-accueil" checked="checked"/>
                    <input type="radio" name="tab-nav" id="tab-infirmiers"/>
                    <input type="radio" name="tab-nav" id="tab-soins"/>
                    <input type="radio" name="tab-nav" id="tab-patients"/>

                    <!-- Barre de navigation -->
                    <nav class="tabs-nav">
                        <label for="tab-accueil" class="tab-label">Accueil</label>
                        <label for="tab-infirmiers" class="tab-label">Cabinet infirmier</label>
                        <label for="tab-soins" class="tab-label">Soins</label>
                        <label for="tab-patients" class="tab-label">Patients</label>
                    </nav>

                    <!-- Vues / Pages -->
                    <main class="tabs-content">

                        <!-- Page 1 : Accueil -->
                        <section class="page" id="page-accueil">
                            <h2>Présentation du cabinet</h2>
                            <div class="card info-box">
                                <p><strong>Nom :</strong> <xsl:value-of select="cb:cabinet/cb:nomC"/></p>
                                <p>
                                    <strong>Adresse :</strong>
                                    <xsl:value-of select="cb:cabinet/cb:adresseC/cb:numero"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="cb:cabinet/cb:adresseC/cb:rue"/>,
                                    <xsl:value-of select="cb:cabinet/cb:adresseC/cb:codePostal"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="cb:cabinet/cb:adresseC/cb:ville"/>
                                </p>
                            </div>

                            <div class="stats-grid">
                                <div class="stat-card">
                                    <span class="stat-num"><xsl:value-of select="count(cb:cabinet/cb:infirmiers/cb:infirmier)"/></span>
                                    <span class="stat-desc">Infirmiers</span>
                                </div>
                                <div class="stat-card">
                                    <span class="stat-num"><xsl:value-of select="count(cb:cabinet/cb:patients/cb:patient)"/></span>
                                    <span class="stat-desc">Patients</span>
                                </div>
                                <div class="stat-card">
                                    <span class="stat-num"><xsl:value-of select="count(//cb:visite)"/></span>
                                    <span class="stat-desc">Visites</span>
                                </div>
                                <div class="stat-card">
                                    <span class="stat-num"><xsl:value-of select="count(//cb:acte)"/></span>
                                    <span class="stat-desc">Actes</span>
                                </div>
                            </div>
                        </section>

                        <!-- Page 2 : Cabinet Infirmier -->
                        <section class="page" id="page-infirmiers">
                            <h2>Équipe soignante</h2>
                            <div class="grid-cards">
                                <xsl:for-each select="cb:cabinet/cb:infirmiers/cb:infirmier">
                                    <div class="card nurse-card">
                                        <div class="nurse-avatar">
                                            <span>
                                                <xsl:value-of select="substring(cb:prenomI, 1, 1)"/>
                                                <xsl:value-of select="substring(cb:nomI, 1, 1)"/>
                                            </span>
                                        </div>
                                        <div class="nurse-info">
                                            <h3><xsl:value-of select="cb:prenomI"/><xsl:text> </xsl:text><xsl:value-of select="cb:nomI"/></h3>
                                            <p class="badge">Identifiant : <xsl:value-of select="@idI"/></p>
                                            <p class="file-name"><small>Photo : <xsl:value-of select="cb:photo"/></small></p>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </section>

                        <!-- Page 3 : Soins -->
                        <section class="page" id="page-soins">
                            <h2>Actes médicaux programmés</h2>
                            <div class="card">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>ID Acte</th>
                                            <th>Type</th>
                                            <th>Clé</th>
                                            <th>Coefficient</th>
                                            <th>Patient</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="//cb:acte">
                                            <tr>
                                                <td><span class="code-badge"><xsl:value-of select="@idA"/></span></td>
                                                <td><xsl:value-of select="@type"/></td>
                                                <td><xsl:value-of select="@cle"/></td>
                                                <td><xsl:value-of select="@coef"/></td>
                                                <td>
                                                    <xsl:value-of select="../../cb:prenomP"/>
                                                    <xsl:text> </xsl:text>
                                                    <strong><xsl:value-of select="../../cb:nomP"/></strong>
                                                </td>
                                                <td><xsl:value-of select="../@date"/></td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <!-- Page 4 : Patients -->
                        <section class="page" id="page-patients">
                            <h2>Dossiers des patients</h2>
                            <div class="patients-list">
                                <xsl:for-each select="cb:cabinet/cb:patients/cb:patient">
                                    <article class="card patient-card">
                                        <div class="patient-header">
                                            <div>
                                                <h3>
                                                    <xsl:value-of select="cb:nomP"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="cb:prenomP"/>
                                                </h3>
                                                <p class="patient-sub">Né(e) le <xsl:value-of select="cb:naissance"/> — N° Sécurité : <xsl:value-of select="cb:numeroP"/></p>
                                            </div>
                                            <span class="genre-badge"><xsl:value-of select="cb:sexe"/></span>
                                        </div>

                                        <p class="patient-address">
                                            <strong>Adresse : </strong>
                                            <xsl:if test="cb:adresseP/cb:etage">
                                                <xsl:text>Étage </xsl:text><xsl:value-of select="cb:adresseP/cb:etage"/><xsl:text>, </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="cb:adresseP/cb:numero">
                                                <xsl:value-of select="cb:adresseP/cb:numero"/><xsl:text> </xsl:text>
                                            </xsl:if>
                                            <xsl:value-of select="cb:adresseP/cb:rue"/>,
                                            <xsl:value-of select="cb:adresseP/cb:codePostal"/><xsl:text> </xsl:text><xsl:value-of select="cb:adresseP/cb:ville"/>
                                        </p>

                                        <div class="visits-section">
                                            <h4>Visites prévues</h4>
                                            <xsl:for-each select="cb:visite">
                                                <div class="visit-entry">
                                                    <p class="visit-meta">
                                                        <span>Date : <strong><xsl:value-of select="@date"/></strong></span>
                                                        <span>
                                                            Intervenant :
                                                            <xsl:choose>
                                                                <xsl:when test="@intervenant">
                                                                    <strong>Infirmier #<xsl:value-of select="@intervenant"/></strong>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <em>Non assigné</em>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </span>
                                                    </p>
                                                    <ul class="actes-inline">
                                                        <xsl:for-each select="cb:acte">
                                                            <li>Acte #<xsl:value-of select="@idA"/> (<xsl:value-of select="@cle"/> × <xsl:value-of select="@coef"/>)</li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </article>
                                </xsl:for-each>
                            </div>
                        </section>

                    </main>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>