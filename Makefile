### Latent_incidence_fitting

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: first.projtest.pdf 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk

##################################################################

### Flow

Sources += $(wildcard *.R)
Sources += $(wildcard *.pl)
Sources += $(wildcard *.bug)

.PRECIOUS: obs%.autobug
obs%.autobug: obs.bug flag.pl
	$(PUSHSTAR)

data = $(gitroot)/techtex-ebola/Data

.PRECIOUS: %.scen.Rout
NIH%.scen.Rout: $(data)/NIH%/*confirmed*country*.csv scen.R
	$(run-R)

.PRECIOUS: OLD%.scen.Rout
OLD%.scen.Rout: $(data)/NIHx_timepoint_1/NIH%/*confirmed*country*.csv scen.R
	$(run-R)

NIH1.base.Rout: base.R

.PRECIOUS: %.base.Rout
%.base.Rout: i5000.Rout %.scen.Rout obs5.autobug base.R
	$(run-R)

NIH.base.pdf: NIH1.base.Rout.pdf NIH2.base.Rout.pdf NIH3.base.Rout.pdf NIH4.base.Rout.pdf
	pdftk $^ cat output $@

OLD.base.pdf: OLD1.base.Rout.pdf OLD2.base.Rout.pdf OLD3.base.Rout.pdf OLD4.base.Rout.pdf
	pdftk $^ cat output $@

OLD.base.output: OLD2.base.Routput OLD2.base.Routput OLD3.base.Routput OLD4.base.Routput
	cat $^ > $@

### Not implemented; something to combine projections from different scenarios

OLD.projections.Rout: OLD1.base.Rout.envir OLD2.base.Rout.envir OLD3.base.Rout.envir OLD4.base.Rout.envir scenario_project.R
	$(run-R)

### Look at old projections with new data

.PRECIOUS: first%.projtest.Rout
first%.projtest.Rout: OLD%.base.Rout NIH%.scen.Rout projtest.R
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
include $(ms)/perl.def
include $(ms)/wrapR.mk
