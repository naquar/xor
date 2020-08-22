NAME=xor
BIN=$(NAME)
FPC=fpc
RELEASE=-Mobjfpc -l -B -O3 -Sih -viewnh -Fu/usr/local/include/* -Xs -XS -XX
DEBUG=-dDEBUG -Mobjfpc -g -l -B -O0 -Sih -viewnh -Fu/usr/local/include/* -XS -XX

LOCAL_DATE=$(shell date --utc +'%Y/%m/%d - %H:%M:%S %Z')

export LOCAL_DATE

release:
	@rm -rf ./bin && mkdir -p ./bin
	$(FPC) $(RELEASE) ./$(NAME).pas -o./bin/$(BIN)

debug:
	@rm -rf ./bin && mkdir -p ./bin
	$(FPC) $(DEBUG) ./$(NAME).pas -o./bin/$(BIN)

run:
	@./bin/$(BIN) $(ARG)

rundbg:
	@./bin/$(BIN)_dbg

install:
	chmod a+x ./bin/$(BIN)
	cp ./bin/$(BIN) /usr/local/bin

source:
	@tar -c --to-stdout *.pas makefile COPYING | xz --extreme -9 > $(NAME).tar.xz

clean:
	@rm -f *.o *.res *.a *.ppu ./bin/*
