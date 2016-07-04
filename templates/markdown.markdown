$if(titleblock)$
$titleblock$
$endif$

$for(header-includes)$
$header-includes$
$endfor$

$for(include-before)$
$include-before$
$endfor$

$if(title)$
$title$
===
$endif$

$if(toc)$

[Skip to content >](#content-anchor)

Table of Contents
-----------------
$toc$

<h2 id="content-anchor">&nbsp;</h2>
$endif$

$body$
$for(include-after)$

$include-after$
$endfor$
