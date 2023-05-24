.PHONY: clean all release Engine install windeploy

all: Engine

clean:
	$(MAKE) -C Engine clean

release: all
	git push SourceForge master
	scp ReadMe.md Engine/bin/* jptaylor@frs.sourceforge.net:/home/frs/project/gerber2pdf/

install: all
	@echo "### Local Installation ###"
	@echo "    ### Copying 'LICENSE' ==> 'Engine/bin/LICENSE.Gerber2pdf'"
	@cp -p LICENSE  Engine/bin/LICENSE.Gerber2pdf
	@files=`ls Engine/bin/*`; \
	if [ -d $$HOME/bin/linux/ ]; then \
		for file in $$files; do \
			echo "    ### Copying $$file ==> $$HOME/bin/linux/"; \
			cp -p $$file $$HOME/bin/linux/; \
		done; \
	elif [ -d $$HOME/bin/ ]; then \
		for file in $$files; do \
			echo "    ### Copying $$file ==> $$HOME/bin/"; \
			cp -p $$file $$HOME/bin/; \
		done; \
	else \
		echo "!!! No destination found !!!"; \
	fi

windeploy: install
	@export dlldir="/mingw64/bin"; \
	if [ -d $$dlldir ]; then \
		echo ""; \
		echo "### Deploying Windows DLLs ###"; \
		files="libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll"; \
		for file in $$files; do \
			echo "    ### Copying $$file ==> Engine/bin/"; \
			cp -p  $$dlldir/$$file Engine/bin/; \
		done; \
		echo ""; \
		if [ -d $$HOME/bin/linux/ ]; then \
			for file in $$files; do \
				echo "    ### Copying $$file ==> $$HOME/bin/linux/"; \
				cp -p  $$dlldir/$$file $$HOME/bin/linux/; \
			done; \
		elif [ -d $$HOME/bin/ ]; then \
			for file in $$files; do \
				echo "    ### Copying $$file ==> $$HOME/bin/"; \
				cp -p  $$dlldir/$$file $$HOME/bin/; \
			done; \
		else \
			echo "!!! No destination found !!!"; \
		fi \
	fi
#-------------------------------------------------------------------------------

Engine:
	$(MAKE) -C Engine all
#-------------------------------------------------------------------------------

