### Latent_incidence_fitting

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: T12.NIH.compare.pdf 

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
.PRECIOUS: %/country_confirmed.csv
%/country_confirmed.csv: %/*confirmed*country*.csv
	/bin/cp $< $@

.PRECIOUS: %.scen.Rout
NIH%.scen.Rout: $(data)/NIH%/country_confirmed.csv scen.R
	$(run-R)

.PRECIOUS: T1.NIH%.scen.Rout
T1.NIH%.scen.Rout: $(data)/NIHx_timepoint_1/NIH%/country_confirmed.csv scen.R
	$(run-R)

.PRECIOUS: T2.NIH%.scen.Rout
T2.NIH%.scen.Rout: $(data)/NIHx_timepoint_2/NIH%/country_confirmed.csv scen.R
	$(run-R)

##################################################################

# het takes the R <- R0 S^α approach to changing transmission through time

.PRECIOUS: %.het.Rout
%.het.Rout: het.params.Rout %.het.params.Rout %.scen.Rout het5.autobug het.R
	$(run-R)

NIH.het.pdf: NIH1.het.Rout.pdf NIH2.het.Rout.pdf NIH3.het.Rout.pdf NIH4.het.Rout.pdf
	pdftk $^ cat output $@

OLD.het.pdf: OLD1.het.Rout.pdf OLD2.het.Rout.pdf OLD3.het.Rout.pdf OLD4.het.Rout.pdf
	pdftk $^ cat output $@

OLD.het.output: OLD2.het.Routput OLD2.het.Routput OLD3.het.Routput OLD4.het.Routput
	cat $^ > $@

##################################################################

# hybrid is meant to be like het, but more fittable, by using continuous latent variables and an artificial scale

.PRECIOUS: %.hybrid.Rout
T1.%.hybrid.Rout: hybrid1.params.Rout %.hybrid.params.Rout %.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

T2.%.hybrid.Rout: hybrid.params.Rout %.hybrid.params.Rout %.scen.Rout hybrid5.autobug hybrid.R
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
T12.%.compare.Rout: T1.%.hybrid.est.Rout T2.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

######################################################################

### Make combined pdf files

T1.NIH.%.pdf: T1.NIH1.%.Rout.pdf T1.NIH2.%.Rout.pdf T1.NIH3.%.Rout.pdf T1.NIH4.%.Rout.pdf
	$(PDFCAT)

T2.NIH.%.pdf: T2.NIH1.%.Rout.pdf T2.NIH2.%.Rout.pdf T2.NIH3.%.Rout.pdf T2.NIH4.%.Rout.pdf
	$(PDFCAT)

T12.NIH.%.pdf: T12.NIH1.%.Rout.pdf T12.NIH2.%.Rout.pdf T12.NIH3.%.Rout.pdf T12.NIH4.%.Rout.pdf
	$(PDFCAT)

T12.NIH.compare.pdf:

##################################################################

### Traceplots

%.traceplot.Rout: %.Rout traceplot.R
	$(run-R)

### Specialized parameter files are optional

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
