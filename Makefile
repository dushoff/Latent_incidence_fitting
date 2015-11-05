### Latent_incidence_fitting

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: obs5.Rout 

##################################################################


# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk

##################################################################

### Flow

Sources += $(wildcard *.R)
Sources += $(wildcard *.pl)
Sources += $(wildcard *.bug)

obs%.autobug: obs.bug flag.pl
	$(PUSHSTAR)

discrete_obs.Rout: discrete_sim.Rout discrete_obs.R

obs5.Rout: obs%.Rout: i1000.Rout discrete_obs.Rout obs%.autobug obs.R
	$(run-R)

test.Rout: i1000.Rout

######################################################################

### Crib

crib = /home/dushoff/Dropbox/academicWW/Bugs_example/

.PRECIOUS: %.pl %.R
%.pl %.R:
	$(ccrib)

obs.bug: 
	$(ccrib)

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
