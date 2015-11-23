%.makestuff:
	-cd $(dir $(ms)) && mv -f $(notdir $(ms)) .$(notdir $(ms))
	cd $(dir $(ms)) && git clone $(msrepo)/$(notdir $(ms)).git
	-cd $(dir $(ms)) && rm -rf .$(notdir $(ms))
	touch $@

msrepo = https://github.com/dushoff
gitroot = ../

-include local.mk
-include $(gitroot)/local.mk

export ms = $(gitroot)/makestuff

### Stuff that belongs in makestuff, but we don't want to make people download t again now
READONLY = chmod a-w $@
PDFCAT = pdftk $(filter %.pdf, $^)  cat output $@
PDFFRONT = pdftk $<  cat 1 output $@
CAT = cat $^ > $@
