<?xml version="1.0" encoding="UTF-8"?>
<!-- NOTE: This ruleset is NOT a replacement for the CVR.sch ruleset. This ruleset
    applies best practices that all implementors should consider following. -->
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="ttp://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://itl.nist.gov/ns/voting/1500-103/v1" prefix="cdf"/>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    <xsl:import-schema namespace="NIST_V0_cast_vote_records.xsd"
        schema-location="https://raw.githubusercontent.com/usnistgov/CastVoteRecords/14dfe26a9466524624d93345a715ecd3155fd4fd/NIST_V0_cast_vote_records.xsd"/>
    <sch:reference apply-rules="yes" name="Election" context="cdf:Election" />
    <!-- logical implication written a -> b = !a or b -->    
    <sch:pattern>        
        <!-- Streamability: none, enumerates all CVRs -->
      <!--  <sch:rule streaming="copy-of" context="element(*, cdf:CastVoteRecordReport)">
            <sch:let name="ballotAuditIds" value="cdf:CVR/BallotAuditId" />
            <sch:let name="uniqueIds" value="cdf:CVR/UniqueId" />
            <sch:assert test="count($ballotAuditIds) = count(distinct-values($ballotAuditIds))">BallotAuditIds must be unique across CVRs in Election ()</sch:assert>
            <sch:assert test="count($uniqueIds) = count(distinct-values($uniqueIds))">UniqueIds must be unique across CVRs in Election ()</sch:assert>            
        </sch:rule>-->
        <!-- Streamability: fine as is -->
        <sch:rule streaming="snapshot" context="element(*, cdf:CVR)">       
<!--            <sch:let name="originalSnapshots" value="cdf:CVRSnapshot[cdf:Type = 'original']" />-->
            <!-- There must be at most one original CVRSnapshot per CVR -->
<!--            <sch:assert role="error" test="count($originalSnapshots) = count(distinct-values($originalSnapshots))">More than one original CVRSnapshot found for CVR (<xsl:value-of select="@ObjectId"/>)</sch:assert>-->
        </sch:rule>        
        <sch:rule streaming="inherit" context="element(*, cdf:CVRSnapshot)">
            <sch:let name="ContestSelectionIds" value="cdf:CVRContest/cdf:ContestId"/>
            <!-- There can only be one CVRContest for each Contest in a CVR. -->
            <sch:assert test="count(distinct-values($ContestSelectionIds)) = count($ContestSelectionIds)" role="error">More than one CVRContest was found for the same contest in a CVRSnapshot (<xsl:value-of select="@ObjectId"/>).</sch:assert>            
        </sch:rule>        
        <sch:rule streaming="inherit" context="element(*, cdf:CVRContest)">
            <sch:let name="contestSelectionId" value="cdf:CVRContestSelection/cdf:ContestSelectionId"/>
            <!-- There can only be one CVRContestSelection for each ContestSelection in a CVRContest. -->
            <sch:assert test="count(distinct-values($contestSelectionId)) = count($contestSelectionId)" role="error">More than one CVRContestSelection was found for the same ContestSelection in a CVRContest for CVRSnapshot (<xsl:value-of select="../@ObjectId"/>).</sch:assert>
            <sch:assert test="not(cdf:CVRContestSelection/cdf:ContestSelectionId) or ($Election/id(cdf:CVRContestSelection/cdf:ContestSelectionId)/../@ObjectId = cdf:ContestId)" role="information">CVRContestSelection points to an incorrect ContestSelection () for the Contest () given in CVRSnapshot ()</sch:assert>            
        </sch:rule>
        <sch:rule streaming="inherit" context="element(*, cdf:CVRContestSelection)">
            <!-- XSLT has fn:element-with-id, but using idref() instead for better compatbility -->            
            <sch:assert test="not(cdf:ContestSelectionId) or ($Election/id(current()/cdf:ContestSelectionId)/../@ObjectId = ../cdf:ContestId)" role="information">CVRContestSelection points to an incorrect ContestSelection () for the Contest () given in CVRSnapshot ()</sch:assert>
            <!-- short circuit for RCV rules -->
            <!-- CVRContestSelection rules specific to RCV -->
            <sch:let name="isRCV" value="$Election/id(current()/../cdf:ContestId)/cdf:VoteVariation = 'rcv'"/>
            <!-- add rule for duplicate ranks? -->
            <sch:assert test="not($isRCV) or cdf:SelectionPosition/cdf:Rank" role="error">SelectionPosition with indication of RCV Contest () must include Rank for CVRSnapshot ()</sch:assert>
            <sch:assert test="not($isRCV) or (cdf:Rank and count(cdf:SelectionPosition[cdf:Rank]) > 0)" role="error">Effective rank must be calculable from SelectionPosition::Rank for CVRSnapshot ()</sch:assert>            
        </sch:rule>        
        <sch:rule streaming="inherit" context="element(*, cdf:SelectionPosition)">
            <sch:assert test="(cdf:HasIndication = ('no','unknown') or not(cdf:HasIndication)) or cdf:IsAllocable" role="error">IsAllocable must be set when selection position has indication.</sch:assert>
            <!-- Streamability: IMPOSSIBLE, parent axis -->
            <!--<sch:assert test="not(cdf:MarkMetricValue) or idref(ancestor-or-self::cdf:CVR/cdf:CreatingDeviceId)/MarkMetricType">MarkMetricType must be specified by the CreatingDevice whenever MarkMetricValue is used.</sch:assert>-->
            <sch:assert test="cdf:NumberVotes > 0" role="error">NumberVotes must be greater than zero. Use IsAllocable to control allocation of votes.</sch:assert>
            <sch:assert test="(not(cdf:IsGenerated) or cdf:IsGenerated = false()) or not(cdf:MarkMetricValue)">A generated indication should not have a MarkMetricValue</sch:assert>
        </sch:rule>
        <!-- reusable classes (i.e. not CVR specific) -->
        <!-- add rule for no duplicate candidates in a contest selection (or accross the entire contest) -->        
        <sch:rule streaming="off" context="element(*, cdf:Contest)">            
            <sch:assert test="cdf:VoteVariation" role="warn">VoteVariation is not set for Contest (<xsl:value-of select="@ObjectId" />). Third-party tabulators may not be able to determine tabulation rules to apply for this contest.</sch:assert>            
        </sch:rule>
        <!-- this rule does not seem to run in oxygen. An issue with overlapping rules? RJ says need to split into different patterns? -->
        <sch:rule streaming="off" context="element(*, cdf:CandidateContest)">
            <!-- need to flatten list -->
            <sch:let name="candidateSelectionIds" value="element(*, cdf:CandidateSelection)/cdf:CandidateIds" />
            <sch:assert test="count(distinct-values($candidateSelectionIds)) = count($candidateSelectionIds)" role="error">More than one CandidateSelection with the same CandidateId was found for CandidateContest (<xsl:value-of select="@ObjectId"/>)</sch:assert>            
        </sch:rule>        
        <sch:rule streaming="off" context="element(*, cdf:CandidateContest)/element(*, cdf:ContestSelection)">
            <sch:assert test="current() instance of element(*, cdf:CandidateSelection)">All selections under CandidateContest (<xsl:value-of select="../@ObjectId" />) must be of type CandidateSelection</sch:assert>            
        </sch:rule>
        <sch:rule streaming="off" context="element(*, cdf:PartyContest)/element(*, cdf:ContestSelection)">
            <sch:assert test="current() instance of element(*, cdf:PartySelection)">All selections under PartyContest (<xsl:value-of select="../@ObjectId" />) must be of type PartySelection</sch:assert>            
        </sch:rule>
        <!-- no special rule needed for RentionContest -->
        <sch:rule streaming="off" context="element(*, cdf:BallotMeasureContest)/element(*, cdf:ContestSelection)">
            <sch:assert test="current() instance of element(*, cdf:BallotMeasureSelection)">All selections under BallotMeasureContest (<xsl:value-of select="../@ObjectId" />) must be of type BallotMeasureSelection</sch:assert>            
        </sch:rule>        
    </sch:pattern>
</sch:schema>