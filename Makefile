.PHONY: clean all release Engine install

all: Engine

clean:
	$(MAKE) -C Engine clean

release: all
	git push SourceForge master
	scp ReadMe.md Engine/bin/* jptaylor@frs.sourceforge.net:/home/frs/project/gerber2pdf/

install: all
	@echo "### Local Installation ###"
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
#-------------------------------------------------------------------------------

Engine:
	$(MAKE) -C Engine all
#-------------------------------------------------------------------------------

