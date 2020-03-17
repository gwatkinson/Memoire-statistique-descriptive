/* Gabriel WATKINSON et Mohamed GUENNOUNI HASSANI */
/* Sujet : Situation familiale et éducation */

/*~~~~~~~~ Création de la table de travail ~~~~~~~~*/

/*A partir du fichier .sav, on exporte la table ESS dans la work */
PROC IMPORT OUT= WORK.ess 
DATAFILE= "W:\Bureau\Memoire SAS\ESS6e02_4.sav" 
DBMS=SPSS REPLACE;
RUN;

/* On crée une nouvelle base ess2 dans la libraire work */
DATA ess2;
SET ess ( WHERE = ( cntry = "FR"));
pond = pspwght * pweight * 10000; 
/* On crée la variable pond qui nous sera utile par la suite 
pour notre pondération */
LABEL pond ="Ponderation";	
KEEP chldhhe chldhm  hhmmb marsts edlvdfr edlvfdfr edlvmdfr   
edlvpdfr pspwght dweight pweight pond lvgptnea agea idno;
/* On garde toutes les variables utiles pour notre étude */
RUN;


/* On sauvegarde notre table dans une librairie permanente */

LIBNAME memoire "W:\Bureau\Memoire SAS";
DATA memoire.ess2;
SET ess2;
RUN;


/*~~~~~~~~ Recodage des variables ~~~~~~~~*/


/*On créer la variable edperso pour le niveau d'éducation personnelle 
pour regrouper les 26 modalités de edlvdfr en 5 modalités : 
Brevet, Bac, Licence, Master, Doctorat */

DATA ess2;
SET ess2;
LENGTH edperso $ 20;
IF edlvdfr<=5 THEN edperso="    Brevet";
ELSE IF edlvdfr <=11 THEN edperso="   BAC";
ELSE IF edlvdfr <=18 THEN edperso="  Licence";
ELSE IF edlvdfr <=24 THEN edperso=" Master";
ELSE IF edlvdfr <=26 THEN edperso="Doctorat";
RUN;

/*On créer la variable edpere pour le niveau d'éducation du père
pour regrouper les 26 modalités de edlvdfr en 5 modalités : 
Brevet, Bac, Licence, Master, Doctorat */

DATA ess2;
SET ess2;
LENGTH edpere $ 20;
IF edlvfdfr<=5 THEN edpere="    Brevet";
ELSE IF edlvfdfr <=11 THEN edpere="   BAC";
ELSE IF edlvfdfr <=18 THEN edpere="  Licence";
ELSE IF edlvfdfr <=24 THEN edpere=" Master";
ELSE IF edlvfdfr <=26 THEN edpere="Doctorat";
RUN;

/*On créer la variable edmere pour le niveau d'éducation personnelle
pour regrouper les 26 modalités de edlvdfr en 5 modalités : 
Brevet, Bac, Licence, Master, Doctorat */

DATA ess2;
SET ess2;
LENGTH edmere $ 20;
IF edlvdmfr<=5 THEN edmere="    Brevet";
ELSE IF edlvmdfr <=11 THEN edmere="   BAC";
ELSE IF edlvmdfr <=18 THEN edmere="  Licence";
ELSE IF edlvmdfr <=24 THEN edmere=" Master";
ELSE IF edlvmdfr <=26 THEN edmere="Doctorat";
RUN;

/*On créer la variable edpartenaire pour le niveau d'éducation 
personnelle pour regrouper les 26 modalités de edlvdfr en 
5 modalités : Brevet, Bac, Licence, Master, Doctorat */

DATA ess2;
SET ess2;
LENGTH edpartenaire $20;
IF edlvdpfr<=5 THEN edpartenaire="     Brevet";
ELSE IF edlvpdfr <=11 THEN edpartenaire="    BAC";
ELSE IF edlvpdfr <=18 THEN edpartenaire="   Licence";
ELSE IF edlvpdfr <=24 THEN edpartenaire="  Master";
ELSE IF edlvpdfr <=26 THEN edpartenaire=" Doctorat";
RUN;

/*On créer la variable marital pour la situation maritale de 
la personne. On regroupe les modalités de marsts pour avoir 
deux modalités : légalement célibataire ou non */

DATA ess2;
SET ess2;
IF marsts in (1,2,3,4,5) THEN marital="Non Célibataire";
ELSE If marsts=6 THEN marital="Célibataire";
RUN;

/*On créer la variable veccouple pour savoir si la personne a déjà 
vécu en couple sans être marié. On regroupe les modalités de lvgptnea 
pour avoir deux modalités : 
A déjà vécu en couple sans être marié ou non*/

DATA ess2;
SET ess2;
LENGTH veccouple $80;
IF lvgptnea=1 THEN avacouple="Déjà vécu en couple sans être marié";
ELSE IF lvgptnea=2 THEN avacouple="Jamais vécu en couple sans être marié";
RUN;

/*On créer la variable enfant pour savoir si la personne a déjà eu un 
enfant dans le ménage. On regroupe les modalités de chldhhe pour avoir 
deux modalités : A déjà eu un enfant ou non*/

DATA ess2;
SET ess2;
LENGTH enfant $ 60;
IF chldhhe=1 THEN enfant="A déjà eu un enfant dans le ménage";
ELSE If chldhhe=2 THEN enfant="Jamais eu d'enfant dans le ménage";
RUN;

/*On créer la variable foyer pour savoir le nombre de personnes 
vivant dans le foyer. On regroupe les modalités de hhmmb pour avoir 
5 modalités : 1, 2, 3, 4, 5 ou plus*/

DATA ess2;
SET ess2;
LENGTH foyer $ 15;
IF hhmmb=1 THEN foyer = "1";
ELSE IF hhmmb=2 THEN foyer = "2";
ELSE IF hhmmb=3 THEN foyer = "3";
ELSE IF hhmmb=4 THEN foyer = "4";
ELSE IF hhmmb>=5 THEN foyer = "5 ou plus";
RUN;

/* On crée le format age pour regrouper l'âge des personnes sondées 
de plus de 20 ans en tranche de 10 années */

PROC FORMAT;
VALUE age
20<-30 = "De 20 a 30 ans"
30<-40 = "De 30 a 40 ans"
40<-50 = "De 40 a 50 ans"
50<-60 = "De 50 a 60 ans"
60<-70 = "De 60 a 70 ans"
70<-80 = "De 70 a 80 ans"
80<-high = "Plus de 80 ans";
RUN;


/*~~~~~~~~ Éducation et situation familiale  ~~~~~~~~*/


/* On trace le graphique qui représente la situation maritale 
en fonction du niveau d'études atteint pour les plus de 26 ans */

PROC GCHART DATA = ess2 (WHERE = (marital ne "" AND agea >=26)); 
/* On ne s'intéresse qu'aux individus de plus de 26 ans */
TITLE "Situation maritale en fonction de l’éducation pour 
les individus de plus de 26 ans";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=AXIS1 MAXIS=AXIS2 
/* On pondère par pond pour avoir un graphique représentatif de la 
population française */
DISCRETE GROUP = edperso
SUBGROUP = marital
G100 NOZERO TYPE=PERCENT 
INSIDE=SUBPCT;
RUN;

/* On réalise le test de chi-2 entre la situation maritale et 
le niveau d'études */
PROC FREQ DATA =ess2 
(WHERE = (marital NE "" AND edperso NE "" AND agea >=26));
TITLE "Mesure de l’association entre le niveau d’études et 
le statut marital pour lesindividus de plus de 26 ans";
TABLES edperso*marital / CHISQ;
WEIGHT pspwght; 
/* On veille à utiliser pspwght pour vérifier si l'échantillon peut 
permettre de rejeter l'hypothèse d'indépendance */
RUN;


/* On réalise l'histogramme qui représente la distribution de docteurs 
par rapport à des tranches d'âge de 10 années */

PROC UNIVARIATE DATA = ess2 (WHERE= (edperso="Doctorat")) VARDEF=WGT;
TITLE "Distribution des doctorants par tranche de 10 années";
VAR agea;
HISTOGRAM/MIDPOINTS = 20 TO 90  BY 10;
FREQ pond;
LABEL agea = "Âge par tranche de 10 années";
RUN;

/* On trace le graphique qui représente si la personne a déjà vécu en 
couple en fonction du niveau d'études atteint pour les plus de 26 ans */

PROC GCHART DATA = ess2 (WHERE = (avacouple NE "" AND agea >=26)); 
/* On ne s'intéresse qu'aux individus de plus de 26 ans */
TITLE " Pourcentage de personne ayant déjà vécu en couple 
sans être marié ou nonen fonction de l’éducation pour les 
individus de plus de 26 ans";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=axis1 MAXIS=axis2 
/*On pondère par pond pour avoir un graphique représentatif 
de la population française*/
DISCRETE  GROUP = edperso
SUBGROUP = avacouple
G100 NOZERO TYPE=PERCENT      
INSIDE=SUBPCT;
RUN;

/* On réalise le test de chi-2 entre le fait que la personne a déjà 
vécu en couple et le niveau d'études */

PROC FREQ DATA =ess2 
(WHERE = (avacouple NE "" AND edperso NE "" AND agea >=26));
TITLE " Mesure de l’association entre le niveau d’études et 
le fait d’avoir déjà vécuen couple sans être marié ou non 
pour les individus de plus de 26 ans";
TABLES edperso*avacouple /CHISQ ;
WEIGHT pspwght; 
/* On veille à utiliser pspwght pour vérifier si l'échantillon peut 
permettre de rejeter l'hypothèse d'indépendance */
RUN;
RUN;

/* On trace le graphique qui représente la situation maritale en fonction 
du niveau d'études atteint pour les plus de 50 ans */

PROC GCHART DATA = ess2 (WHERE = (marital ne "" AND agea >=50)); 
/* On ne s'intéresse qu'aux individus de plus de 50 ans */
TITLE " Situation maritale en fonction de l’éducation pour 
les individus de plus de 50 ans";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=AXIS1 MAXIS=AXIS2  
/* On pondère par pond pour avoir un graphique représentatif 
de la population française */
DISCRETE GROUP = edperso
SUBGROUP = marital
G100 NOZERO TYPE=PERCENT 
INSIDE=SUBPCT;
RUN;

/*On réalise le test de chi-2 entre le fait que la personne 
a déjà vécu en couple et le niveau d'études*/

PROC FREQ DATA =ess2 
(WHERE = (avacouple NE "" AND edperso NE "" AND agea >=50));
TITLE "Mesure de l’association entre le niveau d’études et 
le fait d’avoir déjà vécuen couple sans être marié ou non 
pour les individus de plus de 50 ans";
TABLES edperso*marital / CHISQ ;
WEIGHT pspwght; 
/* On veille à utiliser pspwght pour vérifier si l'échantillon 
peut permettre de rejeter l'hypothèse d'indépendance */
RUN;



/*~~~ Homogamie et reproduction sociale sous le spectre de l’éducation ~~~*/

/*On réalise le tableau de corrélation de Kendall 
entre edlvdfr, edlvmdfr, edlvfdfr.
Ces variables représentent éducation personelle, 
celle du père et celle de la mère */

PROC CORR DATA = ess2 (WHERE =(edlvdfr <5000 AND edlvdfr NE . 
AND edlvmdfr<5000 AND edlvmdfr NE . AND edlvfdfr <5000 AND edlvfdfr NE .
AND edlvpdfr <5000 AND edlvpdfr NE .)) KENDALL; 
/*On inclue dans les conditions l'éducation du partenaire pour avoir le 
même échantillon et comparer avec le tableau de corrélation ci-après */
TITLE "Coefficients du tau b de Kendall";
VAR edlvdfr edlvmdfr edlvfdfr;
RUN;

/*On réalise le tableau de corrélation de Kendall 
entre edlvdfr, edlvmdfr, edlvfdfr.
Ces variables représentent éducation personelle et celle du partenaire */

PROC CORR DATA = ess2 (WHERE =(edlvdfr <5000 and edlvdfr NE . 
AND edlvmdfr<5000 and edlvmdfr NE . AND edlvfdfr <5000 AND edlvfdfr NE .
AND edlvpdfr <5000 and edlvpdfr NE .)) KENDALL;
TITLE "Coefficients du tau b de Kendall";
VAR edlvdfr edlvpdfr;
RUN;


/*~~~~~~~~ Propension à fonder un foyer  ~~~~~~~~*/

/* On trace le graphique qui représente le fait d'avoir eu un enfant dans 
le ménageen fonction du niveau d'études atteint pour les plus de 26 ans */

PROC GCHART DATA = ess2 (WHERE = (enfant NE "" AND agea >=26)); 
/* On ne s'intéresse qu'aux individus de plus de 26 ans */
TITLE "Pourcentage de personne de plus de 26 ans ayant déjà eu
un enfant dans le ménage selon le niveau d’éducation";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=AXIS1 MAXIS=AXIS2 
/* On pondère par pond pour avoir un graphique représentatif 
de la population française */
DISCRETE GROUP = edperso
SUBGROUP = enfant
G100 NOZERO TYPE=PERCENT   
INSIDE=SUBPCT;
RUN;

/* On réalise le test de chi-2 entre le fait d'avoir eu un enfant 
dans le ménage et le niveau d'études pour les plus de 26 ans */

PROC FREQ DATA =ess2 
(WHERE = (enfant NE "" AND edperso NE "" AND agea >=26));
TABLES edperso*enfant /CHISQ ;
WEIGHT pspwght; 
TITLE "Mesure de l’association entre le niveau d’études et 
le fait d’avoir eu un enfantdans le ménage ou non pour les 
individus de plus de 26 ans";
/* On veille à utiliser pspwght pour vérifier si l'échantillon 
peut permettre de rejeter l'hypothèse d'indépendance */
RUN;

/* On trace le graphique qui représente le fait d'avoir eu un enfant dans 
le ménage en fonction du niveau d'études atteint pour les plus de 50 ans*/

PROC GCHART DATA = ess2 (WHERE = (enfant NE "" AND agea >=50)); 
/* On ne s'intéresse qu'aux individus de plus de 50 ans */
TITLE "Pourcentage de personne de plus de 50 ans ayant déjà 
eu un enfant dans leménage selon le niveau d’éducation";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=AXIS1 MAXIS=AXIS2  
/* On pondère par pond pour avoir un graphique représentatif 
de la population française */
DISCRETE GROUP = edperso
SUBGROUP = enfant
G100 NOZERO TYPE=PERCENT
INSIDE=SUBPCT;
RUN;

/* On réalise le test de chi-2 entre le fait d'avoir eu un enfant 
dans le ménage et le niveau d'études pour les plus de 50 ans */

PROC FREQ DATA =ess2 
(WHERE = (enfant NE "" AND edperso NE "" AND agea >=50));
TABLES edperso*enfant /CHISQ ; 
/* On veille à utiliser pspwght pour vérifier si l'échantillon 
peut permettre de rejeter l'hypothèse d'indépendance */
WEIGHT pspwght;
RUN;

/* On trace le graphique qui représente le nombre de personnes 
dans le foyer en fonction du niveau d'études atteint pour 
les personnes entre 36 et 52 ans */

PROC GCHART DATA = ess2 
(WHERE = (foyer NE "" AND edperso ne "" AND agea>=36 and agea<=52)); 
/* On ne s'intéresse qu'aux individus entre 36 et 52 ans */
TITLE "Nombre de personnes vivant régulièrement dans le ménage 
selon le niveaud’éducation pour les individus de 36 à 52 ans";
AXIS1 LABEL = ("Pourcentage");
AXIS2 LABEL =("Niveau d'éducation");
VBAR edperso /FREQ = pond RAXIS=AXIS1 MAXIS=AXIS2 
/* On pondère par pond pour avoir un graphique représentatif 
de la population française */
DISCRETE GROUP = edperso
SUBGROUP = foyer 
G100 NOZERO TYPE=PERCENT                         
INSIDE=SUBPCT;
RUN;

/* On réalise le test de chi-2 entre le nombre de personnes dans 
le ménage et le niveau d'études pour les personnes 
entre 36 et 52 ans */

PROC FREQ DATA =ess2 
(WHERE = (foyer NE "" AND edperso NE "" AND agea>=36 AND agea<=52));
TITLE "Mesure de l’asociation entre le niveau d’études et nombre de 
personnes vivant régulièrement dans le ménage pour les individus 
de 36 à 52 ans";
TABLES edperso*foyer /CHISQ;
WEIGHT pspwght;
RUN;
