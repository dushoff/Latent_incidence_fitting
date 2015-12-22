%.makestuff:
	-cd $(dir $(ms)) && mv -f $(notdir $(ms)) .$(notdir $(ms))
	cd $(dir $(ms)) && git clone $(msrepo)/$(notdir $(ms)).git
	-cd $(dir $(ms)) && rm -rf .$(notdir $(ms))
	touch $@

msrepo = https://github.com/dushoff
gitroot = ../
Drop = ~/Dropbox/Latent_incidence_fitting/

Makefile: $(out)

# cb3682d

ms = $(gitroot)/makestuff
out = $(Drop)/$(COMMIT)_$(HOSTNAME)
curr = $(out)
curr = $(Drop)/319ecc01_yushan-n04/

-include local.mk
-include $(gitroot)/local.mk

export ms = $(gitroot)/makestuff

######################################################################

# Branch and output directory management

BRANCH = $(shell cat .git/HEAD | perl -npE "s|.*/||;")
COMMIT = $(shell cat .git/refs/heads/$(BRANCH) | perl -npE 's/(.{8}).*/$$1/;')
export HOSTNAME

$(out):
	mkdir $@

outdir: $(out)

now:
	ls $(curr)

######################################################################

### Stuff that belongs in makestuff, but we don't want to make people download t again now
READONLY = chmod a-w $@
PDFCAT = pdftk $(filter %.pdf, $^)  cat output $@
PDFFRONT = pdftk $<  cat 1 output $@
CAT = cat $^ > $@
