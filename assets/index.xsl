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
  <xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:strip-spaces select="*"/>
  <xsl:param name="version"/>
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
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.3/js/jquery.tablesorter.min.js">
          <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript">
          $(function() {
            $("#metrics").tablesorter();
          });
          $(function() {
            let params = (new URL(document.location)).searchParams;
            let org = params.get('org');
            if (org) {
              $('#metrics tbody tr:not(:has(&gt;td.org-' + org + '))').hide();
              $('#org').text('@' + org);
              $('#org-head').css('visibility', 'visible');
              console.log('Showing @' + org + ' org');
            }
          });
        </script>
        <style>
          td, th { font-family: monospace; font-size: 18px; line-height: 1em; }
          td.top { vertical-align: middle; }
          .num { text-align: right; }
          .left { border-bottom: 0; }
          section { width: auto; }
          header { text-align: center; }
          footer { text-align: center; font-size: 0.8em; line-height: 1.2em; color: gray; }
          article { border: 0; }
          td.avatar { vertical-align: middle; text-align: center; }
          td.avatar img,
          td.orgs img { width: 1.5em; height: 1.5em; vertical-align: middle; }
          .subtitle { font-size: 0.8em; line-height: 1em; color: gray; }
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
            <p id="org-head" style="visibility: hidden;">
              <xsl:text>You only see people who contributed to </xsl:text>
              <strong>
                <span id="org">
                  <xsl:text>@???</xsl:text>
                </span>
              </strong>
              <xsl:text>. </xsl:text>
              <xsl:text>Click </xsl:text>
              <a href="index.html">
                <xsl:text>here</xsl:text>
              </a>
              <xsl:text> to see all.</xsl:text>
            </p>
            <table id="metrics">
              <xsl:attribute name="data-sortlist">
                <xsl:text>[[</xsl:text>
                <xsl:for-each select="cobench/titles/title">
                  <xsl:sort select="."/>
                  <xsl:if test=". = 'Score'">
                    <xsl:value-of select="position() + 2"/>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>,1]]</xsl:text>
              </xsl:attribute>
              <colgroup>
                <col/>
                <col style="width: 2.5em;"/>
                <col/>
                <xsl:for-each select="cobench/titles/title">
                  <xsl:sort select="."/>
                  <col/>
                </xsl:for-each>
                <col/>
              </colgroup>
              <thead>
                <xsl:apply-templates select="cobench/titles"/>
              </thead>
              <xsl:apply-templates select="cobench/coders"/>
              <tfoot>
                <xsl:apply-templates select="cobench/totals"/>
                <xsl:apply-templates select="cobench/averages"/>
              </tfoot>
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
              <xsl:text>"Commits" is the total number of non-merge </xsl:text>
              <a href="https://github.com/git-guides/git-commit">
                <xsl:text>Git commits</xsl:text>
              </a>
              <xsl:text> to the default branch, authored by the user. </xsl:text>
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
              <xsl:text>"Msgs" is the total number of messages posted in pull requests where the user was a reviewer. </xsl:text>
              <xsl:text>"Pulls" is the total number of </xsl:text>
              <a href="https://docs.github.com/en/pull-requests">
                <xsl:text>pull requests</xsl:text>
              </a>
              <xsl:text> created by the user and already merged. </xsl:text>
              <xsl:text>"Reviews" is the total number of merged pull requests that were reviewed by the user. </xsl:text>
              <xsl:text>"Score" is an arithmetic summary of all metrics with multipliers: </xsl:text>
              <xsl:for-each select="cobench/weights/w">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:text>one </xsl:text>
                <xsl:choose>
                  <xsl:when test="substring(@id, string-length(@id)) = 's'">
                    <xsl:value-of select="substring(@id, 0, string-length(@id))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@id"/>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="position() = 1">
                    <xsl:text> costs </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text> — </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="text()"/>
                <xsl:text> point</xsl:text>
                <xsl:if test="text() != '1'">
                  <xsl:text>s</xsl:text>
                </xsl:if>
              </xsl:for-each>
              <xsl:text>.</xsl:text>
            </p>
            <p>
              <xsl:for-each select="cobench/titles/title[@subtitle]">
                <xsl:if test="position() &gt; 1">
                  <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="position() = 1">
                  <xsl:text> stands</xsl:text>
                </xsl:if>
                <xsl:text> for </xsl:text>
                <xsl:value-of select="@subtitle"/>
              </xsl:for-each>
              <xsl:text>.</xsl:text>
            </p>
            <p>
              <xsl:text>The numbers you see reflect the activity of the last </xsl:text>
              <b>
                <xsl:value-of select="cobench/@days"/>
                <xsl:text> days</xsl:text>
              </b>
              <xsl:text>.</xsl:text>
              <br/>
              <xsl:text>The XML with the data </xsl:text>
              <a href="index.xml">
                <xsl:text>is here</xsl:text>
              </a>
              <xsl:text>.</xsl:text>
            </p>
          </footer>
        </section>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="cobench/titles">
    <tr>
      <th class="sorter num">
        <xsl:text>Top</xsl:text>
      </th>
      <th colspan="2">
        <xsl:text>Programmer</xsl:text>
      </th>
      <xsl:for-each select="title">
        <xsl:sort select="."/>
        <th class="sorter num">
          <xsl:value-of select="."/>
        </th>
      </xsl:for-each>
      <th>
        <xsl:text>Orgs</xsl:text>
      </th>
    </tr>
  </xsl:template>
  <xsl:template match="cobench/totals">
    <xsl:variable name="totals" select="."/>
    <tr>
      <td colspan="3" style="text-align:right">Total:</td>
      <xsl:for-each select="/cobench/titles/title">
        <xsl:sort select="."/>
        <xsl:variable name="t" select="."/>
        <td class="num">
          <xsl:value-of select="$totals/w[@id=$t]"/>
        </td>
      </xsl:for-each>
      <td/>
    </tr>
  </xsl:template>
  <xsl:template match="cobench/averages">
    <xsl:variable name="averages" select="."/>
    <tr>
      <td colspan="3" style="text-align:right">Average:</td>
      <xsl:for-each select="/cobench/titles/title">
        <xsl:sort select="."/>
        <xsl:variable name="t" select="."/>
        <td class="num">
          <xsl:value-of select="$averages/w[@id=$t]"/>
        </td>
      </xsl:for-each>
      <td/>
    </tr>
  </xsl:template>
  <xsl:template match="cobench/coders">
    <tbody>
      <xsl:apply-templates select="coder"/>
    </tbody>
  </xsl:template>
  <xsl:template match="coder">
    <tr>
      <td class="num top">
        <xsl:variable name="score" select="metrics/m[@id='Score']"/>
        <xsl:variable name="pos" select="count(/cobench/coders/coder[metrics/m[@id='Score'] &gt; $score]) + 1"/>
        <xsl:attribute name="title">
          <xsl:value-of select="$pos"/>
        </xsl:attribute>
        <xsl:if test="$pos &lt;= 8">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="$pos"/>
        </xsl:if>
      </td>
      <td class="avatar">
        <img src="https://socatar.com/github/{@id}/64-64"/>
      </td>
      <td>
        <a href="https://github.com/{@id}">
          <xsl:text>@</xsl:text>
          <xsl:value-of select="@id"/>
        </a>
        <xsl:if test="@details">
          <br/>
          <span class="subtitle">
            <xsl:value-of select="@details"/>
          </span>
        </xsl:if>
      </td>
      <xsl:for-each select="metrics/m">
        <xsl:sort select="@id"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <td class="orgs">
        <xsl:attribute name="class">
          <xsl:text>orgs</xsl:text>
          <xsl:for-each select="orgs/org">
            <xsl:text> org-</xsl:text>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:attribute>
        <xsl:for-each select="orgs/org">
          <xsl:sort select="."/>
          <xsl:if test="position() &gt; 1">
            <xsl:text> </xsl:text>
          </xsl:if>
          <a href="?org={.}" title="{.}">
            <xsl:value-of select="substring(., 1, 2)"/>
            <xsl:if test="string-length(.) &gt; 2">
              <xsl:text>…</xsl:text>
            </xsl:if>
          </a>
        </xsl:for-each>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="m">
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="@hideZero and .='0'">
          <!-- nothing -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="body">
      <xsl:choose>
        <xsl:when test="@href">
          <a href="{@href}">
            <xsl:value-of select="$value"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <td class="num">
      <xsl:choose>
        <xsl:when test="@actual">
          <span class="firebrick">
            <xsl:copy-of select="$body"/>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$body"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@actual">
        <br/>
        <span class="subtitle" title="The actual value of the metric was capped">
          <xsl:value-of select="@actual"/>
        </span>
      </xsl:if>
    </td>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
