NAME=xor
BIN=$(NAME)
FPC=fpc
RELEASE_UNIT=-Mobjfpc -l -B -O3 -Sih -viewnh -Fu/usr/local/include/* -XMmain -Xs -XS -XX -CX -C3- -Cg -Ci- -Co- -CO- -Cr- -Ct-
RELEASE=-Mobjfpc -l -B -O3 -OWAll -FW./bin/bm1NAKQStWvrNaqS.feedback -Sih -viewnh -Fu/usr/local/include/* -XMmain -Xs- -XS -XX -CX -C3- -Cg -Ci- -Co- -CO- -Cr- -Ct-
RELEASE2=-Mobjfpc -l -B -O3 -OwAll -Fw./bin/bm1NAKQStWvrNaqS.feedback -Sih -viewnh -Fu/usr/local/include/* -XMmain -Xs -XS -XX -CX -C3- -Cg -Ci- -Co- -CO- -Cr- -Ct-
DEBUG=-dDEBUG -Mobjfpc -l -O- -Sih -viewnh -Fu/usr/local/include/* -XMmain -Xs- -XS -XX -CX -g

LOCAL_DATE=$(shell date +'%Y/%m/%d - %H:%M:%S %Z')
SOURCE_HASH=$(shell sha256sum $(NAME).pas | grep -o '^[0-9a-fA-F]*')

export LOCAL_DATE
export SOURCE_HASH

release:
	@rm -rf ./bin && mkdir -p ./bin
	$(FPC) $(RELEASE) ./$(NAME).pas -o./bin/$(BIN)
	@echo '--------------------------------------------------'
	$(FPC) $(RELEASE2) ./$(NAME).pas -o./bin/$(BIN)

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
	@tar -c --to-stdout *.pas makefile COPYING | xz '--lzma2=dict=32MiB,lc=4,lp=0,pb=2,nice=273,mf=bt4,depth=32768' > $(NAME).tar.xz

clean:
	@rm -f *.o *.res *.a *.ppu ./bin/*
