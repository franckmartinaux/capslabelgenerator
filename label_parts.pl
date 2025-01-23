#!/usr/bin/perl

# Copyright (c) 2015 Capsule Technologiues (Pty) Ltd. All rights reserved.
# Version 0.1 - 05 Apr 2015 - Initial code on Easter Week-end
# Version 0.2 - 06 Apr 2015 - Better parsing of the options
# Version 0.3 - 06 Apr 2015 - Adaptation for small labels for parts
# Version 0.4 - 24 Apr 2015 - Adapt margin in X for Epson
# Designed for "Tower Mailing labels W108 38.1mm x 63.5mm 21 per A4 Sheet

use strict;
use Getopt::Long;

my $version="0.3";
my $opt_version;
my $opt_pn;
my $opt_help;

my $yref=842;
my $xref=0;
my $ystick;

#my $ymargin_mm=16;
my $ymargin_mm=11;  # was 8
my $xmargin_mm=3;
#my $xmargin_mm=7;

# Features : We want to build a Label based on the P/N

my $logo_file="label_Capsule_logo_BW_small_label_450dpi.eps";



# Here is the list of attributes
# pn : P/N of the good

&usage() if (!@ARGV);

GetOptions ('v|version' => \$opt_version,
	'pn=s' => \$opt_pn,
	'help' => \$opt_help);

if ($opt_version)
	{
	print "label_parts Version $version \n";
	print "Tool to make labels in PS format for Parts \n";
	print "\n Author : Franck Martinaux, franck\@capsule-sa.co.za \n\n";
	print &convert_px(2);	
	exit;
	}

$yref=$yref-&convert_px($ymargin_mm);
$xref=$xref+&convert_px($xmargin_mm);

if ($opt_help)
	{
	&usage();
	}

if (!$opt_pn) { &usage(); }



&print_head();
my $nb_label=0;
$ystick=$yref;
while ($nb_label < 7)
{
&print_logo();
&print_pn();
$yref=$yref-&convert_px(40); # WAS 38.1

$nb_label++;
}

$nb_label=0;
$yref=$ystick;
$xref=$xref+&convert_px(70); # Was 66
while ($nb_label < 7)
{
&print_logo();
&print_pn();
$yref=$yref-&convert_px(40);

$nb_label++;
}

$nb_label=0;
$yref=$ystick;
$xref=$xref+&convert_px(70); # Was 66
while ($nb_label < 7)
{
&print_logo();
&print_pn();
$yref=$yref-&convert_px(40);

$nb_label++;
}





&print_tail();

################################################################################
sub usage {
print "label_parts Version $version \n";
print "Tool to make labels in PS format for individual parts \n";
print "\nAuthor : Franck Martinaux, franck\@capsule-sa.co.za \n\n";
print "Usage: label_parts.pl -pn <PN_id> \n";
print "\nExample : /label_parts.pl -pn 4k8-3T6TX3UI >mylabel.ps\n";
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
my $logo_y=$yref-48;
my $logo_x=$xref+10;
print "gsave\n";
print "$logo_x $logo_y translate\n";
print `cat $logo_file`;
print "\ngrestore\n";

}
################################################################################
sub print_pn {
my $pn_y=$yref-110;
my $pn_x=$xref+0;
print "gsave \n";
print `barcode -b "PN: $opt_pn" -g 170x50+$pn_x+$pn_y -E`;
print "grestore \n";
}
################################################################################
sub convert_px {
# Convert ratio between mm to points
my $ratio=842/297;
my $pix=$ratio*$_[0];

return int($pix);
}
################################################################################
