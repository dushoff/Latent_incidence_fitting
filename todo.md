Try to improve mixing
=====================

I think this requires relying on _continuous_ latent variables; not sure how bad that is aesthetically.

This would allow us to try STAN as well as JAGS

For JAGS, I think it's also important to put the nodes for cases expected (via FOI) and unobserved cases on the same scale as observed cases (allowing the reporting ratio to change without undermining the current likelihood/LV structure). Demographic stochasticity would then have to be done backwards: calculate it on the actual scale, by dividing by RR. 

If we try to use effProp together with RR, we should have a parameter for their product, and another to partition them (probably RR = effRep^(RRprop))

It also seems important to make R0 a parameter, and to parameterize the kernel distribution

Model
========

* Reporting delay
 * backup and glitches

* Sub-boxes within a week
 * parameterizing the generation interval
 * individual heterogeneity (e.g., super-spreaders)

* Changing transmission-rates
 * time, space, incidence

* Spatial structure
 * even two or three subpopulations might help

* Use death and/or HCW
