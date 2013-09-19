
PERL_GIT:=https://github.com/mirrors/perl.git
PERL_VERSION:=v5.18.1

all: microperl.js gen.modules.js
	echo '(function bootPerl() {' > perl.js
	cat prelude.js >> perl.js
	cat microperl.js >> perl.js
	echo '}());' >> perl.js
	echo '#!/usr/bin/env node' > perl-cli.js
	cat perl.js >> perl-cli.js
	chmod +x perl-cli.js
	mv perl.js web

microperl.js: perl gen.modules.js
	cd perl && make -f ../Makefile.emcc
	cp perl/microperl.js microperl.js

perl:
	git clone --depth 1 -b $(PERL_VERSION) $(PERL_GIT)

gen.modules.js: # may have NO_MODULES=1
	perl pack-pm.pl > $@

gh-pages:
	#JAVA_TOOL_OPTIONS=-Xmx1024m closure-compiler --compilation_level WHITESPACE_ONLY --js web/perl.js --js_output_file perl.js
	cp web/perl.js perl.js
	cp web/index.html index.html
	git add -f index.html perl.js

clean:
	cd perl && git co . && git clean -dfx
	rm -rf microperl.js perl.js perl-cli.js

