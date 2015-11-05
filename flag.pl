my $lag = shift(@ARGV);

my $pre = "\tfoi[1] <- 1\n";

for (my $i=2;$i<=$lag;$i++){
	$pre .= "\tfoi[$i] <- ";
	my @terms;
	for (my $j=1; $j<$i;$j++){
		my $k = $i-$j;
		push @terms, "ker[$j]*cases[$k]";
	}
	$pre .= join " + ", @terms;
	$pre .= "\n";
}

my $post = $lag+1;
my $loop = "\tfor (j in $post:max) {\n\t\tfoi[j] <- ";
my @terms;
for (my $i=1; $i<$post;$i++){
	push @terms, "ker[$i]*cases[j-$i]";
}
$loop .= join " + ", @terms;
$loop .= "\n\t}\n";

my $lagloop = "\tfor (j in 1:max) {\n\t\tfoi[j] <- ";
my @lterms;
for (my $i=1; $i<$post;$i++){
	my $k = $lag-$i;
	push @lterms, "ker[$i]*cases[j+$k]";
}
$lagloop .= join " + ", @lterms;
$lagloop .= "\n\t}\n";

my (@tt, @gtt);
my $tot = "\tR0 <- "; 
my $gtot = "\tgtot <- ";

for (my $i=1; $i<$post; $i++){
	push @tt, "ker[$i]";
	push @gtt, "$i*ker[$i]";
}
$tot .= join " + ", @tt;
$gtot .= join " + ", @gtt;

while(<>){
	# Blocks
	s/\s*PRECHAIN/$pre/;
	s/\s*LOOPCHAIN/$loop/;
	s/\s*LAGCHAIN/$lagloop/;
	s/\s*TOT/$tot/;
	s/\s*GEN/$gtot/;

	# Quantities
	s/LAG/$lag/;
	print;
}
