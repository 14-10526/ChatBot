% Modulo que tiene la base del conocimiento y logica del programa ANIBOT

:- dynamic(counter/1).
anime(X) :- member(X,["Dragon Ball", "Naruto", "Bleach", "HunterXHunter", "Hamtaro", "Full Metal Alchemist"]).

genero(X) :- member(X,["Aventura", "Shoujo", "Shounen", "Kodomo", "Seinen", "Josei", "Ficcion",
                    "Fantasia", "Mecha", "Sobrenatural", "Magia", "Gore"]).


:- dynamic generoAnime/2.
generoAnime("Naruto",["Shounen","Aventura"]).
generoAnime("Dragon Ball",["Shounen"]).
generoAnime("Bleach",["Shounen", "Sobrenatural"]).
generoAnime("HunterXHunter",["Seinen", "Aventura"]).
generoAnime("Hamtaro",["Kodomo"]).
generoAnime("Full Metal Alchemist",["Shounen", "Magia"]).
generoAnime("Hagane no renkinjutsushi",["Accion", "Aventura"]).
generoAnime("Clannad: After Story",["Comedia","Drama"]).
generoAnime("Monster",["Crimen","Drama"]).
generoAnime("Shingeki no kyojin",["Accion","Aventura"]).
generoAnime("Kiseijû: Sei no kakuritsu",["Accion","Horror"]).
generoAnime("Fate/Zero",["Accion","Fantasia"]).
generoAnime("Toradora!",["Comedia","Drama"]).
generoAnime("Death Note: Desu nôto",["Crimen","Drama"]).
generoAnime("Nana",["Comedia","Drama"]).
generoAnime("Psycho-Pass",["Accion","Crimen"]).

:- dynamic rating/2.
rating("Dragon Ball",3).
rating("Naruto",1).
rating("Bleach",4).
rating("HunterXHunter",5).
rating("Hamtaro",2).
rating("Full Metal Alchemist",4).
rating("Hagane no renkinjutsushi",5).
rating("Clannad: After Story",5).
rating("Monster",4).
rating("Shingeki no kyojin",5).
rating("Kiseijû: Sei no kakuritsu",2).
rating("Fate/Zero",3).
rating("Toradora!",1).
rating("Death Note: Desu nôto",5).
rating("Nana",2).
rating("Psycho-Pass",4).


:- dynamic popularidad/2.
popularidad("Dragon Ball",7).
popularidad("Naruto",5).
popularidad("Bleach",8).
popularidad("HunterXHunter",3).
popularidad("Hamtaro",10).
popularidad("Full Metal Alchemist",1).
popularidad("Hagane no renkinjutsushi",3).
popularidad("Clannad: After Story",5).
popularidad("Monster",6).
popularidad("Shingeki no kyojin",8).
popularidad("Kiseijû: Sei no kakuritsu",4).
popularidad("Fate/Zero",2).
popularidad("Toradora!",1).
popularidad("Death Note: Desu nôto",10).
popularidad("Nana",3).
popularidad("Psycho-Pass",7).


:- dynamic preguntado/2.
preguntado("Dragon Ball",0).
preguntado("Naruto",0).
preguntado("Bleach",0).
preguntado("HunterXHunter",0).
preguntado("Hamtaro",0).
preguntado("Full Metal Alchemist",0).
preguntado("Hagane no renkinjutsushi",0).
preguntado("Clannad: After Story",0).
preguntado("Monster",0).
preguntado("Shingeki no kyojin",0).
preguntado("Kiseijû: Sei no kakuritsu",0).
preguntado("Fate/Zero",0).
preguntado("Toradora!",0).
preguntado("Death Note: Desu nôto",0).
preguntado("Nana",0).
preguntado("Psycho-Pass",0).



/***********************************************************************************/

%! in
% Regla que permite al usuario escribir en la linea de comandos y luego la lee
%   @param None

in:-
    nl,
    write('>'),nl,
    readLine(Text).

%! readLine(Text)
%  Regla que lee lo escrito por el usuario en el comando y elimina mayusculas
%   @param Text Texto escrito por el usuario

readLine(Text):-
    readln(Text,_,_,_,lowercase),
    findRespuesta(Text).

%! readGenero(Text)
%  Lee los generos ingresados por el usuario de un nuevo anime
%   @param Genero de un nuevo anime 

readGenero(Text):-
    readln(Text,_,_,_,lowercase).
readGenero(_):-
    write('Escribe al menos un genero por favor :( .'),in.

%! readRating(Text)
%  Lee el rating de un nuevo anime ingresado por el usuario
%   @param Text Rating del nuevo anime

readRating(Text):-
    readln(Text,_,_,_,lowercase).
            
/***********************************************************************/


%! buscarPalabra(X,Y,Z)
%  Regla que ubica una palabra en la frase que ingresa el usuario
%   @param          Palabra La palabra a buscar
%   @param Lista1   Lista en donde se busca la palabra
%   @param lista2   Lista que queda luego de encontrar la palabra

buscarPalabra(X,[X|T],T).
buscarPalabra(X,[Y|T],L):- 
    buscarPalabra(X,T,L).



%! convert(Atomo,String)
%  Regla que convierte la palabra que se ingrese a mayuscula la primera letra
%  para que pueda hacer matching con los facts
%   @param Atomo    Atomo a convertir
%   @param String   String al que se convierte el atomo

convert(Atomo,String):-
    atom_chars(Atomo,[X|Z]),
    upcase_atom(X,Upper),
    append([Upper],Z,Lista),
    string_chars(String,Lista).


%! buscarGenero(Lista, Genero)
%  Regla que toma lo escrito por el usuario y busca el genero en la frase
%   @param Lista    Frase escrita por el usuario
%   @param Genero   Nombre del genero

buscarGenero([X,W|Z],Genero):-
    convert(X,Y),
    Y=="Genero",    
    convert(W,Genero).
buscarGenero([X|Z],Genero):-
    buscarGenero(Z,Genero).    


%! buscarRating(Lista, Rating)
%  Regla que toma lo escrito por el usuario y busca el numero de rating en la frase
%   @param Lista    Frase escrita por el usuario
%   @param Rating   Numero de rating

buscarRating([X,W|_],X):-
    convert(W,Y),
    (Y=="Estrellas";Y=="Estrella").
buscarRating([X|Z],_):-
    buscarRating(Z,_).     

%! imprimirPopularidad(Anime)
%  Regla que imprime la popularidad de un anime 
%   @param Anime    Anime al que se imprime su popularidad segun una escala definida

imprimirPopularidad(Anime):-
    popularidad(Anime,Popular),
    ((between(1,2,Popular),write(' muy poco conocido'));
    (between(3,5,Popular),write(' poco conocido'));
    (between(6,7,Popular),write(' conocido'));
    (between(8,9,Popular),write(' muy conocido'));
    (between(10,10,Popular),write(' bastante conocido'))).

imprimirGenero([X|Z]):-
    write(X),
    write(', '),
    imprimirGenero(Z).
imprimirGenero([]).    


%! subirConteo(Anime)
%  Reglas que permiten que si se pregunta por un anime mas de 5 veces,
%  se aumente la popularidad del mismo
%   @param Anime    Anime por el que se pregunta
   
subirConteo(Anime):-
    preguntado(Anime,Numero),
    Numero=4,
    retractall(preguntado(Anime,_)),
    assert(preguntado(Anime,0)),
    subirPopularidad(Anime).
subirConteo(Anime):-
    retract(preguntado(Anime,Numero)),
    NuevoN is (Numero+1),  /***/
    assert(preguntado(Anime,NuevoN)).    
    
subirPopularidad(Anime):-
    popularidad(Anime,Numero),
    between(1,9,Numero),
    NuevoN is (Numero+1),
    retract(popularidad(Anime,_)),
    assert(popularidad(Anime,NuevoN)).
subirPopularidad(Anime):-
    popularidad(Anime,Numero),
    between(10,10,Numero).    


%! reportarAnime(Anime)
%  Regla que reporta un anime que ya existe en la base de datos
%  @param Anime    Anime a verificar

reportarAnime(Anime):-
    subirConteo(Anime),
    write('Si lo conozco! '),
    rating(Anime,Rating),
    generoAnime(Anime,Genero),
    write(Anime),write(' tiene '),write(Rating),
    write(' estrella(s)'),write(' es de genero '),imprimirGenero(Genero),write(' y es'),imprimirPopularidad(Anime),
    in. 

%! agregarGenero(Lista1, Lista2, Anime)
%  Regla que agrega la lista de generos de un nuevo anime que el usuario este ingresando
%   @param Lista1   Lista de (atomos) palabras que el usuario ingreso por la linea de comandos
%   @param Lista2   Lista de generos convertidos a String
%   @param Anime    Anime a agregarle la lista de generos

agregarGenero([X|Z],Lista,Anime):-
    convert(X,String),
    (String==",";String=="Y"),
    agregarGenero(Z,Lista,Anime).
agregarGenero([X|Z],Lista,Anime):-
    convert(X,String),
    append(Lista,[String],Listica),
    agregarGenero(Z,Listica,Anime).
agregarGenero([X],Lista,Anime):-
    convert(X,String),
    append(Lista,[String],Listica),
    assert(generoAnime(Anime,Listica)).


%! agregarRating(Lista, Anime)
%  Agrega el predicado que indica el rating del anime nuevo que esta agregando el usuario
%   @param Lista    Lista de palabras ingresadas por el usuario convertidas en atomos 
%   @param Anime    Anime a agregarle el rating

agregarRating([X],Anime):-
    integer(X),
    between(1,5,X),
    assert(rating(Anime,X)).
agregarRating(_,Anime):-
    write('Lo siento,el rating ingresado debe ser un numero entero entre 1 y 5.'),in.


%! agregarPopularidad(Lista, Anime)
%  Agrega el predicado que indica la popularidad del anime nuevo que esta agregando el usuario
%   @param Lista    Lista de palabras ingresadas por el usuario convertidas en atomos 
%   @param Anime    Anime a agregarle la popularidad

agregarPopularidad([X],Anime):-
    integer(X),
    between(1,10,X),
    assert(popularidad(Anime,X)).
agregarPopularidad(_,Anime):-
    assert(popularidad(Anime,1)).



%! agregarNuevoAnime(Anime)
%  Agrega un nuevo anime ingresado por el usuario a la base de datos  
%   @param Anime    Anime a agregar a la base de datos

agregarNuevoAnime(Anime):-
    write('No lo conozco, pero me gustaria saber mas.'),nl,
    write('Cuales son sus generos ?: '),nl,readGenero(Texta),agregarGenero(Texta,[],Anime),nl,
    write('Cual es su rating o numero de estrellas ?: '),nl,readRating(Texto), agregarRating(Texto,Anime),nl,
    write('Del 1 al 10, puedes decir que tan popular es?: '),nl,readRating(Texte),agregarPopularidad(Texte,Anime),
    assert(preguntado(Anime,1)),
    write('Ya lo tengo anotado, muchas gracias!.'),in.

                                    


%! buscarPopularidad(Lista, Popularidad)
%  Matchea las frases ingresadas con el usuario con los animes que correspondan a esa popularidad
%   @param Lista        Lista de palabras ingresadas por el usuario convertidas en atomos
%   @param Popularidad  Indicador del rango de popuaridad

buscarPopularidad(Lista,Popularidad):-
    (buscarPalabra('muy',Lista,RestoLista),buscarPalabra('poco',RestoLista,_),Popularidad=a);
    (buscarPalabra('poco',Lista,RestoLista),Popularidad=b);
    (buscarPalabra('muy',Lista,RestoLista),(buscarPalabra('conocido',RestoLista,_);buscarPalabra('conocidos',RestoLista,_)),Popularidad=d);
    (buscarPalabra('bastante',Lista,RestoLista),Popularidad=e);
    ((buscarPalabra('conocido',Lista,RestoLista);buscarPalabra('conocidos',Lista,RestoLista)),Popularidad=c). 


%! buscarMaximoRating(Maximo)
%  Busca cual es el rating mas alto, actualmente en la base de datos que posee un anime
%   @param Maximo   Maximo rating      

buscarMaximoRating(Maximo):-
    (rating(_,5),Maximo=5);
    (rating(_,4),Maximo=4);
    (rating(_,3),Maximo=3);
    (rating(_,2),Maximo=2);
    (rating(_,1),Maximo=1).


%! imprimirLista(Lista)
%  Imprime cada anime de la lista que recibe con sus atributos
%   @param Lista    Lista de animes a imprimir

imprimirLista([X|Z]):-
    nl,
    popularidad(X,Popularidad),
    rating(X,Rating),
    generoAnime(X,Genero),
    write(X),write(',  Popularidad:'),write(Popularidad),
    write(',  Numero de estrellas:'),write(Rating),write(',  Genero(s):'),write(Genero),
    imprimirLista(Z).
imprimirLista([X|_]).
imprimirLista([]).   

%! imprimirMaximo(Lista,Maximo)
%  Regla que imprime elemento de la lista si su suma es igual al maximo
%   @param Lista    Lista de animes
%   @param Maximo   Numero qu representa el maximo

imprimirMaximo([X|Z],Maximo):-
    %%nl,
    sumaAnime(X,Maximo),
    write(X),write(', Numero de estrellas:'),
    rating(X,Rating),write(Rating),write(', Popularidad:'),
    popularidad(X,Popularidad),write(Popularidad),generoAnime(X,Genero),write(' Genero(s): '),write(Genero),write('\n'),
    imprimirMaximo(Z,Maximo).
imprimirMaximo([X|Z],Maximo):- 
    imprimirMaximo(Z,Maximo).
imprimirMaximo([],Maximo).    


%! hallarMaximo(Lista,ListaAnima)
%  Regla que halla la suma maxima entre rating+popularidad de cada anime
%   @param Lista        Lista del resultado de rating+popularidad de cada anime
%   @param ListaAnime   Lista de los animes 

hallarMaximo(Lista,ListaAnime):-
    max_list(Lista,X),
    delete(Lista,X,Listica),
    imprimirMaximo(ListaAnime,X),
    hallarMaximo(Listica,ListaAnime).
hallarMaximo([],ListaAnime):-
    in.    
    

%! listaSuma(Lista1, Lista2, Lista3, Animes)
%  Crea una lista con todas las sumas de los animes suma = rating + popularidad  
%   @param Lista1   Lista inicial con los animes
%   @param Lista2   Lista vacia donde se suman 
%   @param Lista3   Lista que contendra los resultados de la suma
%   @param Animes   Lista con los animes

listaSuma([X|Z],Lista,_,Animes):-
    sumaAnime(X,Suma),
    append(Lista,[Suma],Listica),
    listaSuma(Z,Listica,_,Animes).
listaSuma([X],Lista,Listica,Animes):-
    sumaAnime(X,Suma),
    append(Lista,[Suma],Listica),
    hallarMaximo(Listica,Animes).

/* ESTAS FUNCIONES AYUDAN A ENCONTRAR EL NOMBRE DE UN ANIME CUANDO SE INGRESA POR EL USUARIO*/

%! getNombre(Lista, Anime)
%  Halla el nombre del anime ingresado por el usuario
%   @param Lista    Lista con todas las palabras que conforman el nombre del anime    
%   @param Anime    Resultado de la concatenacion de las palabras que conforman el nombre del anime

getNombre([X|Z],Anime):-
    convert(X,String),
    string_concat(Anime,String,Listica),
    string_concat(Listica," ",Listica2),
    getNombre(Z,Listica2).
getNombre([X],Anime):-
    convert(X,String),
    string_concat(Anime,String,Listica),
    string(Listica),

    ((generoAnime(Listica,_),reportarAnime(Listica));(agregarNuevoAnime(Listica))).

%! getAnime(Lista1, Lista2)
%  Halla el nombre del anime
%   @param Lista1   Lista de palabras del usuario
%   @param Lista2   Lista con todas las palabras que estan dentro de las comillas en la frase
%   ingresada por el usuario

getAnime([X|Z],Lista):-
    convert(X,String),
    String == "\"",
    getNombre(Lista,"").
getAnime([X|Z],Lista):-
    append(Lista,[X],Listica),
    getAnime(Z,Listica).

%! findComillas(Lista,Z)
%  Busca las comillas en la frase
%   @param Lista    Lista de palabras ingresadas por el usuario convertidas en atomos
%   @param Z        Resto de la lista despues de las comillas

findComillas([X|Z],Z):-
    convert(X,String),
    String == "\"",
    getAnime(Z,[]).
findComillas([X|Z],_):-
    findComillas(Z,_).    

/********************************************************************************************************************/
%! findRespuesta(Lista)
%  Reglas que se encarga de reconocer las palabras importantes que ingresa el usuario por
%  consola y dependiendo de lo que matchee le asigna una regla de respuesta
%  @param   Lista   Palabras que entran por consola

/*Mostrar Anime ordenados por rating y popularidad*/

findRespuesta(Lista):-
    (buscarPalabra('ordenados',Lista,RestoLista);buscarPalabra('orden',Lista,RestoLista)),
    (buscarPalabra('rating',RestoLista,_);buscarPalabra('estrellas',RestoLista,_);
        buscarPalabra('estrella',RestoLista,_)),
    (buscarPalabra('popularidad',RestoLista,_);buscarPalabra('popular',RestoLista,_)),
    buscarGenero(Lista,Genero),
    respuesta(7,Genero,_).

/*Mostrar Animes ordenados por rating*/
findRespuesta(Lista):-
    (buscarPalabra('ordenados',Lista,RestoLista);buscarPalabra('orden',Lista,RestoLista)),
    (buscarPalabra('rating',RestoLista,_);buscarPalabra('estrellas',RestoLista,_);
        buscarPalabra('estrella',RestoLista,_)),
    buscarGenero(Lista,Genero),
    respuesta(8,Genero,_).

/*Mostrar Animes ordenados por popularidad*/
findRespuesta(Lista):-
    (buscarPalabra('ordenados',Lista,RestoLista);buscarPalabra('orden',Lista,RestoLista)),
    (buscarPalabra('popularidad',RestoLista,_);buscarPalabra('popular',RestoLista,_)),
    buscarGenero(Lista,Genero),
    respuesta(9,Genero,_).

/* Buscar animes buenos-interesantes, pero poco conocidos */
findRespuesta(Lista):-
    (buscarPalabra('interesantes',Lista,_);buscarPalabra('interesante',Lista,_);
        buscarPalabra('bueno',Lista,_);buscarPalabra('buenos',Lista,_)),
    buscarMaximoRating(Maximo),
    buscarPopularidad(Lista,Popularidad),
    respuesta(6,Popularidad,Maximo).

/*Para buscar anime por genero segun numero de estrellas*/
findRespuesta(Lista):-
    %%(buscarPalabra('mostrar',Lista,RestoLista);buscarPalabra('muestrame',Lista,RestoLista);
    %%buscarPalabra('muestres',Lista,RestoLista)),
    (buscarPalabra('estrellas',Lista,_);buscarPalabra('estrella',Lista,_)),
    buscarGenero(Lista,Genero),
    respuesta(4,Lista,Genero).

/* Para buscar anime por genero segun popularidad*/
findRespuesta(Lista):-
    buscarPalabra('genero',Lista,_),
    buscarGenero(Lista,Genero),    
    buscarPopularidad(Lista,Popularidad),
    respuesta(5,Popularidad,Genero).


/*para preguntar por un anime en especifico*/
findRespuesta(Lista):-
    buscarPalabra('anime',Lista,RestoLista),
    buscarPalabra('conoces',RestoLista,RestoLista2),
    buscarPalabra('?',RestoLista2,_),
    findComillas(Lista,Z).

/*preguntar por los mejores animes segun el rating*/
findRespuesta(Lista):-
    buscarPalabra('cuales',Lista,RestoLista),
    buscarPalabra('mejores',RestoLista,RestoLista2),
    (buscarPalabra('animes',RestoLista2,_);buscarPalabra('ratings',RestoLista2,_)),
    respuesta(1,_,_).

/*preguntar por los animes de un genero en particular*/
findRespuesta(Lista):-
    buscarPalabra('me',Lista,RestoLista),
    buscarPalabra('gusta',RestoLista,RestoLista2),
    buscarPalabra('genero',RestoLista2,_),
    last(RestoLista2,X),
    %%atom_string(X,Palabra),
    convert(X,Palabra),
    respuesta(2,Palabra,_).

findRespuesta(Lista):-
	(buscarPalabra('recomiendame',Lista,RestoLista);buscarPalabra('recomendar',Lista,RestoLista)),
	(buscarPalabra('hoteles',RestoLista,_);buscarPalabra('hotel',RestoLista,_)),
	last(Lista,X),
	write('Lo siento amigo, pero no se nada acerca de hoteles en '),write(X),write('. Mejor preguntame sobre animes'),
	in.

findRespuesta(Lista):-
	(buscarPalabra('recomiendame',Lista,RestoLista);buscarPalabra('recomendar',Lista,RestoLista)),
	buscarPalabra('lugares',RestoLista,RestoLista2),buscarPalabra('visitar',RestoLista2,_),
	last(Lista,X),
	write('Lo siento amigo, pero no se nada acerca de lugares para visitar en '),write(X),write('. Mejor preguntame sobre animes'),
	in.	

findRespuesta(Lista):-
	(buscarPalabra('recomiendame',Lista,RestoLista);buscarPalabra('recomendar',Lista,RestoLista)),
	buscarPalabra('restaurantes',RestoLista,RestoLista2),buscarPalabra('visitar',RestoLista2,_),
	last(Lista,X),
	write('Lo siento amigo, pero no se nada acerca de buenos lugares para comer en '),write(X),write('. Mejor preguntame sobre animes'),
	in.		

findRespuesta(Lista):-
    buscarPalabra('adios',Lista,_),
    write('Fue un placer haber charlado contigo. Vuelve pronto, adios !').

findRespuesta(_):-
    write(' Lo siento amig@, no puedo constestarte.'),
    nl,
    write(' Por favor intenta preguntarme otra cosa.'),
    in.    

/***************************************************************************************************/

%! es_Genero(Anime, Genero)
%  Regla que determina que dicho genero pertenece a la lista de generos de el anime
%   @param Anime  Nombre del anime
%   @param Genero Nombre de genero

es_Genero(Anime,Genero):-
    generoAnime(Anime,Lista),
    member(Genero,Lista).

%! sumaAnime(Anime,Suma)
%  Regla que da la suma del rating  + popularidad de un anime
%   @param Anime    Anime
%   @param Suma     Resultado de rating+popularidad de ese anime 

sumaAnime(Anime,Suma):-
    rating(Anime,Rating),
    popularidad(Anime,Popularidad),
    integer(Rating),
    integer(Popularidad),
    Suma is (Rating+Popularidad).
    
    
/***********************************************************************/

%! respuesta(N,X,Y)
%   @param N    Identificador de respuesta
%   @param X    Depende de la regla de respuesta
%   @param Y    Depende de la regla de respuesta

respuesta(1,_,_):-
    buscarMaximoRating(Rating),   
    findall(X,rating(X,Rating),Z),
    write(' Estos son los anime(s) con mas numero de estrellas: '),
    imprimirLista(Z),
    nl,
    in.

/***************************************************/
/* Funcion de soporte para la respuesta(2,Genero) */ 
respuestaA([],Genero):-
    write(' Lo siento amig@, no tengo ningun anime de ' ),
    write(Genero), 
    write(' para mostrarte.').

respuestaA(Z,_):-
    write(' Entonces creo que estos animes te pueden interesar: '),
    imprimirLista(Z).

respuesta(2,Genero,_):-
    findall(X,es_Genero(X,Genero),Z),
    respuestaA(Z,Genero),
    nl,
    in. 

respuesta(4,[X,W|_],Genero):-
    convert(W,Y),
    (Y=="Estrellas";Y=="Estrella"),
    findall(B,(rating(B,X),es_Genero(B,Genero)),Z),length(Z,L),L>0,    
    write('Estos son los animes que conozco del genero '),write(Genero),
    write(' que tienen '),write(X),write(' estrellas: '),imprimirLista(Z),
    %%write(Z),
    in.
respuesta(4,[X|Z],Genero):-
    respuesta(4,Z,Genero).
respuesta(4,_,Genero):-
	write('Lo siento amig@, no tengo animes con esas caracteristicas que mostrarte'),in.      

respuesta(5,Popularidad,Genero):-
    ((Popularidad==a),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(1,2,X)),Z),length(Z,L),L>0,
        write('Estos son los animes(s) muy poco conocido(s) que tengo: '),imprimirLista(Z),in);
    ((Popularidad==b),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(3,5,X)),Z),length(Z,L),L>0,
        write('Estos son los animes(s) poco conocido(s) que tengo: '),imprimirLista(Z),in);
    ((Popularidad==c),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(6,7,X)),Z),length(Z,L),L>0,
        write('Estos son los animes(s) conocido(s) que tengo: '),imprimirLista(Z),in);
    ((Popularidad==d),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(8,9,X)),Z),length(Z,L),L>0,
        write('Estos son los animes(s) muy conocido(s) que tengo: '),imprimirLista(Z),in);
    ((Popularidad==e),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(10,10,X)),Z),length(Z,L),L>0,
        write('Estos son los animes(s) bastante conocido(s) que tengo: '),imprimirLista(Z),in).  
respuesta(5,Popularidad,Genero):-
	write('Lo siento amig@, no tengo animes con esas caracteristicas que mostrarte'),in.

respuesta(6,Popularidad,Maximo):-
    ((Popularidad==a),findall(B,(popularidad(B,X),rating(B,Maximo),between(1,2,X)),Z),length(Z,L),L>0,
        write('Te pueden interesar los siguientes animes: '),imprimirLista(Z),in);
    ((Popularidad==b),findall(B,(popularidad(B,X),rating(B,Maximo),between(3,5,X)),Z),length(Z,L),L>0,
        write('Te pueden interesar los siguientes animes: '),imprimirLista(Z),in);
    ((Popularidad==c),findall(B,(popularidad(B,X),rating(B,Maximo),between(6,7,X)),Z),length(Z,L),L>0,
        write('Te pueden interesar los siguientes animes: '),imprimirLista(Z),in);
    ((Popularidad==d),findall(B,(popularidad(B,X),rating(B,Maximo),between(8,9,X)),Z),length(Z,L),L>0,
        write('Te pueden interesar los siguientes animes: '),imprimirLista(Z),in);
    ((Popularidad==e),findall(B,(popularidad(B,X),rating(B,Maximo),between(10,10,X)),Z),length(Z,L),L>0,
        write('Te pueden interesar los siguientes animes: '),imprimirLista(Z),in).
respuesta(6,Popularidad,Maximo):-
    write('Disculpa,no tengo ningun anime con esas caracteristicas para mostrarte'),in.    

respuesta(7,Genero,_):-
    findall(X,es_Genero(X,Genero),Animes),length(Animes,L),L>0,write(' Creo que te pueden interesar los siguientes animes: \n'),
    listaSuma(Animes,[],Listica,Animes).
respuesta(7,Genero,_):-
	write('Lo siento amigo, en estos momentos no tengo ningun anime de genero '),write(Genero),write(' para recomendarte.'),in.    

respuesta(8,Genero,_):-
    findall(X,(es_Genero(X,Genero),rating(X,5)),Animes5),length(Animes5,L5),
    findall(X,(es_Genero(X,Genero),rating(X,4)),Animes4),length(Animes4,L4),
    findall(X,(es_Genero(X,Genero),rating(X,3)),Animes3),length(Animes3,L3),
    findall(X,(es_Genero(X,Genero),rating(X,2)),Animes2),length(Animes2,L2),    
    findall(X,(es_Genero(X,Genero),rating(X,1)),Animes1),length(Animes1,L1),
    Suma is (L5+L4+L3+L2+L1),Suma>0,write(' Creo que te pueden interesar los siguientes animes, los organice por numero de estrellas como me pediste: '),
    imprimirLista(Animes5),
    imprimirLista(Animes4),
    imprimirLista(Animes3),
    imprimirLista(Animes2),            
    imprimirLista(Animes1),
    in.
respuesta(8,Genero,_):-
	write('Lo siento amigo, en estos momentos no tengo ningun anime de genero '),write(Genero),write(' para recomendarte.'),in.    


respuesta(9,Genero,_):-
    findall(X,(es_Genero(X,Genero),popularidad(X,10)),Animes10),length(Animes10,L10),
    findall(X,(es_Genero(X,Genero),popularidad(X,9)),Animes9),length(Animes9,L9),
    findall(X,(es_Genero(X,Genero),popularidad(X,8)),Animes8),length(Animes8,L8),
    findall(X,(es_Genero(X,Genero),popularidad(X,7)),Animes7),length(Animes7,L7),    
    findall(X,(es_Genero(X,Genero),popularidad(X,6)),Animes6),length(Animes6,L6),
    findall(X,(es_Genero(X,Genero),popularidad(X,5)),Animes5),length(Animes5,L5),
    findall(X,(es_Genero(X,Genero),popularidad(X,4)),Animes4),length(Animes4,L4),
    findall(X,(es_Genero(X,Genero),popularidad(X,3)),Animes3),length(Animes3,L3),
    findall(X,(es_Genero(X,Genero),popularidad(X,2)),Animes2),length(Animes2,L2),   
    findall(X,(es_Genero(X,Genero),popularidad(X,1)),Animes1),length(Animes1,L1),
    N is (L10+L9+L8+L7+L6+L5+L4+L3+L2+L1), N>0,write(' Creo que te pueden interesar los siguientes animes, los organice por popularidad como me pediste: '),
    imprimirLista(Animes10),
    imprimirLista(Animes9),
    imprimirLista(Animes8),
    imprimirLista(Animes7),
    imprimirLista(Animes6),
    imprimirLista(Animes5),
    imprimirLista(Animes4),
    imprimirLista(Animes3),
    imprimirLista(Animes2),
    imprimirLista(Animes1),
    in.
respuesta(9,Genero,_):-
	write('Lo siento amigo, en estos momentos no tengo ningun anime de genero '),write(Genero),write(' para recomendarte.'),in.

/*****************************************************************************/
aniBot:-
    write("AniBot welcomes you!"),
    in.
