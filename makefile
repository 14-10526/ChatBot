CC=swipl
FLAGS=--goal=aniBot --stand_alone=true --quiet
EXE=anibot
FILE=AniPrueba.pl

$(EXE): $(FILE)
		$(CC) $(FLAGS) -o $@ -c $^