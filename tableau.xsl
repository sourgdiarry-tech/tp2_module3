<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:key name="par-classe" match="etudiant" use="@classe"/>

  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <title>Notes de la promotion</title>
        <link rel="stylesheet" href="style.css"/>
      </head>
      <body>
        <header>
          <h1>Notes de la promotion — <xsl:value-of select="/promotion/@filiere"/></h1>
          <p>Année <xsl:value-of select="/promotion/@annee"/> • Mise à jour des notes</p>
        </header>

        <main>
          <section class="stats">
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//etudiant)"/></span><span class="legende">Étudiants</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//note)"/></span><span class="legende">Notes saisies</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//etudiant[email])"/></span><span class="legende">Étudiants avec email</span></div>
            <div class="carte"><span class="valeur"><xsl:value-of select="count(//note) div count(//etudiant)"/></span><span class="legende">Notes par étudiant (moyenne)</span></div>
          </section>

          <h2>Classement — Tous les étudiants</h2>
          <table>
            <thead>
              <tr><th>Rang</th><th>Matricule</th><th>Nom</th><th>Prénom</th><th>Classe</th><th>Moyenne</th><th>Statut</th></tr>
            </thead>
            <tbody>
              <xsl:for-each select="//etudiant">
                <xsl:sort select="sum(notes/note) div count(notes/note)" data-type="number" order="descending"/>
                <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>
                <tr>
                  <xsl:if test="position() = 1"><xsl:attribute name="class">major</xsl:attribute></xsl:if>
                  <td class="rang"><xsl:value-of select="position()"/></td>
                  <td><xsl:value-of select="@matricule"/></td>
                  <td><xsl:value-of select="nom"/></td>
                  <td><xsl:value-of select="prenom"/></td>
                  <td><xsl:value-of select="@classe"/></td>
                  <td class="moyenne"><xsl:value-of select="format-number($moy, '0.00')"/></td>
                  <td>
                    <span>
                      <xsl:attribute name="class">badge <xsl:choose><xsl:when test="$moy &gt;= 10">reussite</xsl:when><xsl:otherwise>echec</xsl:otherwise></xsl:choose></xsl:attribute>
                      <xsl:choose><xsl:when test="$moy &gt;= 10">Réussite</xsl:when><xsl:otherwise>Échec</xsl:otherwise></xsl:choose>
                    </span>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>
          </table>

          <h2>Classement par classe</h2>
          <xsl:for-each select="//etudiant[generate-id() = generate-id(key('par-classe', @classe)[1])]">
            <xsl:sort select="@classe"/>
            <h3>Classe <xsl:value-of select="@classe"/></h3>
            <table>
              <thead><tr><th>Rang</th><th>Matricule</th><th>Nom</th><th>Prénom</th><th>Moyenne</th><th>Statut</th></tr></thead>
              <tbody>
                <xsl:for-each select="key('par-classe', @classe)">
                  <xsl:sort select="sum(notes/note) div count(notes/note)" data-type="number" order="descending"/>
                  <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>
                  <tr>
                    <td class="rang"><xsl:value-of select="position()"/></td>
                    <td><xsl:value-of select="@matricule"/></td>
                    <td><xsl:value-of select="nom"/></td>
                    <td><xsl:value-of select="prenom"/></td>
                    <td class="moyenne"><xsl:value-of select="format-number($moy, '0.00')"/></td>
                    <td>
                      <span>
                        <xsl:attribute name="class">badge <xsl:choose><xsl:when test="$moy &gt;= 10">reussite</xsl:when><xsl:otherwise>echec</xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:choose><xsl:when test="$moy &gt;= 10">Réussite</xsl:when><xsl:otherwise>Échec</xsl:otherwise></xsl:choose>
                      </span>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:for-each>

          <h2>Détail des notes par étudiant</h2>
          <xsl:for-each select="//etudiant">
            <xsl:sort select="nom"/>
            <h3><xsl:value-of select="nom"/> <xsl:value-of select="prenom"/> — <xsl:value-of select="@matricule"/></h3>
            <table>
              <thead><tr><th>Matière</th><th>Note</th><th>Statut</th></tr></thead>
              <tbody>
                <xsl:for-each select="notes/note">
                  <tr>
                    <td><xsl:value-of select="@matiere"/></td>
                    <td><xsl:value-of select="."/></td>
                    <td><xsl:choose><xsl:when test=". &gt;= 10">Réussite</xsl:when><xsl:otherwise>Échec</xsl:otherwise></xsl:choose></td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select="//note[not(@matiere = current()/notes/note/@matiere)]">
                  <xsl:if test="generate-id() = generate-id(//note[@matiere = current()/@matiere][1])">
                    <tr><td><xsl:value-of select="@matiere"/></td><td class="absent">absent</td><td>—</td></tr>
                  </xsl:if>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:for-each>

        </main>
        <footer>XML • XPath • XSLT — TP 3</footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>