### Latent_incidence_fitting

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: update_data 

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
base%.autobug: base.bugtmp lagchain.pl
	$(RM) $@
	$(PUSHSTAR)
	$(READONLY)

.PRECIOUS: hybrid%.autobug
hybrid%.autobug: hybrid.bugtmp lagchain.pl
	$(RM) $@
	$(PUSHSTAR)
	$(READONLY)

.PRECIOUS: het%.autobug
het%.autobug: het.bugtmp lagchain.pl
	$(RM) $@
	$(PUSHSTAR)
	$(READONLY)

data = $(gitroot)/techtex-ebola/Data

### Don't like this rule, but I need a uniform name because of make bugs!
### This rule doesn't work on yushan either!, save the target files in the techtex repo

NIHsets: T1.NIH1.scen.Rout T1.NIH2.scen.Rout T1.NIH3.scen.Rout T1.NIH4.scen.Rout T2.NIH1.scen.Rout T2.NIH2.scen.Rout T2.NIH3.scen.Rout T2.NIH4.scen.Rout

.PRECIOUS: %/country_confirmed.csv
%/country_confirmed.csv: %/*confirmed*country*.csv
	/bin/cp $< $@

.PRECIOUS: T1.NIH%.scen.Rout
T1.NIH%.scen.Rout: $(data)/NIHx_timepoint_1/NIH%/country_confirmed.csv scen.R
	$(run-R)

.PRECIOUS: T2.NIH%.scen.Rout
T2.NIH%.scen.Rout: $(data)/NIHx_timepoint_2/NIH%/country_confirmed.csv scen.R
	$(run-R)

.PRECIOUS: T3.NIH%.scen.Rout
T3.NIH%.scen.Rout: $(data)/NIHx_timepoint_3/NIH%/country_confirmed.csv scen.R
	$(run-R)

update_data: T3.NIH1.scen.Rout T3.NIH2.scen.Rout T3.NIH3.scen.Rout T3.NIH4.scen.Rout

##################################################################

# het takes the R <- R0 S^α approach to changing transmission through time. Doesn't mix well, and it's kind of a backwater.

.PRECIOUS: %.het.Rout
%.het.Rout: het.params.Rout %.het.params.Rout %.scen.Rout het5.autobug het.R
	$(run-R)

##################################################################

# hybrid is meant to be like het, but more fittable, by using continuous latent variables and an artificial scale

.PRECIOUS: T1.%.hybrid.Rout
T1.%.hybrid.Rout: hybrid.params.Rout T1.hybrid.params.Rout T1.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

.PRECIOUS: T2.%.hybrid.Rout
T2.%.hybrid.Rout: hybrid.params.Rout T2.hybrid.params.Rout T2.%.hybrid.params.Rout T2.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

.PRECIOUS: T3.%.hybrid.Rout
T3.%.hybrid.Rout: hybrid.params.Rout T3.hybrid.params.Rout T3.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

##################################################################

### Calculate estimation quantiles

%.est.Rout: %.Rout quantiles.R
	$(run-R)

##################################################################

### Look at projections 

.PRECIOUS: %.project.Rout
%.project.Rout: %.hybrid.est.Rout forecastPlot.Rout project.R
	$(run-R)

##################################################################

### Compare projections with new data
.PRECIOUS: T12.%.compare.Rout
T12.%.compare.Rout: T1.%.hybrid.est.Rout T2.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

### Compare projections with new data
.PRECIOUS: T23.%.compare.Rout
T23.%.compare.Rout: T2.%.hybrid.est.Rout T3.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

######################################################################

### Make combined pdf files (not precious, is that a problem?)

T1.NIH.%.pdf: T1.NIH1.%.Rout.pdf T1.NIH2.%.Rout.pdf T1.NIH3.%.Rout.pdf T1.NIH4.%.Rout.pdf
	$(PDFCAT)

T2.NIH.%.pdf: T2.NIH1.%.Rout.pdf T2.NIH2.%.Rout.pdf T2.NIH3.%.Rout.pdf T2.NIH4.%.Rout.pdf
	$(PDFCAT)

T3.NIH.%.pdf: T3.NIH1.%.Rout.pdf T3.NIH2.%.Rout.pdf T3.NIH3.%.Rout.pdf T3.NIH4.%.Rout.pdf
	$(PDFCAT)

T12.NIH.%.pdf: T12.NIH1.%.Rout.pdf T12.NIH2.%.Rout.pdf T12.NIH3.%.Rout.pdf T12.NIH4.%.Rout.pdf
	$(PDFCAT)

T23.NIH.%.pdf: T23.NIH1.%.Rout.pdf T23.NIH2.%.Rout.pdf T23.NIH3.%.Rout.pdf T23.NIH4.%.Rout.pdf
	$(PDFCAT)

##################################################################

### Traceplots

%.traceplot.Rout: %.Rout traceplot.R
	$(run-R)

### Parameter files are optional

%.params.R:
	touch $@

### Makestuff

## Change this name to download a new version of the makestuff directory
Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
-include $(ms)/perl.def
-include $(ms)/wrapR.mk
