### Latent_incidence_fitting
### Original Ebola challenge directory

## Target
current: target
-include target.mk

##################################################################

# make files
Sources = Makefile README.md LICENSE.md
Ignore += .gitignore 
-include $(ms)/os.mk

######################################################################

Drop = ~/Dropbox/Latent_incidence_fitting/

## Makestuff setup
Sources += Makefile 
msrepo = https://github.com/dushoff
ms = makestuff
-include $(ms)/os.mk

Ignore += $(ms)
Makefile: $(ms)/Makefile
$(ms)/Makefile:
	git clone $(msrepo)/$(ms)
	ls $@

######################################################################

### Stuff that belongs in makestuff, but we don't want to make people download t again now
READONLY = chmod a-w $@
PDFCAT = pdftk $(filter %.pdf, $^)  cat output $@
PDFFRONT = pdftk $<  cat 1 output $@
CAT = cat $^ > $@

##################################################################

# Discussion

Sources += todo.md notes.md

######################################################################

# Files to put in github

Sources += $(wildcard *.R)
Sources += $(wildcard *.pl)
Sources += $(wildcard *.bug)
Sources += $(wildcard *.bugtmp)

##################################################################

# Make .bug scripts with generation lags from templates

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

.PRECIOUS: hi%.autobug
hi%.autobug: hi.bugtmp lagchain.pl
	$(RM) $@
	$(PUSHSTAR)
	$(READONLY)


##################################################################

### Pre-process data files from contest organizers

data = $(gitroot)/techtex-ebola/Data

### Don't like this rule, but I need a uniform name because of make bugs!

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

.PRECIOUS: T4.NIH%.scen.Rout
T4.NIH%.scen.Rout: $(data)/NIHx_timepoint_4/NIH%/country_confirmed.csv scen.R
	$(run-R)

.PRECIOUS: T5.NIH%.scen.Rout
T5.NIH%.scen.Rout: $(data)/NIHx_timepoint_5/NIH%/country_confirmed.csv scen.R
	$(run-R)

update_data: T5.NIH1.scen.Rout T5.NIH2.scen.Rout T5.NIH3.scen.Rout T5.NIH4.scen.Rout

##################################################################

# Process the intervention files that we make

$(data)/%/interventions.Rout:
	cd $(data) && $(MAKE) $*/interventions.Rout

.PRECIOUS: T2.NIH%.int.Rout
T2.NIH%.int.Rout: $(data)/NIHx_timepoint_2/NIH%/interventions.Rout int.R
	$(run-R)

.PRECIOUS: T3.NIH%.int.Rout
T3.NIH%.int.Rout: $(data)/NIHx_timepoint_3/NIH%/interventions.Rout int.R
	$(run-R)

.PRECIOUS: T4.NIH%.int.Rout
T4.NIH%.int.Rout: $(data)/NIHx_timepoint_4/NIH%/interventions.Rout int.R
	$(run-R)

.PRECIOUS: T5.NIH%.int.Rout
T5.NIH%.int.Rout: $(data)/NIHx_timepoint_5/NIH%/interventions.Rout int.R
	$(run-R)

##################################################################

# The first attempt at fitting
# Uses effective population sizes and phenomenological heterogeneity
# ie., R <- R0 S^α approach.
# Doesn't mix well, we think because changing reporting ratio throws
# all the other parameters "off the cliff"

.PRECIOUS: %.het.Rout
%.het.Rout: het.params.Rout %.het.params.Rout %.scen.Rout het5.autobug het.R
	$(run-R)

##################################################################

# The second attempt
# hybrid is like het, but mixes better
# It uses continuous latent variables to put values on the same scale

.PRECIOUS: T1.%.hybrid.Rout
T1.%.hybrid.Rout: hybrid.params.Rout T1.hybrid.params.Rout T1.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

.PRECIOUS: T2.%.hybrid.Rout
T2.%.hybrid.Rout: hybrid.params.Rout T2.hybrid.params.Rout T2.%.hybrid.params.Rout T2.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

.PRECIOUS: T3.%.hybrid.Rout
T3.%.hybrid.Rout: hybrid.params.Rout T3.hybrid.params.Rout T3.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

.PRECIOUS: T4.%.hybrid.Rout
T4.%.hybrid.Rout: hybrid.params.Rout T4.hybrid.params.Rout T4.%.scen.Rout hybrid5.autobug hybrid.R
	$(run-R)

##################################################################

# We now have a "testing" pathway with shorter runs done locally
# and a somewhat complicated main pathway that involves setting a variable called curr to point a local machine at fits done on a server.

BRANCH = $(shell cat .git/HEAD | perl -npE "s|.*/||;")
COMMIT = $(shell cat .git/refs/heads/$(BRANCH) | perl -npE 's/(.{8}).*/$$1/;')
export HOSTNAME

out = $(Drop)/$(COMMIT)_$(HOSTNAME)

Makefile: $(out)
outdir: $(out)
$(out):
	mkdir $@

curr = $(wildcard $(Drop)/*-n04)
curr = $(out)

######################################################################

# hi represents hybrid with interventions. 

.PRECIOUS: T4test.%.hi.Rout
T4test.%.hi.Rout: hi.params.Rout test.params.Rout T4.hi.params.Rout T4.%.hi.params.Rout T4.%.scen.Rout T4.%.int.Rout hi5.autobug hi.R
	$(run-R)

.PRECIOUS: T5test.%.hi.Rout
T5test.%.hi.Rout: hi.params.Rout test.params.Rout T5.hi.params.Rout T5.%.hi.params.Rout T5.%.scen.Rout T5.%.int.Rout hi5.autobug hi.R
	$(run-R)

#### The main pathway sends outputs to Dropbox folders labelled by commit and hostname. These are not well managed yet.

.PRECIOUS: $(out)/T5.%.hi.Rout
$(out)/T5.%.hi.Rout: hi.params.Rout T5.hi.params.Rout T5.%.hi.params.Rout T5.%.scen.Rout T5.%.int.Rout hi5.autobug hi.R
	$(run-R)

.PRECIOUS: $(out)/T4.%.hi.Rout
$(out)/T4.%.hi.Rout: hi.params.Rout T4.hi.params.Rout T4.%.hi.params.Rout T4.%.scen.Rout T4.%.int.Rout hi5.autobug hi.R
	$(run-R)

##################################################################

### Parameter files are optional
### We have a lot of places to add parameters in the make rules; most of them are not actually used

%.params.R:
	touch $@

##################################################################

### Traceplots

%.traceplot.Rout: %.Rout traceplot.R
	$(run-R)

### Front page of a fitting pdf

%.front.Rout.pdf: $(curr)/%.Rout.pdf
	$(PDFFRONT)

##################################################################

### Calculate estimation quantiles for output to NIH

T5.NIH.hi.est.out: est.R

.PRECIOUS: %.est.Rout
%.est.Rout: $(curr)/%.Rout est.R
	$(run-R)

### Special low estimates for T4, based on DC's observations
.PRECIOUS: %.lowEst.Rout
%.lowEst.Rout: $(curr)/%.Rout lowEst.R
	$(run-R)

.PRECIOUS: %.low.hi.est.Rout
%.low.hi.est.Rout: %.hi.lowEst.Rout
	$(run-R)

# Report parameters in spreadsheet-friendly form
.PRECIOUS: %.paramEsts.Rout
%.paramEsts.Rout: %.hi.est.Rout paramEsts.R
	$(run-R)

# Report peak incidence estimates spreadsheet-friendly form
# Also added lastWeek to this, because of spreadsheet layout
.PRECIOUS: %.peakWeek.Rout
%.peakWeek.Rout: %.hi.est.Rout peakWeek.R
	$(run-R)

# Report incidence estimates in spreadsheet-friendly form
.PRECIOUS: %.incidence.Rout
%.incidence.Rout: %.hi.est.Rout incidence.R
	$(run-R)

##################################################################

### Look at projections 

.PRECIOUS: %.project.Rout
%.project.Rout: %.hybrid.est.Rout forecastPlot.Rout project.R
	$(run-R)

.PRECIOUS: %.hip.Rout
%.hip.Rout: %.hi.est.Rout forecastPlot.Rout project.R
	$(run-R)

##################################################################

### Compare projections with new data
.PRECIOUS: T12.%.compare.Rout
T12.%.compare.Rout: T1.%.hybrid.est.Rout T2.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

.PRECIOUS: T23.%.compare.Rout
T23.%.compare.Rout: T2.%.hi.est.Rout T3.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

.PRECIOUS: T34.%.compare.Rout
T34.%.compare.Rout: T3.%.hi.est.Rout T4.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

.PRECIOUS: T45.%.compare.Rout
T45.%.compare.Rout: T4.%.hi.est.Rout T5.%.scen.Rout forecastPlot.Rout compare.R
	$(run-R)

T45.NIH1.compare.Rout:

T45.NIH.compare.pdf:

######################################################################

### Make combined pdf files 

### Main things right now are Tx.hybrid.NIH.pdf (2000 pp., look at Rhats); Tx.project.NIH.pdf

T1.NIH.%.pdf: T1.NIH1.%.Rout.pdf T1.NIH2.%.Rout.pdf T1.NIH3.%.Rout.pdf T1.NIH4.%.Rout.pdf
	$(PDFCAT)

T2.NIH.%.pdf: T2.NIH1.%.Rout.pdf T2.NIH2.%.Rout.pdf T2.NIH3.%.Rout.pdf T2.NIH4.%.Rout.pdf
	$(PDFCAT)

T3.NIH.%.pdf: T3.NIH1.%.Rout.pdf T3.NIH2.%.Rout.pdf T3.NIH3.%.Rout.pdf T3.NIH4.%.Rout.pdf
	$(PDFCAT)

T4.NIH.%.pdf: T4.NIH1.%.Rout.pdf T4.NIH2.%.Rout.pdf T4.NIH3.%.Rout.pdf T4.NIH4.%.Rout.pdf
	$(PDFCAT)

T4.NIH.%.out: T4.NIH1.%.Rout T4.NIH2.%.Rout T4.NIH3.%.Rout T4.NIH4.%.Rout
	$(CAT)

T5.NIH.%.pdf: T5.NIH1.%.Rout.pdf T5.NIH2.%.Rout.pdf T5.NIH3.%.Rout.pdf T5.NIH4.%.Rout.pdf
	$(PDFCAT)

T5.NIH.%.out: T5.NIH1.%.Rout T5.NIH2.%.Rout T5.NIH3.%.Rout T5.NIH4.%.Rout
	$(CAT)

T12.NIH.%.pdf: T12.NIH1.%.Rout.pdf T12.NIH2.%.Rout.pdf T12.NIH3.%.Rout.pdf T12.NIH4.%.Rout.pdf
	$(PDFCAT)

T23.NIH.%.pdf: T23.NIH1.%.Rout.pdf T23.NIH2.%.Rout.pdf T23.NIH3.%.Rout.pdf T23.NIH4.%.Rout.pdf
	$(PDFCAT)

T34.NIH.%.pdf: T34.NIH1.%.Rout.pdf T34.NIH2.%.Rout.pdf T34.NIH3.%.Rout.pdf T34.NIH4.%.Rout.pdf
	$(PDFCAT)

T45.NIH.%.pdf: T45.NIH1.%.Rout.pdf T45.NIH2.%.Rout.pdf T45.NIH3.%.Rout.pdf T45.NIH4.%.Rout.pdf
	$(PDFCAT)

##################################################################

T5test.%.stanhi.Rout: hi.params.Rout test.params.Rout T5.hi.params.Rout T5.%.hi.params.Rout T5.%.scen.Rout T5.%.int.Rout hi5.stan mikehi5stan.R
	$(run-R)

%.stanest.Rout: %.Rout stanest.R
	$(run-R)
	
%.stanhip.Rout: %.stanhi.stanest.Rout forecastPlot.Rout project.R
	$(run-R)

T5test.%.mikehi.Rout: hi.params.Rout test.params.Rout T5.hi.params.Rout T5.%.hi.params.Rout T5.%.scen.Rout T5.%.int.Rout mikehi5.bug mikehi5.R
	$(run-R)
	
crazy.Rout: T5test.NIH4.mikehi.Rout forecast.R
	$(run-R)

%.mikeest.Rout: %.Rout mikeest.R
	$(run-R)
	
%.hip.Rout: %.mikeest.Rout forecastPlot.Rout project.R
	$(run-R)


########

## And combined .csv files

T3.NIH.%.csv: T3.NIH1.%.Rout.csv T3.NIH2.%.Rout.csv T3.NIH3.%.Rout.csv T3.NIH4.%.Rout.csv
	$(CAT)

T4.NIH.%.csv: T4.NIH1.%.Rout.csv T4.NIH2.%.Rout.csv T4.NIH3.%.Rout.csv T4.NIH4.%.Rout.csv
	$(CAT)

.PRECIOUS: T5.NIH.%.csv
T5.NIH.%.csv: T5.NIH1.%.Rout.csv T5.NIH2.%.Rout.csv T5.NIH3.%.Rout.csv T5.NIH4.%.Rout.csv
	$(CAT)

##################################################################

# Submission archive (started very late; mostly this track wasn't used for submissions anyway)

Submission4 = T4.NIH.hip.pdf T4.NIH.peakWeek.csv T4.NIH.incidence.csv T4.NIH.params.csv 

Submission4.tgz: $(Submission4)
	$(TGZ)

Archive += Submission4.3.tgz
Submission4.3 = T4.NIH3.low.peakWeek.Rout.csv T4.NIH3.low.incidence.Rout.csv T4.NIH3.low.params.Rout.csv

Submission4.3.tgz: $(Submission4.3)
	$(TGZ)

Archive += Submission5.tgz
# /home/dushoff/git/Latent_incidence_fitting/T5.NIH.peakWeek.csv
Submission5 = T5.NIH.hip.pdf T5.NIH.peakWeek.csv T5.NIH.incidence.csv T5.NIH.paramEsts.csv 

Submission5.tgz: $(Submission5)
	$(TGZ)

### Makestuff

## Change this name to download a new version of the makestuff directory
Makefile: 

-include $(ms)/git.mk
-include $(ms)/visual.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
-include $(ms)/perl.def
-include $(ms)/wrapR.mk
