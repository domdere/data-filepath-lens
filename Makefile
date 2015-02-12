MFLAGS =
MAKEFLAGS = $(MFLAGS)
SANDBOX = .cabal-sandbox
CABAL_FLAGS =
DEPS = .cabal-sandbox/.cairn

.PHONY: build test

default: repl

${SANDBOX}:
	cabal sandbox init

${DEPS}: ${SANDBOX} $(wildcard *.cabal)
	cabal install -j --only-dependencies --enable-tests
	cabal configure --enable-tests ${CABAL_FLAGS}
	touch $@

build: ${DEPS}
	cabal build --ghc-option="-Werror"

test: ${DEPS}
	cabal test quickcheck --log=/dev/stdout

hlint: ${DEPS}
	cabal test hlint --log=/dev/stdout

test: ${DEPS}
	cabal test

repl: ${DEPS}
	cabal repl
