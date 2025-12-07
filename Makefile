# $Id: Makefile,v 1.9 2007-10-22 18:53:12 rich Exp $

BUILD_ID_NONE := -Wl,--build-id=none 
#BUILD_ID_NONE := 

SHELL	:= /bin/bash

all:	nativeforth

nativeforth: nativeforth.S
	gcc -nostdlib -static $(BUILD_ID_NONE) -o $@ $<

run:
	cat nativeforth.f $(PROG) - | ./nativeforth

clean:
	rm -f nativeforth perf_dupdrop *~ core .test_*

# Tests.

TESTS	:= $(patsubst %.f,%.test,$(wildcard test_*.f))

test check: $(TESTS)

test_%.test: test_%.f nativeforth
	@echo -n "$< ... "
	@rm -f .$@
	@cat <(echo ': TEST-MODE ;') nativeforth.f $< <(echo 'TEST') | \
	  ./nativeforth 2>&1 | \
	  sed 's/DSP=[0-9]*//g' > .$@
	@diff -u .$@ $<.out
	@rm -f .$@
	@echo "ok"

.SUFFIXES: .f .test
.PHONY: test check run run_perf_dupdrop
