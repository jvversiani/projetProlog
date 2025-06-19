% Faits dynamiques

:-dynamic ingredient/1.
:-dynamic distance/3.


% Faits

% Plat: nom, liste des ingredients, niveau de cuisine necessaire
plat(omelette,[oeuf],1).
plat(pates_carbo, [oeuf, bacon, pates, pecorino],2).
plat(tarte, [pomme],1).
plat(poulet_rôti, [poulet, pommes_de_terre, oignons, ail, thym], 3).
plat(lasagnes, [pâtes, viande_hachée, sauce_tomate, fromage, béchamel], 4).
plat(salade_césar, [laitue, poulet_grillé, croûtons, parmesan, sauce_césar], 2).
plat(soupe_à_loignon, [oignons, bouillon_de_boeuf, pain, fromage, thym], 3).
plat(ratatouille, [aubergine, courgette, poivron, tomate, oignon], 2).
plat(coq_au_vin, [poulet, vin_rouge, champignons, oignons, lardons], 4).
plat(bœuf_bourguignon, [bœuf, vin_rouge, carottes, oignons, champignons], 5).
plat(cassoulet, [haricots_blancs, saucisses, confit_de_canard, lardons, tomate], 4).
plat(bouillabaisse, [poisson, moules, crevettes, tomate], 5).
plat(quiche_lorraine, [pâte_brisee, lardons, crème_fraîche, œufs, fromage], 3).
plat(salade_niçoise, [thon, haricots_verts, tomates, œufs, olives], 2).
plat(soupe_à_la_tomate, [tomates, oignon, ail, basilic, bouillon_de_légumes], 2).
plat(poisson_en_papillote, [poisson, légumes_vapeur, citron, herbes_de_provence], 3).
plat(bœuf_stroganoff, [bœuf, champignons, oignon, crème_fraîche, moutarde], 4).
plat(pâtes_à_la_bolognaise, [pâtes, viande_hachée, sauce_tomate, oignon, ail], 3).
plat(salade_de_chèvre_chaud, [salade, fromage_de_chèvre, noix, miel, vinaigre_balsamique], 2).
plat(tarte_aux_pommes, [pâte_brisee, pommes, sucre, cannelle, beurre], 2).
plat(soufflé_au_fromage, [œufs, fromage, lait, beurre, farine], 4).
plat(steak_frites, [bœuf, pommes_de_terre_frites, salade, sauce], 2).
plat(crêpes_suzette, [crêpes, beurre, sucre], 3).
plat(escalope_milanaise, [escalope_de_poulet, chapelure, œuf, citron, salade], 3).
plat(boulettes_de_viande, [viande_hachée, oignon, chapelure, œuf, sauce_tomate], 2).
plat(gratin_dauphinois, [pommes_de_terre, crème_fraîche, fromage, ail, muscade], 3).
plat(tartiflette, [pommes_de_terre, lardons, reblochon, oignon, crème_fraîche], 4).
plat(coquilles_saint-jacques, [coquilles_saint-jacques, vin_blanc, crème_fraîche, échalote, persil], 4).

% Etablissement: nom, cuisine
etablissement("Aux fleuves d'Hanoï", asiat).
etablissement("Patita Negra", espagnol).
etablissement("Jhon's burguer", burger).
etablissement("Brazilian Steakhouse", viande).


% Commander: plat, prix, cuisine
% On aurait pu concatener les faits 'plat' et 'commander' mais on a
% decidé de les separer afin d'ammeliorer la compreension du code

commander(sushis, 20, asiat).
commander(pokeBowl,15, asiat).
commander(tacos,7, burger).
commander(cheeseburger,13, burger).
commander(burger,12, burger).
commander(patatas,6, espagnol).
commander(chorizo_et_patatas, 11, espagnol).
commander(paella,13,espagnol).
commander(empanada,4,espagnol).
commander(entrecote_frite, 18, viande).
commander(steak_frite, 10, viande).

% Listes de reponses possibles

list_plat(L1, NC):- findall(X, (plat(X, L, N), find_plat_with_ingredients(L), N =< NC), L1).
list_ingredient(L1):- findall(X, ingredient(X), L1).

list_cuisines(L1):- findall(Cuisine, etablissement(_, Cuisine),L1).
list_commandes(L1, Prix, Cuisine, Nom, D):- findall(Plat, (commander(Plat, Pr, Cuisine), etablissement(Nom, Cuisine), distance(_, Nom, D) , Pr =< Prix), L1), etablissement(Nom, Cuisine), distance(_, Nom, D).
list_etablissements(LE):- findall(Nom, (etablissement(Nom, _)), LE).

% Utils

check_awnser_list(X, L, PrintPourquoi):- (read(X), (member(X, L); (X = pourquoi, PrintPourquoi, fail)), !); writef("Veuillez choisir une des options suivantes: %t", [L]), nl, check_awnser_list(X, L, PrintPourquoi).

check_awnser_integer(X, PrintPourquoi):- (read(X), ((integer(X), X > 0); (X = pourquoi, PrintPourquoi, fail)), !); write("Veuillez rentrer un chiffre positif."), nl, check_awnser_integer(X, PrintPourquoi).

input_ingredients(PrintPourquoi):- read(Ingredient),(Ingredient = pourquoi, PrintPourquoi,input_ingredients(PrintPourquoi);(Ingredient = stop, !); (asserta(ingredient(Ingredient)),write("C'est noté, vous pouvez continuer \n"), input_ingredients(PrintPourquoi))).

check_awnser_between(X, Min, Max, PrintPourquoi):- (read(X), ((integer(X), between(Min, Max, X)); (X = pourquoi, PrintPourquoi, fail)), !); writef("Veuillez saisir un entier entre %t et %t:", [Min, Max]), nl, check_awnser_between(X, Min, Max,PrintPourquoi).

find_plat_with_ingredients(L):- maplist(ingredient,L).

input_distances([], _).
input_distances([R|L], A):- random(1, 15, D), assert(distance(A, R, D)), input_distances(L, A).

generate_distances():- read(Adresse), ((string(Adresse), list_etablissements(LE), input_distances(LE, Adresse)); (Adresse = pourquoi, pourquoi_adresse(), fail); (write("Veuillez rentrer un adresse valide"), nl, generate_distances())).

% Dialogues avec choix

print_ou_manger(Local):- LLocal = [arreter, cuisiner, commander],check_awnser_list(Local, LLocal, pourquoi_contexte).

print_cuisine:- write("Parfait! Je vais vous aider à trouver un menu à cuisiner selon les ingrédients que vous avez à disposition. Veuillez alors indiquer vos ingredients svp, lorsque vous avez terminez inscrivez stop :"), nl, input_ingredients(pourquoi_ingredient).

print_NC(NC):- write("Quel est ton niveau de cuisine entre 1 et 5:"), nl, check_awnser_between(NC, 1, 5, pourquoi_NC).

print_types_cuisine(Cuisine) :- list_cuisines(LC), writef("Parfait! Je vais vous trouver un établissement exceptionnel, adapté à vos besoins. Veuillez maintenant sélectionner un type de cusine parmi les options suivantes : %t :",[LC]), nl, check_awnser_list(Cuisine, LC, pourquoi_cuisine).

print_prix(P):- write("Quel prix maximal voulez vous mettre dans votre commande ?"), nl, check_awnser_integer(P, pourquoi_prix).


% Dialogues sans choix

raconter_contexte():- write("Dans la douceur de la soirée, deux âmes amoureuses se retrouvent, enveloppées par la chaleur de leur affection. Alors que le temps s'écoule paisiblement, le doux murmure de la faim se fait entendre, suscitant une question attendrissante : 'Que veux-tu manger, mon amour ?' Cependant, dans un doux dilemme de choix, la réponse se perd dans les dédales de l'incertitude. Heureusement, une aide bienveillante se profile à l'horizon : un programme Prolog, prêt à dénouer les méandres de cette indécision délicieuse.\n

Bonjour à vous, amoureux égarés dans le royaume des saveurs ! Je suis PP, votre guide bienveillant dans le monde des choix gastronomiques. Ensemble, nous trouverons la voie qui mènera à la satisfaction de vos papilles affamées.\n
Pour commencer, laissez-moi vous poser une question cruciale : préférez-vous cuisiner un festin appétissant dans le confort de votre foyer ou commander une délicieuse livraison directement à votre porte ? A tout moment, si vous souhaitez interroger la finalité de mes questions, vous pouvez me retourner 'pourquoi' et je vous expliquerai. Merci d'indiquez dans un premier temps si vous voulez cuisiner ou commander. \n").

arreter():- write("Desolé de ne pas avoir été utile ce soir. à la prochaine!").

pourquoi_resto():- write("J'ai besoin de savoir le type de restaurant où vous souhaitez y aller afin de filtrer mes recommandations. Le restaurant selectionné change la quantité de services, la complexité des plats et biensûr, le prix. ").

pourquoi_contexte():- write("J'ai besoin de savoir ce que vous souhaitez faire afin de filtrer mes recommandations. En effet je vais vous poser des questions spécifiques selon votre choix ").

pourquoi_argent():- write("J'ai besoin de connaître votre contrainte budgetaire afin de vous recommander uniquement ce que vous êtes à mesure de payer. ").

pourquoi_ingredient():- write("J'ai besoin de savoir vos ingredients. En effet je vais integrer à ma base de donnée tous vos ingrédients pour pouvoir trier quels sont les plats qui disposent uniquement de vos ingredients. \nc").

pourquoi_NC():-write("J'ai besoin de savoir ton niveau de cuisine pour pas que tu rates ton plat ;), En effet, je te proposerai un plat avec un niveau de cuisine égal ou inférieur au tien. ").

pourquoi_distance():- write("J'ai besoin de savoir la distance maximale du restaurant afin de vous poroposer seulement ceux qui vous peuvent vous vconvenir. ").

pourquoi_prix():-write("J'ai besoin de savoir quel est le prix que maximal que vous voulez mettre dans votre commande. En effet je vous proposerai seulement des commandes avec un prix inférieur ou égal au votre. ").

pourquoi_cuisine():- write("J'ai besoin de savoir votre préférence en terme de type de cuisine afin de filtrer mes recommandations. En effet je vous proposerai uniquement des commandes de ce type dde cuisine. ").

pourquoi_adresse():- write("J'ai besoin de connaitre votre adresse afin de calculer les distances entre chez vous et les restaurants présents dan notre système. ").


% Programme principal

programme():- raconter_contexte(), ou_manger().

ou_manger:- print_ou_manger(Local),
    ((Local = commander, commander());
    (Local = cuisiner, cuisiner());
    (Local = arreter, arreter())).


% Branche commander :
commander:- print_prix(Prix), write("Ok chef, maintenant j'ai besoin de votre adresse. Veuillez la saisir entièrement entre guillemets): "), nl, generate_distances(), print_types_cuisine(Cuisine), list_commandes(LPlats,Prix, Cuisine, Nom, Dist), Temps is Dist * 4, ((LPlats = [], aucune_commande()); writef("Basée sur les informations que vous m'avez transmis, vous disposez de %t euros et vous préferez manger une cuisine de type %t.
Selon ces informations les plats que vous pouvez possiblement commander sont les plats suivants: %t chez %t. Temps d'attente: environ %t minutes vu que le restaurant est à %t km de chez vous. ",[Prix, Cuisine, LPlats, Nom, Temps, Dist])), retractall(distance(_, _, _)).

aucune_commande:- write("Désolé, je ne trouve aucune commande qui correspond à vos attentes. A la place voulez vous peut-être reesayer une autre commande, cuisiner quelque chose ou arreter? \n"), ou_manger().


% Branche cuisinner
cuisiner:- print_NC(NC), print_cuisine, list_plat(Nom, NC), list_ingredient(L1), ((Nom \= [], writef("Selon votre niveau de cuisine de %t et le.s ingrédient.s que vous possedez %t. Les plats que vous pouvez possiblement cuisiner sont les suivants: %t",[NC, L1, Nom])) ; aucun_plat()), retractall(ingredient(_)).


aucun_plat:- write("Désolé, je n'ai aucun plat à vous proposer avec les ingrédients et le niveau de cuisine que vous possédez actuellement. A la place voulez vous peut-être réessayer de cuisiner avec des nouveaux ingredients, commander ou arreter? \n"), ou_manger().







