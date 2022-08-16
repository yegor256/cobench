<?xml version="1.0" encoding="UTF-8"?>
<!--
(The MIT License)

Copyright (c) 2022 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output encoding="UTF-8" method="html"/>
  <xsl:param name="version"/>
  <xsl:key name="titles" match="/cobench/titles/title" use="."/>
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>cobench</title>
        <meta charset="UTF-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <link rel="icon" href="https://raw.githubusercontent.com/yegor256/cobench/master/logo.svg" type="image/svg"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/tacit@gh-pages/tacit-css.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/gh/yegor256/drops@gh-pages/drops.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"/>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js"/>
        <script type="text/javascript">
          $(function() {
            $("#metrics").tablesorter();
          });
        </script>
        <style>
          td, th { font-family: monospace; font-size: 18px; }
          .num { text-align: right; }
          .left { border-bottom: 0; }
          header { text-align: center; }
          footer { text-align: center; font-size: 0.8em; line-height: 1.2em; color: gray; }
          article { width: 60em; border: 0; }
          .avatar { width: 1em; height: 1em; }
          .sorter { cursor: pointer; }
        </style>
      </head>
      <body>
        <section>
          <header>
            <p>
              <a href="">
                <img src="https://raw.githubusercontent.com/yegor256/cobench/master/logo.svg" style="width:64px"/>
              </a>
            </p>
          </header>
          <article>
            <table id="metrics">
              <xsl:apply-templates select="cobench/titles"/>
              <xsl:apply-templates select="cobench/coders"/>
            </table>
          </article>
          <footer>
            <p>
              <xsl:text>The page was generated by </xsl:text>
              <a href="https://github.com/yegor256/cobench">
                <xsl:text>cobench</xsl:text>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$version"/>
              </a>
              <xsl:text> on </xsl:text>
              <xsl:value-of select="cobench/@time"/>
              <xsl:text>. </xsl:text>
              <xsl:text>"Commits" is the total number of </xsl:text>
              <a href="https://github.com/git-guides/git-commit">
                <xsl:text>Git commits</xsl:text>
              </a>
              <xsl:text> authored by the user. </xsl:text>
              <xsl:text>"HoC" is the total number of user's </xsl:text>
              <a href="https://www.yegor256.com/2014/11/14/hits-of-code.html">
                <xsl:text>hits of code</xsl:text>
              </a>
              <xsl:text>. </xsl:text>
              <xsl:text>"Issues" is the total number of issues submitted by the user. </xsl:text>
              <a href="https://docs.github.com/en/issues">
                <xsl:text>issues</xsl:text>
              </a>
              <xsl:text>. </xsl:text>
              <xsl:text>"Pulls" is the total number of </xsl:text>
              <a href="https://docs.github.com/en/pull-requests">
                <xsl:text>pull requests</xsl:text>
              </a>
              <xsl:text> created by the user and already merged. </xsl:text>
              <xsl:text>"Reviews" is the total number of merged pull requests that were reviewed by the user. </xsl:text>
              <xsl:text>"Score" is an arithmetic summary of all metrics with multipliers: </xsl:text>
              <xsl:text>one Pull costs 100 points, </xsl:text>
              <xsl:text>one Issue — 50 points, </xsl:text>
              <xsl:text>one Review — 40 points, </xsl:text>
              <xsl:text>one Commit — 5 points, </xsl:text>
              <xsl:text>one HoC — just 1 point.</xsl:text>
            </p>
            <p>
              <xsl:text>The numbers you see reflect the activity of the last </xsl:text>
              <b>
                <xsl:value-of select="cobench/@days"/>
                <xsl:text> days</xsl:text>
              </b>
              <xsl:text>.</xsl:text>
            </p>
          </footer>
        </section>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="cobench/titles">
    <thead>
      <tr>
        <th/>
        <th/>
        <xsl:for-each select="title[generate-id() = generate-id(key('titles', .)[1])]">
          <xsl:sort select="."/>
          <th class="sorter num">
            <xsl:value-of select="."/>
          </th>
        </xsl:for-each>
      </tr>
    </thead>
  </xsl:template>
  <xsl:template match="cobench/coders">
    <tbody>
      <xsl:apply-templates select="coder"/>
    </tbody>
  </xsl:template>
  <xsl:template match="coder">
    <tr>
      <td>
        <img src="https://socatar.com/github/{@id}/64-64" class="avatar"/>
      </td>
      <td>
        <a href="https://github.com/{@id}">
          <xsl:text>@</xsl:text>
          <xsl:value-of select="@id"/>
        </a>
      </td>
      <xsl:for-each select="metrics/m">
        <xsl:sort select="@id"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </tr>
  </xsl:template>
  <xsl:template match="m">
    <td class="num">
      <xsl:choose>
        <xsl:when test="@href = ''">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <a href="{@href}">
            <xsl:value-of select="."/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
