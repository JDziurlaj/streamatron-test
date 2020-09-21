<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
               xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
               xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:cdf="http://itl.nist.gov/ns/voting/1500-103/v1"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               version="2.0"><!--
      Schematron validation stylesheet created with SchXslt 1.4.6 running
      XSLT processor SAXON EE 9.9.1.7 by Saxonica.
    -->
   <xsl:import xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               xmlns:mf="http://example.com/mf"
               href="position-accumulator.xsl"/>
   <xsl:mode xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
             xmlns:mf="http://example.com/mf"
             use-accumulators="#all"/>
   <xsl:output indent="yes"/>
   <xsl:import-schema namespace="http://itl.nist.gov/ns/voting/1500-103/v1"
                      schema-location="NIST_V0_cast_vote_records.xsd"/>
   <xsl:mode streamable="yes" use-accumulators="#all"/>
   <xsl:accumulator name="Election"
                    as="node()?"
                    initial-value="()"
                    streamable="yes">
      <xsl:accumulator-rule xmlns:saxon="http://saxon.sf.net/"
                            match="cdf:Election"
                            select="."
                            phase="end"
                            saxon:capture="yes"/>
   </xsl:accumulator>
   <xsl:template match="/">
      <xsl:variable name="report" as="element(schxslt:report)">
         <schxslt:report>
            <xsl:fork>
               <xsl:sequence>
                  <xsl:apply-templates select="." mode="d7e15-entry"/>
               </xsl:sequence>
            </xsl:fork>
         </schxslt:report>
      </xsl:variable>
      <xsl:variable name="schxslt:report" as="node()*">
         <xsl:for-each select="$report/schxslt:pattern">
            <xsl:sequence select="node()"/>
            <xsl:sequence select="$report/schxslt:rule[@pattern = current()/@id]/node()"/>
         </xsl:for-each>
      </xsl:variable>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
         <svrl:ns-prefix-in-attribute-values prefix="cdf" uri="http://itl.nist.gov/ns/voting/1500-103/v1"/>
         <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
         <xsl:sequence select="$schxslt:report"/>
      </svrl:schematron-output>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:mode name="d7e15" streamable="yes" use-accumulators="#all"/>
   <xsl:mode name="d7e15-entry" streamable="yes" use-accumulators="#all"/>
   <xsl:template match="/" mode="d7e15-entry">
   
         <schxslt:pattern id="d7e15@{base-uri(.)}">
            <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
               <xsl:attribute name="documents" select="base-uri(.)"/>
            </svrl:active-pattern>
         </schxslt:pattern>
         <xsl:apply-templates mode="d7e15" select="."/>
      <xsl:apply-templates select="accumulator-after('Election')" mode="d7e15-grounded"/>
   </xsl:template>
   <xsl:template match="element(*, cdf:CVR)" priority="9" mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:param name="schxslt:streamed-context"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = $schxslt:streamed-context])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVR)</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVR)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVR)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVR)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{$schxslt:streamed-context}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:CVR)" priority="9" mode="d7e15">
      <xsl:param name="schxslt:isBursting" select="false()" tunnel="yes"/>
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:choose>
         <xsl:when test="not($schxslt:isBursting)">
            <xsl:variable name="burstData" select="snapshot()"/>
            <xsl:apply-templates select="$burstData" mode="d7e15-grounded">
               <xsl:with-param name="schxslt:rules" select="$schxslt:rules"/>
               <xsl:with-param name="schxslt:streamed-context" select="'{generate-id()}'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="$burstData" mode="d7e15">
               <xsl:with-param name="schxslt:isBursting" tunnel="yes" select="true()"/>
               <xsl:with-param name="schxslt:rules" select="$schxslt:rules"/>
               <xsl:with-param name="schxslt:streamed-context" select="'{generate-id()}'"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates mode="#current"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="element(*, cdf:CVRSnapshot)"
                 priority="8"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:variable name="ContestSelectionIds" select="cdf:CVRContest/cdf:ContestId"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRSnapshot)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(count(distinct-values($ContestSelectionIds)) = count($ContestSelectionIds))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">count(distinct-values($ContestSelectionIds)) = count($ContestSelectionIds)</xsl:attribute>
                     <svrl:text>More than one CVRContest was found for the same contest in a CVRSnapshot ().</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRSnapshot)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRSnapshot)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRSnapshot)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:CVRContest)"
                 priority="7"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:variable name="contestSelectionId"
                    select="cdf:CVRContestSelection/cdf:ContestSelectionId"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRContest)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(count(distinct-values($contestSelectionId)) = count($contestSelectionId))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">count(distinct-values($contestSelectionId)) = count($contestSelectionId)</xsl:attribute>
                     <svrl:text>More than one CVRContestSelection was found for the same ContestSelection in a CVRContest for CVRSnapshot ().</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(cdf:CVRContestSelection/cdf:ContestSelectionId) or ($Election/id(cdf:CVRContestSelection/cdf:ContestSelectionId)/../@ObjectId = cdf:ContestId))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="information">
                     <xsl:attribute name="test">not(cdf:CVRContestSelection/cdf:ContestSelectionId) or ($Election/id(cdf:CVRContestSelection/cdf:ContestSelectionId)/../@ObjectId = cdf:ContestId)</xsl:attribute>
                     <svrl:text>CVRContestSelection points to an incorrect ContestSelection () for the Contest () given in CVRSnapshot ()</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRContest)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRContest)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRContest)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:CVRContestSelection)"
                 priority="6"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:variable name="isRCV"
                    select="$Election/id(current()/../cdf:ContestId)/cdf:VoteVariation = 'rcv'"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRContestSelection)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(cdf:ContestSelectionId) or ($Election/id(current()/cdf:ContestSelectionId)/../@ObjectId = ../cdf:ContestId))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="information">
                     <xsl:attribute name="test">not(cdf:ContestSelectionId) or ($Election/id(current()/cdf:ContestSelectionId)/../@ObjectId = ../cdf:ContestId)</xsl:attribute>
                     <svrl:text>CVRContestSelection points to an incorrect ContestSelection () for the Contest () given in CVRSnapshot ()</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not($isRCV) or cdf:SelectionPosition/cdf:Rank)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">not($isRCV) or cdf:SelectionPosition/cdf:Rank</xsl:attribute>
                     <svrl:text>SelectionPosition with indication of RCV Contest () must include Rank for CVRSnapshot ()</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not($isRCV) or (cdf:Rank and count(cdf:SelectionPosition[cdf:Rank]) &gt; 0))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">not($isRCV) or (cdf:Rank and count(cdf:SelectionPosition[cdf:Rank]) &gt; 0)</xsl:attribute>
                     <svrl:text>Effective rank must be calculable from SelectionPosition::Rank for CVRSnapshot ()</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRContestSelection)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CVRContestSelection)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CVRContestSelection)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:SelectionPosition)"
                 priority="5"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:SelectionPosition)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((cdf:HasIndication = ('no','unknown') or not(cdf:HasIndication)) or cdf:IsAllocable)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">(cdf:HasIndication = ('no','unknown') or not(cdf:HasIndication)) or cdf:IsAllocable</xsl:attribute>
                     <svrl:text>IsAllocable must be set when selection position has indication.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cdf:NumberVotes &gt; 0)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">cdf:NumberVotes &gt; 0</xsl:attribute>
                     <svrl:text>NumberVotes must be greater than zero. Use IsAllocable to control allocation of votes.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not((not(cdf:IsGenerated) or cdf:IsGenerated = false()) or not(cdf:MarkMetricValue))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">(not(cdf:IsGenerated) or cdf:IsGenerated = false()) or not(cdf:MarkMetricValue)</xsl:attribute>
                     <svrl:text>A generated indication should not have a MarkMetricValue</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:SelectionPosition)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:SelectionPosition)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:SelectionPosition)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:Contest)" priority="4" mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:Contest)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cdf:VoteVariation)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="warn">
                     <xsl:attribute name="test">cdf:VoteVariation</xsl:attribute>
                     <svrl:text>VoteVariation is not set for Contest (). Third-party tabulators may not be able to determine tabulation rules to apply for this contest.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:Contest)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:Contest)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:Contest)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:CandidateContest)"
                 priority="3"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:variable name="candidateSelectionIds"
                    select="element(*, cdf:CandidateSelection)/cdf:CandidateIds"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CandidateContest)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(count(distinct-values($candidateSelectionIds)) = count($candidateSelectionIds))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}"
                                      role="error">
                     <xsl:attribute name="test">count(distinct-values($candidateSelectionIds)) = count($candidateSelectionIds)</xsl:attribute>
                     <svrl:text>More than one CandidateSelection with the same CandidateId was found for CandidateContest ()</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CandidateContest)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CandidateContest)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CandidateContest)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)"
                 priority="2"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(current() instance of element(*, cdf:CandidateSelection))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">current() instance of element(*, cdf:CandidateSelection)</xsl:attribute>
                     <svrl:text>All selections under CandidateContest () must be of type CandidateSelection</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)"
                 priority="1"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(current() instance of element(*, cdf:PartySelection))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">current() instance of element(*, cdf:PartySelection)</xsl:attribute>
                     <svrl:text>All selections under PartyContest () must be of type PartySelection</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:template match="element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)"
                 priority="0"
                 mode="d7e15-grounded">
      <xsl:param name="schxslt:rules" as="element(schxslt:rule)*"/>
      <xsl:variable name="Election" select="accumulator-after('Election')"/>
      <xsl:choose>
         <xsl:when test="empty($schxslt:rules[@pattern = 'd7e15'][@context = generate-id(current())])">
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(current() instance of element(*, cdf:BallotMeasureSelection))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                      xmlns:mf="http://example.com/mf"
                                      location="{schxslt:location(.)}">
                     <xsl:attribute name="test">current() instance of element(*, cdf:BallotMeasureSelection)</xsl:attribute>
                     <svrl:text>All selections under BallotMeasureContest () must be of type BallotMeasureSelection</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d7e15@{base-uri(.)}">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:comment>
               <xsl:message xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">WARNING: Rule for context "element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)" shadowed by preceeding rule</xsl:message>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:mf="http://example.com/mf">
                  <xsl:attribute name="context">element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:next-match>
         <xsl:with-param name="schxslt:rules" as="element(schxslt:rule)*">
            <xsl:sequence select="$schxslt:rules"/>
            <schxslt:rule context="{generate-id()}" pattern="d7e15"/>
         </xsl:with-param>
      </xsl:next-match>
   </xsl:template>
   <xsl:function xmlns="http://www.w3.org/1999/XSL/TransformAlias"
                 xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                 xmlns:mf="http://example.com/mf"
                 name="schxslt:location"
                 as="xs:string"
                 visibility="public"
                 streamability="inspection">
      <xsl:param name="node" as="node()"/>
      <xsl:sequence select="$node =&gt; mf:path()"/>
   </xsl:function>
</xsl:transform>
