<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:dri="http://di.tamu.edu/DRI/1.0/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/TR/xlink/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:confman="org.dspace.core.ConfigurationManager"
                exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).

        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information

        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->
    <xsl:template match="dri:document">

        <xsl:choose>
            <xsl:when test="not($isModal)">


            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
            </xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7]&gt; &lt;html class=&quot;no-js lt-ie9 lt-ie8 lt-ie7&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 7]&gt;    &lt;html class=&quot;no-js lt-ie9 lt-ie8&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 8]&gt;    &lt;html class=&quot;no-js lt-ie9&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if gt IE 8]&gt;&lt;!--&gt; &lt;html class=&quot;no-js&quot; lang=&quot;en&quot;&gt; &lt;!--&lt;![endif]--&gt;
            </xsl:text>

                <!-- First of all, build the HTML head element -->

                <xsl:call-template name="buildHead"/>

                <!-- Then proceed to the body -->
                <body>
                    <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
                   chromium.org/developers/how-tos/chrome-frame-getting-started -->
                    <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->
                    <xsl:choose>
                        <xsl:when
                                test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                            <xsl:apply-templates select="dri:body/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildHeader"/>

                            <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                            <div id="no-js-warning-wrapper" class="hidden">
                                <div id="no-js-warning">
                                    <div class="notice failure">
                                        <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                    </div>
                                </div>
                            </div>

                            <!--container fluid-->
                            <div class="container-fluid">
                                <div class="row">
                                    <!--carousel for sliding images in header section -->
                                    <div id="pustakalaya-slider" class="carousel slide" data-ride="carousel">

                                        <!-- Wrapper for slides -->
                                        <div class="carousel-inner" style="margin-top:10px;">
                                            <div class="item active">
                                                <img src="{concat($theme-path, '/images/knowledge-in-your-pocket01.png')}" style="width:100%;"/>
                                            </div>

                                            <div class="item">
                                                <img src="{concat($theme-path, '/images/celebrating-diversity.png')}"
                                                     alt="OLE Nepal's android application" style="width:100%;"/>
                                            </div>

                                            <div class="item">
                                                <img src="{concat($theme-path, '/images/for-the-community.png')}"
                                                     alt="slider 3" style="width:100%;"/>
                                            </div>
                                            <div class="item">
                                                <img src="{concat($theme-path, '/images/childrens-books-in-nepali-language.png')}"
                                                     alt="slider 4" style="width:100%;"/>
                                            </div>
                                        </div><!--end wrapper slides-->

                                        <!-- Left and right controls -->
                                        <a class="left carousel-control" href="#pustakalaya-slider" data-slide="prev">
                                            <span class="glyphicon glyphicon-chevron-left"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="right carousel-control" href="#pustakalaya-slider" data-slide="next">
                                            <span class="glyphicon glyphicon-chevron-right"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div><!--end carousel image slider -->
                                </div><!--end row-->
                            </div><!--end container fluid-->

                            <!-- custom banner for homepage goes here -->
                            <div id="pustakalayaBanner">
                                <!-- Banner -->
                                <!-- End banner -->

                                <!-- Browse books and search bar goes here -->
                                <div class="container-fluid">
                                    <div class="row">
                                        <div class="col-md-4" style="background:#16a085; height:40px;">
                                            <p class="text-center" style="color:#eeeeee; padding-top:10px;"><i18n:text>xmlui.BrowseBooks</i18n:text></p>
                                        </div>
                                        <!-- search box -->
                                        <div style="background-color:#e74c3c;height:40px;" class="col-md-4">
                                            <form method="post" action="./discover">
                                                <div class="col-sm-12">
                                                    <div class="input-group" style="padding-top:7px; padding-bottom:5px;">
                                                        <input type="text" name="query" class="form-control" placeholder="Search for books, audio, video, title..." style="height:25px;" autocomplete="off" />
                                                        <span class="input-group-btn" style="25px;">
                                                            <button style="height:26px; background:#c0392b; border-color:#c0392b;" class="btn btn-default" type="submit">
                                                                <i style="color:#FFFFFF;vertical-align:top" class="glyphicon glyphicon-search text-center"></i>
                                                            </button>
                                                        </span>
                                                    </div><!-- /input-group -->
                                                </div>
                                            </form>
                                        </div>
                                        <!-- Advance search -->
                                        <div class="col-md-4" style="background:#e74c3c; height:40px;">
                                            <p class="pull-left" style="color:#eeeeee; padding-top:10px;"><i18n:text>xmlui.advanceSearch</i18n:text></p>
                                        </div>
                                    </div><!-- End container fluid -->
                                </div><!-- End browse books and search bar -->

                                <!-- Book browsing -->
                                <div class="container-fluid" style="background:#FFF3E0;">
                                    <div class="row">
                                        <!-- Browse by section -->
                                        <div class="col-md-4" id="book-browsing" style="margin-left:5.5%;">
                                            <ul>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Literature+and+Arts" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_literature_and_arts</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Course+Materials" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_course_materials</i18n:text></a><i18n:text></i18n:text></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Teaching+Materials" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_teaching_materials</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Magazines+and+Newspapers" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_magazines_and_newspapers</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Agriculture+and+Diversity" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_agriculture_and_diversity</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Environment" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_environment</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Science+and+Technology" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_science_and_technology</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=All+Categories" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_all_categories</i18n:text></a></li>
                                                <li><a href="{$context-path}/discover?filtertype=category&amp;filter_relational_operator=equals&amp;filter=Title+or+Authors" class="text-capitalize"><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_titles</i18n:text><i18n:text>xmlui.ArtifactBrowser.Navigation.browse_authors</i18n:text></a></li>
                                            </ul>
                                        </div>
                                        <!-- Book gallery demo -->
                                        <div class="col-md-8" id="book-gallery">
                                            <!-- Book Banner -->
                                        </div>
                                    </div>
                                </div><!-- container  end -->
                                <br/>

                                <!-- nteractive Educational software  -->
                                <div class="pustakalayaSection" style="background:#A5D6A7; margin-top:-20px;">
                                    <div class="container">
                                        <h4 class="text-center text-capitalize"  style="color:#060605;">Interactive Education softwares</h4>
                                        <div class="col-md-10 col-md-offset-1 col-sm-12 col-xs-12">
                                            <div class="well">
                                                <div id="myCarousel" class="carousel slide">
                                                    <!--Carousel items-->
                                                    <div class="carousel-inner">
                                                        <div class="item active">
                                                            <div class="row">
                                                                <div class="col-sm-2"><a href="http://pustakalaya.org/epaath/" target="_blank"><img src="{$theme-path}/images/e-paath.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="http://pustakalaya.org/lekids.php" target="_blank"><img src="{$theme-path}/images/learn-english-for-kids.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="http://pustakalaya.org/elkids.php" target="_blank"><img src="{$theme-path}/images/e-learning-forkids.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="http://pustakalaya.org/sabdakosh.php" target="_blank"><img src="{$theme-path}/images/npp-logo.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="{$theme-path}/images/simulations.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="http://pustakalaya.org/audio.php" target="_blank"><img src="{$theme-path}/images/audiobook.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>
                                                            <!--row-->
                                                        </div>
                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <!--item-->
                                                    </div>
                                                    <!--carousel-inner-->
                                                    <a class="left carousel-control" href="#myCarousel" data-slide="prev">‹</a>

                                                    <a class="right carousel-control" href="#myCarousel" data-slide="next">›</a>
                                                </div>
                                                <!--myCarousel-->
                                            </div>
                                            <!--well-->
                                        </div>
                                        <!--Static content-->
                                    </div>
                                </div>

                                <!--  Interactive audio video materials -->
                                <div class="pustakalayaSection" style="background:#81C784; margin-top:-20px;">

                                    <div class="container">
                                        <h4 class="text-center text-capitalize" style="color:#060605;">Educational audio videos</h4>
                                        <div class="col-md-10 col-md-offset-1 col-sm-12 col-xs-12">
                                            <div class="well">
                                                <div id="myCarousel2" class="carousel slide">
                                                    <!--Carousel items-->
                                                    <div class="carousel-inner">
                                                        <div class="item active">
                                                            <div class="row">
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-2"><a href="#x"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <!--item-->
                                                    </div>
                                                    <!--carousel-inner-->
                                                    <a class="left carousel-control" href="#myCarousel2" data-slide="prev">‹</a>

                                                    <a class="right carousel-control" href="#myCarousel2" data-slide="next">›</a>
                                                </div>
                                                <!--myCarousel2-->
                                            </div>
                                            <!--well-->
                                        </div>
                                        <!--Static content-->
                                    </div>
                                </div>

                                <!-- Reference materials -->
                                <div class="pustakalayaSection" style="background:#A5D6A7; margin-top:-20px;">
                                    <div class="container">
                                        <h4 class="text-center text-capitalize" style="color:#060605;">References Materials</h4>
                                        <div class="col-md-6 col-md-offset-3 col-sm-12 col-xs-12">
                                            <div class="well">
                                                <div id="myCarousel3" class="carousel slide">
                                                    <!-- Carousel items -->
                                                    <div class="carousel-inner">
                                                        <div class="item active">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="http://pustakalaya.org/sabdakosh.php" target="_blank"><img src="{$theme-path}/images/nepal-dictionary.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="http://pustakalaya.org/maps.php" target="_blank"><img src="{$theme-path}/images/openstreetmap_withtext.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="http://pustakalaya.org/sabdakosh.php" target="_blank"><img src="{$theme-path}/images/nepali-dictionary.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="http://pustakalaya.org/list.php?collection_pid=Pustakalaya:65" target="_blank"><img src="{$theme-path}/images/Wikipedia_for_Schools_2013_logo.png" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>
                                                            <!-- row -->
                                                        </div>

                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/250x250" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>

                                                        <!--item-->
                                                        <div class="item">
                                                            <div class="row">
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                                <div class="col-sm-3"><a href="#x" class="thumbnail"><img src="http://placehold.it/150x150" alt="Image" class="img-responsive"/></a>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <!--item-->
                                                    </div>
                                                    <!--carousel-inner-->
                                                    <a class="left carousel-control" href="#myCarousel3" data-slide="prev">‹</a>

                                                    <a class="right carousel-control" href="#myCarousel3" data-slide="next">›</a>
                                                </div>
                                                <!--myCarousel3-->
                                            </div>
                                            <!--well-->
                                        </div>
                                        <!--Static content-->
                                    </div>
                                </div>

                                <!--some info-->
                                <!--Small Info-->
                                <div class="pustakalayaSection" style="background:#ffffff; margin-top: 30px;">
                                    <div class="container">
                                        <div class="row">
                                            <div class="col-md-10 col-md-offset-1 col-sm-12 col-xs-12" style="color:#666666; font-size: 12px;">
                                                <p class="text-justify">
                                                    <i18n:text>xmlui.aboutHomePage</i18n:text> <a style="color:#e74c3c; cursor:pointer; text-decoration:none;"><i18n:text>xmlui.more</i18n:text> &gt;&gt;</a>
                                                </p>
                                            </div>

                                        </div><!-- end row-->
                                        <div class="row">
                                            <div class="col-md-6 col-md-offset-1 col-sm-12 col-xs-12" style="color:#666666; font-size: 12px;">
                                                <p class="text-left"><i18n:text>xmlui.you.can.bring.epustakalaya.to.your.school</i18n:text>  <a href="/" style="color:#e74c3c; cursor:pointer; text-decoration:none;"><i18n:text>xmlui.more</i18n:text> &gt;&gt;</a>

                                                </p>
                                                <p class="text-left"><i18n:text>xmlui.you.can.donate.books.to.epustakalaya</i18n:text>  <a href="/" style="color:#e74c3c; cursor:pointer; text-decoration:none;"><i18n:text>xmlui.more</i18n:text> &gt;&gt;</a>
                                                </p>
                                            </div>
                                            <div class="col-md-4 col-sm-12 col-xs-12">
                                                <br/>
                                                <a href="https://play.google.com/store/apps/details?id=com.ole.epustakalaya" target="_blank"><img src="{$theme-path}/images/android-app-logo.png" style="width:200px; height:50px; margin-left:43%;"/></a>
                                            </div>
                                        </div>
                                        <!--Static content-->
                                    </div>
                                </div>

                            </div>


                            <div id="main-container" class="container">

                                <div class="row row-offcanvas row-offcanvas-right">
                                    <div class="horizontal-slider clearfix">
                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content">
                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                            <div class="visible-xs visible-sm">
                                                <xsl:call-template name="buildFooter"/>
                                            </div>
                                        </div>
                                        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            <xsl:apply-templates select="dri:options"/>
                                        </div>

                                    </div>
                                </div>

                                <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                                <!--<div class="hidden-xs hidden-sm">
                                    <xsl:call-template name="buildFooter"/>
                                </div>-->
                            </div>


                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Javascript at the bottom for fast page loading -->
                    <xsl:call-template name="buildFooter"/>
                    <xsl:call-template name="addJavascript"/>
                </body>
                <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>

            </xsl:when>
            <xsl:otherwise>
                <!-- This is only a starting point. If you want to use this feature you need to implement
                JavaScript code and a XSLT template by yourself. Currently this is used for the DSpace Value Lookup -->
                <xsl:apply-templates select="dri:body" mode="modal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!-- Mobile viewport optimized: h5bp.com/viewport -->
            <meta name="viewport" content="width=device-width,initial-scale=1"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <!-- include css for video and audio playback -->
            <link type="text/css" rel="stylesheet">
                <xsl:attribute name="src"><xsl:value-of select="./tomcat/webapps/ROOT/video.js/video.js.css"/>
                </xsl:attribute>
            </link>

            <script>
                <xsl:attribute name="src"><xsl:value-of select="./tomcat/webapps/ROOT/video.js/video.min.js"/>
                </xsl:attribute>
            </script>

            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>

            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS'][not(@qualifier)]">
                <meta name="ROBOTS">
                    <xsl:attribute name="content">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS']"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>
            <!-- Add stylesheets -->

            <!--TODO figure out a way to include these in the concat & minify-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$theme-path"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <link rel="stylesheet" href="{concat($theme-path, 'styles/main.css')}"/>

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script>
                //Clear default text of emty text areas on focus
                function tFocus(element)
                {
                if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of emty text areas on submit
                function tSubmit(form)
                {
                var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}
                }
                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                function disableEnterKey(e)
                {
                var key;

                if(window.event)
                key = window.event.keyCode;     //Internet Explorer
                else
                key = e.which;     //Firefox and Netscape

                if(key == 13)  //if "Enter" pressed, then disable!
                return false;
                else
                return true;
                }
            </script>

            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;![endif]--&gt;</xsl:text>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]" />
            <title>
                <xsl:choose>
                    <xsl:when test="starts-with($request-uri, 'page/about')">
                        <i18n:text>xmlui.mirage2.page-structure.aboutThisRepository</i18n:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>

            <!-- Add MathJAX JS library to render scientific formulas-->
            <xsl:if test="confman:getProperty('webui.browse.render-scientific-formulas') = 'true'">
                <script type="text/x-mathjax-config">
                    MathJax.Hub.Config({
                    tex2jax: {
                    inlineMath: [['$','$'], ['\\(','\\)']],
                    ignoreClass: "detail-field-data|detailtable|exception"
                    },
                    TeX: {
                    Macros: {
                    AA: '{\\mathring A}'
                    }
                    }
                    });
                </script>
                <script type="text/javascript" src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">&#160;</script>
            </xsl:if>

        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">


        <header>
            <!-- menu icon -->
            <div class="navbar navbar-static-top" role="navigation" style="margin-top:15px; margin-bottom:15px;">
             <div class="container">

            <!-- Pustakalaya custom navbar -->
            <div class="row">
                <div class="col-md-2">
                    <a class="navbar-brand" href="/">
                        <img src="{$theme-path}/images/ep_logo.png" style="height:40px; padding-bottom:10px;"/>
                    </a>
                </div><!-- Logo -->
                <div class="col-md-6 col-md-offset-1" id="pustakalaya-navbar"
                     style="padding-top:10px; padding-bottom:10px;">
                    <div style="border-radius: 10px; background:#27ae60;
                            width:100%; padding-left:8%; padding-right:5%;">


                        <div class="navbar-header">
                            <button type="button" data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle" id="collapse_button" style="background-color:#dddddd;" aria-controls="pustakalaya-navbar"><span style="background-color:black;" class="sr-only">Toggle navigation</span><span style="background-color:black;" class="icon-bar"></span><span style="background-color:black;" class="icon-bar"></span><span style="background-color:black;" class="icon-bar"></span></button>
                        </div>
                        <div class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
                            <ul id="pustakalaya-navbar" class="nav navbar-nav" >
                                <li class="dropdown" id="pustakalaya-dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" role="button" id="pustakalaya-menu-toggle"><i18n:text>xmlui.header.menu.browsePustakalaya</i18n:text><span class="caret"></span></a>
                                    <ul class="dropdown-menu" id="pustakalaya-dropdown-menu" style="padding-top:0px !important; padding-bottom:0px !important">
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=title">Browse by title</a></li>
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=level">Browse by Education level</a></li>
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=type">Browse by Data type</a></li>
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=category">Browse by Subjects</a></li>
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=author">Browse by Authors</a></li>
                                        <li><a class="text-capitalize" href="{$context-path}/browse?type=dateissued">Browse by Issue Date</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <a href="#educational-software" class="text-capitalized" style="color:#FFFF;"><i18n:text>xmlui.header.menu.educational.softwares</i18n:text></a>
                                </li>
                                <li>
                                    <a href="#educational-software" class="text-capitalized" style="color:#FFFF;"><i18n:text>xmlui.header.menu.audio.video</i18n:text></a>
                                </li>
                            </ul>
                        </div>

                    </div>
                </div>
                <div class="col-sm-1  hidden-xs">
                    <img src="{$theme-path}/images/flag-nepal.png" style="padding-left:10px; padding-right:10px; margin-top:15px; margin-left:70px;"/>
                </div>
                <div class="col-md-2">
                    <div class="navbar-header pull-right hidden-xs">
                        <ul class="nav navbar-nav pull-left">
                            <xsl:call-template name="languageSelection"/>
                        </ul>
                        <ul class="nav navbar-nav pull-left">
                            <li class="active">
                                <a href="{$context-path}/admin/panel">
                                    <i18n:text>xmlui.administrative.Navigation.administrative_control_panel</i18n:text>
                                </a>
                            </li>
                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                            <span class="hidden-xs">
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>

                        <button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
                            <span class="sr-only">
                                <i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text>
                            </span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                </div><!-- Language selection -->
            </div>
        <!--    <div class="navbar navbar-default navbar-static-top" role="navigation">
                <div class="container">
                    <div class="navbar-header">

                        <button type="button" class="navbar-toggle" data-toggle="offcanvas">
                            <span class="sr-only">
                                <i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text>
                            </span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

                        <a href="{$context-path}/" class="navbar-brand">
                            <img src="{$theme-path}/images/DSpace-logo-line.svg" />
                        </a>


                        <div class="navbar-header pull-right visible-xs hidden-sm hidden-md hidden-lg">
                            <ul class="nav nav-pills pull-left ">

                                <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
                                    <li id="ds-language-selection-xs" class="dropdown">
                                        <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                                        <button id="language-dropdown-toggle-xs" href="#" role="button" class="dropdown-toggle navbar-toggle navbar-link" data-toggle="dropdown">
                                            <b class="visible-xs glyphicon glyphicon-globe" aria-hidden="true"/>
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle-xs" data-no-collapse="true">
                                            <xsl:for-each
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                                                <xsl:variable name="locale" select="."/>
                                                <li role="presentation">
                                                    <xsl:if test="$locale = $active-locale">
                                                        <xsl:attribute name="class">
                                                            <xsl:text>disabled</xsl:text>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="$current-uri"/>
                                                            <xsl:text>?locale-attribute=</xsl:text>
                                                            <xsl:value-of select="$locale"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of
                                                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </li>
                                </xsl:if>

                                <xsl:choose>
                                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                        <li class="dropdown">
                                            <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button"  data-toggle="dropdown">
                                                <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                            </button>
                                            <ul class="dropdown-menu pull-right" role="menu"
                                                aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                        <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    </a>
                                                </li>
                                            </ul>
                                        </li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>
                                            <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
                                                <button class="navbar-toggle navbar-link">
                                                    <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                                </button>
                                            </form>
                                        </li>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                        </div>
                    </div>

                    <div class="navbar-header pull-right hidden-xs">
                        <ul class="nav navbar-nav pull-left">
                            <xsl:call-template name="languageSelection"/>
                        </ul>
                        <ul class="nav navbar-nav pull-left">
                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                            <span class="hidden-xs">
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>

                        <button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
                            <span class="sr-only"><i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                </div>

            </div>-->
            </div>
            </div>

        </header>

    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildTrail">
        <div class="trail-wrapper hidden-print">
            <div class="container">
                <div class="row">
                    <!--TODO-->
                    <div class="col-xs-12">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs">
                                    <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                       data-toggle="dropdown">
                                        <xsl:variable name="last-node"
                                                      select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                        <xsl:choose>
                                            <xsl:when test="$last-node/i18n:*">
                                                <xsl:apply-templates select="$last-node/*"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$last-node/text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>&#160;</xsl:text>
                                        <b class="caret"/>
                                    </a>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                             mode="dropdown"/>
                                    </ul>
                                </div>
                                <ul class="breadcrumb hidden-xs">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <ul class="breadcrumb">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>


    </xsl:template>

    <!--The Trail-->
    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <li>
            <xsl:if test="position()=1">
                <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
            </xsl:if>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="dri:trail" mode="dropdown">
        <!--put an arrow between the parts of the trail-->
        <li role="presentation">
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a role="menuitem">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:if test="position()=1">
                            <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                        </xsl:if>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:when test="position() > 1 and position() = last()">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                    <a role="menuitem" href="#">
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:if test="position()=1">
                        <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                    </xsl:if>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!--The License-->
    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
        />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
        />
        <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
            <div about="{$handleUri}" class="row">
                <div class="col-sm-3 col-xs-12">
                    <a rel="license"
                       href="{$ccLicenseUri}"
                       alt="{$ccLicenseName}"
                       title="{$ccLicenseName}"
                    >
                        <xsl:call-template name="cc-logo">
                            <xsl:with-param name="ccLicenseName" select="$ccLicenseName"/>
                            <xsl:with-param name="ccLicenseUri" select="$ccLicenseUri"/>
                        </xsl:call-template>
                    </a>
                </div> <div class="col-sm-8">
                <span>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                    <xsl:value-of select="$ccLicenseName"/>
                </span>
            </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="cc-logo">
        <xsl:param name="ccLicenseName"/>
        <xsl:param name="ccLicenseUri"/>
        <xsl:variable name="ccLogo">
            <xsl:choose>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by/')">
                    <xsl:value-of select="'cc-by.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-sa/')">
                    <xsl:value-of select="'cc-by-sa.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nd/')">
                    <xsl:value-of select="'cc-by-nd.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc/')">
                    <xsl:value-of select="'cc-by-nc.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-sa/')">
                    <xsl:value-of select="'cc-by-nc-sa.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-nd/')">
                    <xsl:value-of select="'cc-by-nc-nd.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/zero/')">
                    <xsl:value-of select="'cc-zero.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/mark/')">
                    <xsl:value-of select="'cc-mark.png'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'cc-generic.png'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <img class="img-responsive">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($theme-path,'/images/creativecommons/', $ccLogo)"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="$ccLicenseName"/>
            </xsl:attribute>
        </img>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <footer>

            <div class="container ">
                <!--<div class="row footer-banner-first">-->
                <!--<div class="col-sm-6">-->
                <!--<p style="color:#FFF">Developed and Maintained by</p>-->
                <!--<a href="http://www.pustakalaya.org" target="_blank">-->
                <!--<img class="pustakalaya-logo" src="{concat($theme-path, '/images/pustakalaya-logo.png')}"/>-->
                <!--</a>-->
                <!--</div>-->
                <!--<div class="col-sm-6">-->
                <!--<nav class="navbar" role="navigation">-->
                <!--<ul class="nav navbar-nav navbar-right">-->
                <!--<li><button type="button" class="btn btn-sm btn-default " style="maring-top:20px;" >-->
                <!--connect-->
                <!--</button></li>-->
                <!--<li><a  href="https://www.facebook.com/Epustakalaya" target="_blank">-->
                <!--<img class="social-media-logo" src="{concat($theme-path, '/images/facebook.png')}"/>-->
                <!--</a></li>-->
                <!--<li><a href="https://www.twitter.com/Epustakalaya" target="_blank">-->
                <!--<img class="social-media-logo" src="{concat($theme-path, '/images/twiter.png')}"/>-->
                <!--</a></li>-->
                <!--<li><a class="pull-right" href="https://www.instagram.com/Epustakalaya" target="_blank">-->
                <!--<img class="social-media-logo" src="{concat($theme-path, '/images/instagram.png')}"/>-->
                <!--</a></li>-->

                <!--</ul>-->
                <!--</nav>-->
                <!--</div>-->
                <!--</div>-->
            </div><!-- content container -->
            <!--upper banner-->
            <div class="footer-banner-first">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6">
                            <p style="color:#FFF" class="text-capitalized"><i18n:text>xmlui.developed.and.maintained.by</i18n:text></p>
                            <img class="pustakalaya-logo" src="{$theme-path}/images/eplogo.png"
                                 style="height=30px; width=30px;"/>
                        </div>
                        <div class="col-md-6">
                            <a class="pull-right" href="https://www.instagram.com/Epustakalaya" target="_blank">
                                <img class="social-media-logo" src="{concat($theme-path, '/images/instagram.png')}"
                                     style="margin:20px; color:#444444;"/>
                            </a>
                            <a class="pull-right" href="https://www.twitter.com/Epustakalaya" target="_blank">
                                <img class="social-media-logo" src="{concat($theme-path, '/images/twiter.png')}"
                                     style="margin:20px;"/>
                            </a>
                            <a class="pull-right" href="https://www.facebook.com/Epustakalaya" target="_blank">
                                <img class="social-media-logo" src="{concat($theme-path, '/images/facebook.png')}"
                                     style="margin:20px;"/>
                            </a>
                            <a class="pull-right" href="">
                                <button class="btn btn-primary" style="margin:20px;">Contact</button>
                            </a>
                        </div>
                    </div><!-- end row -->
                </div><!-- end container -->
            </div><!-- end first banner -->

            <!-- second banner -->
            <div class="footer-banner-second">
                <div class="container">
                    <div class="row ">
                        <!-- First Box-->
                        <div class="col-md-6">
                            <div class="col-md-6">
                                <!-- Creative Commons logo -->
                                <div>
                                    <img src="{concat($theme-path, '/images/creative-commons.png')}"/>
                                    <br/>
                                    <p style="color:#444444" class="text-capitalized">
                                        <i18n:text>xmlui.creative.commons</i18n:text>
                                        <a href="https://creativecommons.org/licenses/by-nc-nd/3.0/" target="_blank">Licensing details</a>
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <!-- Our  Partners here -->
                                <div id="our-partners">
                                    <h3 class="text-uppercase"><i18n:text>xmlui.our.partners</i18n:text></h3>


                                    <a href="http://www.maitritrust.org.uk/" target="_blank"
                                       title="Go to Maitri Trust, UK website">
                                        <img style="width:75px; height:30px; margin:10px;"
                                             src="{concat($theme-path, '/images/maitri-trust.png')}"
                                             alt="Maitri Trust, UK"/>
                                    </a>

                                    <a href="http://www.nepallibrary.org/" target="_blank"
                                       title="Go to Nepal Library Foundation website">
                                        <img style="width:75px; height:30px;margin:10px;"
                                             src="{concat($theme-path, '/images/Nepal-Library-Foundation-logo.png')}"
                                             alt="Nepal Library Foundation"/>
                                    </a>
                                </div>
                            </div>
                        </div><!-- First Box finished -->

                        <!--Vertical divider -->
                        <div class="col-md-6">
                            <!--Content contributors -->
                            <div id="our-content-contributors"
                                 style="border-left: 3px solid #f2f2f2; position:absolute; ">
                                <h3 class="text-uppercase" style="margin-left:20px;"><i18n:text>xmlui.our.content.contributors</i18n:text></h3>
                                <a href="http://www.savethechildren.org/countries/asia/nepal.html"
                                   target="_blank"
                                   title="Save The Children">
                                    <img class="partner-logo"
                                         src="{concat($theme-path, '/images/STC_logo.png')}"
                                         alt="STC Logo"/>
                                </a>
                                <a href="http://www.rbf.org.np/" target="_blank"
                                   title="Rato Bangala Foundation">
                                    <img class="partner-logo" src="{concat($theme-path, '/images/rtf.png')}"
                                         alt="RBF Logo"/>
                                </a>
                                <a href="http://www.gorkhapatra.org.np/" target="_blank" title="Gorakhapatra">
                                    <img class="partner-logo"
                                         src="{concat($theme-path, '/images/gorkhapatra-logo.png')}"
                                         alt="GP Logo"
                                         width="28" height="31"/>
                                </a>
                                <a href="http://www.roomtoread.org/countries/nepal.html" target="_blank"
                                   title="Room To Read">
                                    <img class="partner-logo"
                                         src="{concat($theme-path, '/images/room-to-read-logo.png')}"
                                         alt="RTR Logo"/>
                                </a>

                                <a href="http://madanpuraskar.org/" target="_blank"
                                   title="Madan Puraskar Pustakalaya">
                                    <img class="partner-logo" src="{concat($theme-path, '/images/mpplogo.png')}"
                                         alt="MPP Logo"/>
                                </a>

                                <a href="http://www.nepalacademy.org.np/" target="_blank" title="Nepal Academy">
                                    <img class="partner-logo"
                                         src="{concat($theme-path, '/images/logo_nepal_academy.png')}"
                                         alt="Nepal Academy Logo"/>
                                </a>

                                <a href="http://www.neschil.org/" target="_blank" title="NESCHIL">
                                    <img class="partner-logo" src="{concat($theme-path, '/images/neschil.png')}"
                                         alt="NESCHIL Logo"/>
                                </a>

                                <a href="http://www.worlded.org/WEIInternet/contact/index.cfm" target="_blank"
                                   title="World Education Nepal">
                                    <img class="partner-logo" src="{concat($theme-path, '/images/partnerWEI.png')}"
                                         alt="World Education Nepal Logo"/>
                                </a>

                                <a href="http://www.britishcouncil.org/nepal" target="_blank"
                                   title="British Council">
                                    <img style="margin:20px; width:100px; height:33px;"
                                         src="{concat($theme-path, '/images/logo-british-council-color.png')}"
                                         alt="British Council Logo"/>
                                </a>

                                <a href="http://e-learningforkids.org/" target="_blank" title="E-Learning for Kids">
                                    <img style="margin:20px; width:100px; height:33px;"
                                         src="{concat($theme-path, '/images/e-learning-for-kids.png')}"
                                         alt="EL Kids Logo"/>
                                </a>

                                <a href="http://practicalaction.org/nepal" target="_blank" title="Practical Action">
                                    <img style="margin:20px; width:100px; height:33px;"
                                         src="{concat($theme-path, '/images/practical-action-logo-highres-300dpi.png')}"
                                         alt="PA Logo"/>
                                </a>

                                <a href="http://www.digitalhimalaya.com/" target="_blank" title="Digital Himalaya">
                                    <img style="margin:20px; width:50px; height:30px;"
                                         src="{concat($theme-path, '/images/DH_logo_small.gif')}"
                                         alt="DH Logo"
                                         height="31"/>
                                </a>
                            </div>
                        </div>
                    </div><!-- end row -->
                </div><!-- end container -->
            </div><!-- end footer banner second -->

            <!--div class="hidden-print">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/contact</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                </a>
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/feedback</xsl:text>
                    </xsl:attribute>
                    <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                </a>
            </div-->
           <!-- <div class="row">
                <hr/>
                <div class="col-xs-7 col-sm-8">
                    <div>
                        <a href="http://www.dspace.org/" target="_blank">DSpace software</a> copyright&#160;&#169;&#160;2002-2015&#160; <a href="http://www.duraspace.org/" target="_blank">DuraSpace</a>
                    </div>
                    <div class="hidden-print">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                <xsl:text>/contact</xsl:text>
                            </xsl:attribute>
                            <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                        </a>
                        <xsl:text> | </xsl:text>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                <xsl:text>/feedback</xsl:text>
                            </xsl:attribute>
                            <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                        </a>
                    </div>
                </div>
                <div class="col-xs-5 col-sm-4 hidden-print">
                    <div class="pull-right">
                        <span class="theme-by">Theme by&#160;</span>
                        <br/>
                        <a title="@mire NV" target="_blank" href="http://atmire.com">
                            <img alt="@mire NV" src="{concat($theme-path, '/images/@mirelogo-small.png')}"/>
                        </a>
                    </div>

                </div>
            </div>-->
            <!--Invisible link to HTML sitemap (for search engines) -->
            <a class="hidden">
                <xsl:attribute name="href">
                    <xsl:value-of
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/htmlmap</xsl:text>
                </xsl:attribute>
                <xsl:text>&#160;</xsl:text>
            </a>
            <p>&#160;</p>
        </footer>
    </xsl:template>


    <!--
            The meta, body, options elements; the three top-level elements in the schema
    -->






    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
        <div>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div class="alert">
                    <button type="button" class="close" data-dismiss="alert">&#215;</button>
                    <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
                <xsl:when test="starts-with($request-uri, 'page/about')">
                    <div class="hero-unit">
                        <h1><i18n:text>xmlui.mirage2.page-structure.heroUnit.title</i18n:text></h1>
                        <p><i18n:text>xmlui.mirage2.page-structure.heroUnit.content</i18n:text></p>
                    </div>
                </xsl:when>
                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </div>
    </xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
    -->

    <xsl:template name="addJavascript">
        <!-- Pustakalaya custom scripts -->

        <!-- Hide banner if this is not the homepage -->
        <script type="text/javascript">
            var pathname1 = "/";
            var pathname2 = "/xmlui/";
            var banner = document.getElementById("pustakalayaBanner");
            var currentPath = window.location.pathname;
            if(currentPath == pathname1 || currentPath == pathname2){
            banner.hidden = false;
            } else {
            banner.hidden = true;
            }

        </script>
        <!-- Hide sidebar if this is not the sidebar -->
        <script type="text/javascript">
            var pathname1 = "/";
            var pathname2 = "/xmlui/";
            var sideBar = document.getElementById("pustakalayaBanner");
            var currentPath = window.location.pathname;
            if(currentPath == pathname1 || currentPath == pathname2){
            banner.hidden = false;
            } else {
            banner.hidden = true;
            }
        </script>

        <!--hide the navigation menu if the homepage is detected-->
        <script type="text/javascript">
            var pathname1="/";
            var pathname2="/xmlui/";
            var navigationBar= document.getElementById("main-container");
            var currentPath=window.location.pathname;
            if(currentPath == pathname1 || currentPath == pathname2){
            navigationBar.hidden = true;
            }else {
            navigationBar.hidden = false;
            }
        </script>


        <!--hide carousel sliders except home page-->
        <script type="text/javascript">
            var pathname1="/";
            var pathname2="/xmlui/";
            var slider= document.getElementById("pustakalaya-slider");
            var currentPath=window.location.pathname;
            if(currentPath == pathname1 || currentPath == pathname2){
            slider.hidden = false;
            }else {
            slider.hidden = true;
            }
        </script>


        <script type="text/javascript"><xsl:text>
                         if(typeof window.publication === 'undefined'){
                            window.publication={};
                          };
                        window.publication.contextPath= '</xsl:text><xsl:value-of
                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/><xsl:text>';</xsl:text>
            <xsl:text>window.publication.themePath= '</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>

        <!--TODO concat & minify!-->

        <script>
            <xsl:text>if(!window.DSpace){window.DSpace={};}window.DSpace.context_path='</xsl:text><xsl:value-of select="$context-path"/><xsl:text>';window.DSpace.theme_path='</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>

        <!--inject scripts.html containing all the theme specific javascript references
        that can be minified and concatinated in to a single file or separate and untouched
        depending on whether or not the developer maven profile was active-->
        <xsl:variable name="scriptURL">
            <xsl:text>cocoon://themes/</xsl:text>
            <!--we can't use $theme-path, because that contains the context path,
            and cocoon:// urls don't need the context path-->
            <xsl:value-of select="$pagemeta/dri:metadata[@element='theme'][@qualifier='path']"/>
            <xsl:text>scripts-dist.xml</xsl:text>
        </xsl:variable>
        <xsl:for-each select="document($scriptURL)/scripts/script">
            <script src="{$theme-path}{@src}">&#160;</script>
        </xsl:for-each>

        <!-- Add javascipt specified in DRI -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script>
                <xsl:attribute name="src">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root-->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of select="$theme-path"/>
                            <xsl:text>js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
            <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script><xsl:text>
                  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

                  ga('create', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/><xsl:text>');
                  ga('send', 'pageview');
           </xsl:text></script>
        </xsl:if>
    </xsl:template>

    <!--The Language Selection-->
    <xsl:template name="languageSelection">
        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="hidden-xs">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$active-locale]"/>
                        <xsl:text>&#160;</xsl:text>
                        <b class="caret"/>
                    </span>
                </a>
                <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
                    <xsl:for-each
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <xsl:if test="$locale = $active-locale">
                                <xsl:attribute name="class">
                                    <xsl:text>disabled</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$current-uri"/>
                                    <xsl:text>?locale-attribute=</xsl:text>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
