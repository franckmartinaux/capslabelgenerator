#!/usr/bin/perl

# Copyright (c) 2015 Capsule Technologiues (Pty) Ltd. All rights reserved.
# Version 0.1 - 05 Apr 2015 - Initial code on Easter Week-end
# Version 0.2 - 06 Apr 2015 - Better parsing of the options
# Version 0.3 - 24 Apr 2015 - Adaptation to print only P/N and S/N of systems
# Version 0.4 - 26 Jul 2022 - Adapted to Europe100 ELA036 8 per pages
# Designed for Meeco LLG004 A4 93.1x99 6 per Pages

use strict;
use Getopt::Long;

my $version="0.4";
my $opt_version;
my $opt_pn;
my $opt_sn;
my $opt_help;
my $opt_nb;

my $yref=842;
my $xref=0;

my $ymargin_mm=13;
my $xmargin_mm=8;

my $sn_x;
my $sn_y;
my $nb_sn;
my @list_sn;

# Features : We want to build a Label based on the P/N and S/N

my $logo_file="label_Capsule_logo_BW_largelabel_450dpi.eps";



# Here is the list of attributes
# pn : P/N of the good
# sn : List the S/N seperated by a coma
# nb : NB labels

&usage() if (!@ARGV);

GetOptions ('v|version' => \$opt_version,
	'pn=s' => \$opt_pn,
	'sn=s' => \$opt_sn,
	'nb=s' => \$opt_nb,
	'help' => \$opt_help);

if ($opt_version)
	{
	print "label_pn_sn Version $version \n";
	print "Tool to make labels in PS format for Final product \n";
	print "\n Author : Franck Martinaux, franck\@capsule-sa.co.za \n\n";
	print &convert_px(94);	
	exit;
	}

$yref=$yref-&convert_px($ymargin_mm);
$xref=$xref+&convert_px($xmargin_mm);

if ($opt_help)
	{
	&usage();
	}

if (!$opt_pn) { &usage(); }
if (!$opt_sn) { &usage(); }
if (!$opt_nb) { &usage(); }


@list_sn=split(/,/,$opt_sn);

&print_head();
my $nb_label=0;

while ($nb_label < $opt_nb)
{
&print_logo();
# &print_po();
&print_pn();
# &print_qty();
$sn_x=$xref+0;
$sn_y=$yref-195;
$nb_sn=0;
foreach (@list_sn)
	{
	if ($nb_sn>3) {$sn_y=$yref-190; $sn_x=$xref+90; $nb_sn=0}
	&print_sn($_);
	$nb_sn++;
	}

# $yref=$yref-&convert_px(94);
$yref=$yref-&convert_px(70);
$nb_label++;
}


&print_tail();

################################################################################
sub usage {
print "label_pack Version $version \n";
print "Tool to make labels in PS format for Packing list \n";
print "\nAuthor : Franck Martinaux, franck\@capsule-sa.co.za \n\n";
print "Usage: label_pn_sn.pl -pn <PN_id> -sn <serialnumber> -nb <number of labels>\n";
print "\nExample : /label_pack.pl -sn Z500TNNY -pn 4k8-3T6TX3UI -nb 3 >mylabel.ps\n";
exit;

}
################################################################################
sub print_head {
my @header_file=`cat label_header.ps`;
foreach (@header_file)
	{
	print $_;
	}
}
################################################################################
sub print_tail {
print "showpage \n\%\%Trailer\n";
}
################################################################################
sub print_logo {
my $logo_y=$yref-70;
my $logo_x=$xref+0;
print "gsave\n";
print "$logo_x $logo_y translate\n";
print `cat $logo_file`;
print "\ngrestore\n";

}
################################################################################
sub print_font {
print "/Helvetica findfont\n";
print "12 scalefont\n";
print "setfont\n";
print "newpath\n";
print "113 100 moveto\n";
print "(This is a Example) show\n";

}
################################################################################
sub print_pn {
# my $pn_y=$yref-165;
my $pn_y=$yref-150;
my $pn_x=$xref+0;
print "gsave \n";
# print `barcode -b "PN: $opt_pn" -g 180x35+$pn_x+$pn_y -E`;
print `barcode -b "PN: $opt_pn" -g 230x35+$pn_x+$pn_y -E`;
print "grestore \n";
}
################################################################################
sub print_sn {

print "gsave \n";
# print `barcode -b "SN: $_[0]" -g 80x15+$sn_x+$sn_y -E`;
print `barcode -b "SN: $_[0]" -g 215x35+$sn_x+$sn_y -E`;
print "grestore \n";
# $sn_y=$sn_y-20;

}
################################################################################
sub convert_px {
# Convert ratio between mm to points
my $ratio=842/297;
my $pix=$ratio*$_[0];

return int($pix);
}
################################################################################
