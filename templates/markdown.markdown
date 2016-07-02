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

Table of Contents
-----------------

$endif$

$if(toc)$
$toc$

$endif$

$body$
$for(include-after)$

$include-after$
$endfor$
