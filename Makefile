### Latent_incidence_fitting

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: OLD1.disp.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk

##################################################################

# Discussion

Sources += todo.md notes.md

######################################################################


### Flow

Sources += $(wildcard *.R)
Sources += $(wildcard *.pl)
Sources += $(wildcard *.bug)
Sources += $(wildcard *.bugtmp)

.PRECIOUS: base%.autobug
base%.autobug: base.bugtmp flag.pl
	$(PUSHSTAR)

.PRECIOUS: disp%.autobug
disp%.autobug: disp.bugtmp lagchain.pl
	$(RM) $@
	$(PUSHSTAR)
	$(READONLY)

disp5.autobug: disp.bugtmp lagchain.pl

data = $(gitroot)/techtex-ebola/Data

.PRECIOUS: %.scen.Rout
NIH%.scen.Rout: $(data)/NIH%/*confirmed*country*.csv scen.R
	$(run-R)

.PRECIOUS: OLD%.scen.Rout
OLD%.scen.Rout: $(data)/NIHx_timepoint_1/NIH%/*confirmed*country*.csv scen.R
	$(run-R)

######################################################################

# base.R is a pure Poisson, renewal equation machine. Seems to work pretty weel for what it does, but not extensively tested. CIs are very tight on real data. Reporting ratios rarely identifiable, which is as it should be.

.PRECIOUS: %.base.Rout
%.base.Rout: i5000.Rout %.scen.Rout base5.autobug base.R
	$(run-R)

%.disp.Rout: i5000.Rout %.scen.Rout disp5.autobug base.R
	$(run-R)
## CURR
OLD1.disp.Rout: disp.bugtmp base.R

NIH.base.pdf: NIH1.base.Rout.pdf NIH2.base.Rout.pdf NIH3.base.Rout.pdf NIH4.base.Rout.pdf
	pdftk $^ cat output $@

OLD.base.pdf: OLD1.base.Rout.pdf OLD2.base.Rout.pdf OLD3.base.Rout.pdf OLD4.base.Rout.pdf
	pdftk $^ cat output $@

OLD.base.output: OLD2.base.Routput OLD2.base.Routput OLD3.base.Routput OLD4.base.Routput
	cat $^ > $@

### Look at old projections with new data

.PRECIOUS: first%.projtest.Rout
first%.projtest.Rout: OLD%.disp.Rout NIH%.scen.Rout projtest.R
	$(run-R)

first.projtest.pdf: first1.projtest.Rout.pdf first2.projtest.Rout.pdf first3.projtest.Rout.pdf first4.projtest.Rout.pdf
	pdftk $^ cat output $@

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
-include $(ms)/perl.def
-include $(ms)/wrapR.mk
