:- dynamic(counter/1).


:- dynamic generoAnime/2.
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

/*Regla que permite al usuario escribir en la linea de comandos y luego la lee*/
in:-
    nl,
    write('>'),
    readLine(Text).

/*Funcion que lee lo escrito por el usuario en el comando y elimina mayusculas*/
readLine(Text):-
    readln(Text,_,_,_,lowercase),
    findRespuesta(Text).

/*lee los generos ingresados por el usuario de un nuevo anime*/
readGenero(Text):-
    readln(Text,_,_,_,lowercase).
readGenero(_):-
    write('Escribe al menos un genero por favor :( .'),in.
/*lee el rating ingresado por el usuario de un nuevo anime*/
readRating(Text):-
    readln(Text,_,_,_,lowercase).
            
/***********************************************************************/
/*Funcion que ubica una palabra en la frase que ingresa el usuario*/
buscarPalabra(X,[X|T],T).
buscarPalabra(X,[Y|T],L):- 
    buscarPalabra(X,T,L).

/*Esta funcion convierte la palabra que se ingrese a mayuscula la primera letra*/
/* para que pueda hacer matching con los facts*/
convert(Atomo,String):-
    atom_chars(Atomo,[X|Z]),
    upcase_atom(X,Upper),
    append([Upper],Z,Lista),
    string_chars(String,Lista).

buscarGenero([X,W|Z],Genero):-
    convert(X,Y),
    Y=="Genero",    
    convert(W,Genero).
buscarGenero([X|Z],Genero):-
    buscarGenero(Z,Genero).    

buscarRating([X,W|_],X):-
    convert(W,Y),
    (Y=="Estrellas";Y=="Estrella").
buscarRating([X|Z],_):-
    buscarRating(Z,_).     

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


/* ESTAS REGLAS PERMITEN QUE SI SE PREGUNTA POR UN MISMO ANIME MAS DE 5 VECES, SE AUMENTE LA POPULARIDAD DEL MISMO*/    
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


/* Reporta un anime que ya existe en la base de datos*/    
reportarAnime(Anime):-
    subirConteo(Anime),
    write('Si lo conozco! '),
    rating(Anime,Rating),
    generoAnime(Anime,Genero),
    write(Anime),write(' tiene '),write(Rating),
    write(' estrella(s)'),write(' es de genero '),imprimirGenero(Genero),write(' y es'),imprimirPopularidad(Anime),
    in. 

/* Agrega la lista de generos de un nuevo anime que el usuario este ingresando*/
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

/* Agrega el predicado que indica el rating del anime nuevo que esta agregando el usuario*/
agregarRating([X],Anime):-
    integer(X),
    between(1,5,X),
    assert(rating(Anime,X)).
agregarRating(_,Anime):-
    write('Lo siento,el rating ingresado debe ser un numero entero entre 1 y 5.'),in.

agregarPopularidad([X],Anime):-
    integer(X),
    between(1,10,X),
    assert(popularidad(Anime,X)).
agregarPopularidad(_,Anime):-
    assert(popularidad(Anime,1)).


/* Agregar nuevo anime ingresado por el usuario a la base de datos */ 
agregarNuevoAnime(Anime):-
    write('No lo conozco, pero me gustaria saber mas.'),nl,
    write('Cuales son sus generos ?: '),nl,readGenero(Texta),agregarGenero(Texta,[],Anime),nl,
    write('Cual es su rating o numero de estrellas ?: '),nl,readRating(Texto), agregarRating(Texto,Anime),nl,
    write('Del 1 al 10, puedes decir que tan popular es?: '),nl,readRating(Texte),agregarPopularidad(Texte,Anime),
    assert(preguntado(Anime,1)),
    write('Ya lo tengo anotado, muchas gracias!.'),in.

                                    
buscarPopularidad(Lista,Popularidad):-
    (buscarPalabra('muy',Lista,RestoLista),buscarPalabra('poco',RestoLista,_),Popularidad=a);
    (buscarPalabra('poco',Lista,RestoLista),Popularidad=b);
    (buscarPalabra('muy',Lista,RestoLista),(buscarPalabra('conocido',RestoLista,_);buscarPalabra('conocidos',RestoLista,_)),Popularidad=d);
    (buscarPalabra('bastante',Lista,RestoLista),Popularidad=e);
    ((buscarPalabra('conocido',Lista,RestoLista);buscarPalabra('conocidos',Lista,RestoLista)),Popularidad=c). 

/* Busca cual es el rating mas alto, actualmente en la base de datos que posee un anime */
buscarMaximoRating(Maximo):-
    (rating(_,5),Maximo=5);
    (rating(_,4),Maximo=4);
    (rating(_,3),Maximo=3);
    (rating(_,2),Maximo=2);
    (rating(_,1),Maximo=1).

/*Funcion que imprime cada anime de la lista que recibe con sus atributos*/
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

/*regla que imprime elemento de la lista si su suma es igual al maximo.*/
imprimirMaximo([X|Z],Maximo):-
    nl,
    sumaAnime(X,Maximo),
    write(X),write(', Numero de estrellas:'),
    rating(X,Rating),write(Rating),write(', Popularidad:'),
    popularidad(X,Popularidad),write(Popularidad),
    imprimirMaximo(Z,Maximo).
imprimirMaximo([X|Z],Maximo):- 
    imprimirMaximo(Z,Maximo).
imprimirMaximo([],Maximo).    

/* Regla que halla la suma maxima entre rating+popularidad de cada anime*/
hallarMaximo(Lista,ListaAnime):-
    max_list(Lista,X),
    delete(Lista,X,Listica),
    imprimirMaximo(ListaAnime,X),
    hallarMaximo(Listica,ListaAnime).
hallarMaximo([],ListaAnime):-
    in.    
    
/* Crea una lista con todas las sumas de los animes suma = rating + popularidad*/    
listaSuma([X|Z],Lista,_,Animes):-
    sumaAnime(X,Suma),
    append(Lista,[Suma],Listica),
    listaSuma(Z,Listica,_,Animes).
listaSuma([X],Lista,Listica,Animes):-
    sumaAnime(X,Suma),
    append(Lista,[Suma],Listica),
    hallarMaximo(Listica,Animes).

/* ESTAS FUNCIONES AYUDAN A ENCONTRAR EL NOMBRE DE UN ANIME CUANDO SE INGRESA POR EL USUARIO*/
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

getAnime([X|Z],Lista):-
    convert(X,String),
    String == "\"",
    getNombre(Lista,"").
getAnime([X|Z],Lista):-
    append(Lista,[X],Listica),
    getAnime(Z,Listica).

findComillas([X|Z],Z):-
    convert(X,String),
    String == "\"",
    getAnime(Z,[]).
findComillas([X|Z],_):-
    findComillas(Z,_).    

/********************************************************************************************************************/
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
    buscarPalabra('adios',Lista,_),
    write('Fue un placer haber charlado contigo. Vuelve pronto, adios !'),
    abort.

findRespuesta(_):-
    write(' Lo siento amig@, no puedo constestarte.'),
    nl,
    write(' Por favor intenta preguntarme otra cosa.'),
    in.    

/***************************************************************************************************/

/* Dicho genero pertenece a la lista de generos de el anime*/
es_Genero(Anime,Genero):-
    generoAnime(Anime,Lista),
    member(Genero,Lista).

/*Da la suma del rating  + popularidad de un anime*/
sumaAnime(Anime,Suma):-
    rating(Anime,Rating),
    popularidad(Anime,Popularidad),
    integer(Rating),
    integer(Popularidad),
    Suma is (Rating+Popularidad).
    
    
/***********************************************************************/
respuesta(1,_,_):-
    buscarMaximoRating(Rating),   
    findall(X,rating(X,Rating),Z),
    write(' Estos son los anime(s) con mas numero de estrellas: '),
    write(Z),
    nl,
    in.

/***************************************************/
/* Funcion de soporte para la respuesta(2,Genero) */ 
respuestaA([],Genero):-
    write(' Lo siento amig@, no tengo ningun anime de ' ),
    write(Genero), 
    write(' para mostrarte.').

respuestaA(Z,_):-
    write(' Estos anime(s) son los que tienen rating 5 estrellas : '),
    write(Z).

respuesta(2,Genero,_):-
    findall(X,es_Genero(X,Genero),Z),
    respuestaA(Z,Genero),
    nl,
    in. 

respuesta(4,[X,W|_],Genero):-
    convert(W,Y),
    (Y=="Estrellas";Y=="Estrella"),
    findall(B,(rating(B,X),es_Genero(B,Genero)),Z),    
    write('Estos son los animes que conozco del genero '),write(Genero),
    write(' que tienen '),write(X),write(' estrellas: '),
    write(Z),
    in.
respuesta(4,[X|Z],Genero):-
    respuesta(4,Z,Genero).  

respuesta(5,Popularidad,Genero):-
    ((Popularidad==a),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(1,2,X)),Z),
        write('Estos son los animes(s) muy poco conocido(s) que tengo: '),write(Z),in);
    ((Popularidad==b),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(3,5,X)),Z),
        write('Estos son los animes(s) poco conocido(s) que tengo: '),write(Z),in);
    ((Popularidad==c),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(6,7,X)),Z),
        write('Estos son los animes(s) conocido(s) que tengo: '),write(Z),in);
    ((Popularidad==d),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(8,9,X)),Z),
        write('Estos son los animes(s) muy conocido(s) que tengo: '),write(Z),in);
    ((Popularidad==e),findall(B,(popularidad(B,X),es_Genero(B,Genero),between(10,10,X)),Z),
        write('Estos son los animes(s) bastante conocido(s) que tengo: '),write(Z),in).  

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
    write(' Creo que te pueden interesar los siguientes animes: '),
    findall(X,es_Genero(X,Genero),Animes),
    listaSuma(Animes,[],Listica,Animes).

respuesta(8,Genero,_):-
    write(' Creo que te pueden interesar los siguientes animes, los organice por numero de estrellas como me pediste: '),
    findall(X,(es_Genero(X,Genero),rating(X,5)),Animes5),
    imprimirLista(Animes5),
    findall(X,(es_Genero(X,Genero),rating(X,4)),Animes4),
    imprimirLista(Animes4),
    findall(X,(es_Genero(X,Genero),rating(X,3)),Animes3),
    imprimirLista(Animes3),
    findall(X,(es_Genero(X,Genero),rating(X,2)),Animes2),
    imprimirLista(Animes2),    
    findall(X,(es_Genero(X,Genero),rating(X,1)),Animes1),
    imprimirLista(Animes1),
    in.

respuesta(9,Genero,_):-
    write(' Creo que te pueden interesar los siguientes animes, los organice por popularidad como me pediste: '),
    findall(X,(es_Genero(X,Genero),popularidad(X,10)),Animes10),
    imprimirLista(Animes10),
    findall(X,(es_Genero(X,Genero),popularidad(X,9)),Animes9),
    imprimirLista(Animes9),
    findall(X,(es_Genero(X,Genero),popularidad(X,8)),Animes8),
    imprimirLista(Animes8),
    findall(X,(es_Genero(X,Genero),popularidad(X,7)),Animes7),
    imprimirLista(Animes7),    
    findall(X,(es_Genero(X,Genero),popularidad(X,6)),Animes6),
    imprimirLista(Animes6),
    findall(X,(es_Genero(X,Genero),popularidad(X,5)),Animes5),
    imprimirLista(Animes5),
    findall(X,(es_Genero(X,Genero),popularidad(X,4)),Animes4),
    imprimirLista(Animes4),
    findall(X,(es_Genero(X,Genero),popularidad(X,3)),Animes3),
    imprimirLista(Animes3),
    findall(X,(es_Genero(X,Genero),popularidad(X,2)),Animes2),
    imprimirLista(Animes2),    
    findall(X,(es_Genero(X,Genero),popularidad(X,1)),Animes1),
    imprimirLista(Animes1),
    in.

/*****************************************************************************/
aniBot:-
    write("AniBot welcomes you!"),
    in.
