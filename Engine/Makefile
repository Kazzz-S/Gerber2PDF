Options += -std=c++20 -Wall -fexceptions -O2

ifeq ($(OS), Windows_NT)
  CXX       = x86_64-w64-mingw32-g++
  obj       = obj_win
  LibZip    = ZLib/libz.a
  LibEngine = $(obj)/libEngine.a
  Output    = bin/Gerber2pdf.exe
  Options  += -municode
  Resources = $(obj)/Resources/resource.res
else
  CXX       = g++
  obj       = obj_lin
  LibZip    = ZLib/libz.a
  LibEngine = $(obj)/libEngine.a
  Output    = bin/Gerber2pdf
  Options  +=
  Resources =
endif

#-------------------------------------------------------------------------------
Includes   = -ITools/Deflate
Includes  += -ITools/Gerber
Includes  += -ITools/Gerber/Gerber
Includes  += -ITools/PDF
Includes  += -ITools/PDF/afm
Includes  += -ITools/PDF/pdf
Includes  += -IToolbox/Cpp
Includes  += -IZLib

Libraries  =
LibInclude =

#-------------------------------------------------------------------------------
Version = -DMAJOR_VERSION=1 -DMINOR_VERSION=12 -DTEENY_VERSION=1

Objects  = $(shell find Tools       -iname "*.cpp")
Objects += $(shell find Toolbox/Cpp -iname "*.cpp")
Objects += Engine.cpp
Objects := $(Objects:%.cpp=$(obj)/%.o)

Headers  = $(shell find . -iname "*.h")

#-------------------------------------------------------------------------------
.PHONY: clean all
.SECONDARY:

all: $(Output)

clean:
	rm -rf $(Output) $(obj)
	cd ZLib; git clean -xdf

#-------------------------------------------------------------------------------
# Binaries
$(Output): $(LibZip) $(LibEngine) $(Resources) main.cpp main.h
	mkdir -p bin
ifeq ($(OS), Windows_NT)
	$(CXX) main.cpp $(Options) $(Version) $(Includes) -s $(Resources) \
	-L$(obj) -lEngine -LZLib -lz -o $@
else
	$(CXX) main.cpp $(Options) $(Version) $(Includes) \
	-L$(obj) -lEngine -LZLib -lz -o $@
endif

#-------------------------------------------------------------------------------
# Libraries
$(LibEngine): $(Objects)
	mkdir -p $(@D)
	ar -rcs $@ $(Objects)

$(LibZip):
ifeq ($(OS), Windows_NT)
	$(MAKE) -C ZLib -f win32/Makefile.gcc
else
	cd ZLib	; \
	./configure && \
	make
endif

#-------------------------------------------------------------------------------
# Objects
$(obj)/%.o: %.cpp $(Headers)
	mkdir -p $(@D)
	$(CXX) $(Options) $(Version) $(Defines) -c $(Includes) $< -o $@

#-------------------------------------------------------------------------------
# Resources
$(obj)/%.res: %.rc
	mkdir -p $(@D)
	windres.exe -J rc -O coff -i $< -o $@

#-------------------------------------------------------------------------------
# EOF
