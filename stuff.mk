%.makestuff:
	-cd $(dir $(ms)) && mv -f $(notdir $(ms)) .$(notdir $(ms))
	cd $(dir $(ms)) && git clone $(msrepo)/$(notdir $(ms)).git
	-cd $(dir $(ms)) && rm -rf .$(notdir $(ms))
	touch $@

msrepo = https://github.com/dushoff
gitroot = ../
Drop = ~/Dropbox/Latent_incidence_fitting/


$(out):
	mkdir $(out)

Makefile: $(out)
	ln -fs $(out) out
	ln -fs $(curr) curr

# cb3682d

ms = $(gitroot)/makestuff
-include local.mk
-include $(gitroot)/local.mk

export ms = $(gitroot)/makestuff

BRANCH = $(shell cat .git/HEAD | perl -npE "s|.*/||;")
COMMIT = $(shell cat .git/refs/heads/$(BRANCH) | perl -npE 's/(.{8}).*/$$1/;')
export HOSTNAME


### Stuff that belongs in makestuff, but we don't want to make people download t again now
READONLY = chmod a-w $@
PDFCAT = pdftk $(filter %.pdf, $^)  cat output $@
PDFFRONT = pdftk $<  cat 1 output $@
CAT = cat $^ > $@
