PREFIX = TDPRobocup

## #################################### ##
##  VARIABLES                           ##
## #################################### ##

TEXFILE = $(PREFIX).tex
PDFFILE = $(PREFIX).pdf
MAKE    = make -s
RMFILES = *~ *.toc *.idx *.ilg *.ind *.bbl *.blg *.out *.aux *.synctex.gz \
			*.tmp *.log *.lot *.lof *.adx *.and *.abb *.ldx *.temp*
SILENT  = @
RUBBER := $(shell command -v rubber 2> /dev/null)
SPLLOPT = --dont-tex-check-comments \
		--encoding=utf-8 \
		--lang=en \
		--mode=tex \
		--extra-dicts=./extra_dict.pws \
		-p ./extra_dict.pws

## COMMANDS ###############

ifdef RUBBER
all:
	$(SILENT) echo "Compiling $(TEXFILE) with rubber"
	$(SILENT) $(MAKE) rubber
else
all:
	$(SILENT) echo "Compiling $(TEXFILE) with pdflatex & bibtex"
	$(SILENT) $(MAKE) legacy;
endif

## #################################### ##
##  R U L E S                           ##
## #################################### ##

dobibtex:
	$(SILENT) bibtex $(PREFIX)

dopdflatex:
	$(SILENT) pdflatex --shell-escape $(TEXFILE) || $(SILENT) $(MAKE) clean

rubber:
	$(SILENT) $(MAKE) warn_spell
	$(SILENT) rubber --pdf --force $(TEXFILE)
	clean
	
legacy:
	$(SILENT) $(MAKE) warn_spell
	$(SILENT) $(MAKE) dopdflatex
	$(SILENT) $(MAKE) dobibtex
	$(SILENT) $(MAKE) dopdflatex
	$(SILENT) $(MAKE) dopdflatex
	$(SILENT) $(MAKE) clean

warn_spell:
	$(SILENT) aspell $(SPLLOPT) list < $(TEXFILE)

check_spelling:
	$(SILENT) aspell $(SPLLOPT) check $(TEXFILE)

clean:
	$(SILENT) rm -f $(RMFILES)

cleanAll:
	$(SILENT) rm -f *.pdf *.dvi $(RMFILES)
