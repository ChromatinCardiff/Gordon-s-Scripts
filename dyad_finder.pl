#!/usr/bin/perl

# Written by Gordon Beattie June 2015

# Script takes out put from Nick's chrgrep.sh script (i.e. the .sam file divided
# into chromosomes) and outputs a three column .txt containng chromosome of the
# read, read dyad position, and length of the read
################################################################################

use strict;
use warnings;
use List::Util qw(max);
use Math::Round;

################################################################################
# SET THE VARIABLES BELOW AS REQUIRED
# $indir_path   - The directory containing the .sgr file(s) to be processed
# $outdir_path  - The directory to store the .sgr peak output files
# $outfile_name - The suffix to your output .sgr file
# $chr_ID	- The ID of the chromosome you want scaled in your .sgr
# $scale_factor - The factor by which the read numbers for that chromosome are
# multiplied
################################################################################
my $inA_indir_path ="./chr_grep_out";
my $outdir_path ="./chr_dyad_out";
my $outfile_name = "dyads";
################################################################################
################################################################################
# MAIN PROGRAM
################################################################################
################################################################################

# define some variables

my $infile_A;
my @line_A;
my @files_A;
my $size_A;
my $outfile; 
my $data_class;

################################################################################
# Read in the A file values to four arrays
################################################################################

# store input file name in an array
opendir(DIR,$inA_indir_path) || die "Unable to access file at: $inA_indir_path $!\n";

@files_A = readdir(DIR);

# process the input file within indir_path
foreach $infile_A (@files_A){    

    # ignore hidden files and only get those ending .sgr
    if (($infile_A !~ /^\.+/) && ($infile_A =~ /.*\.txt/)){
        
        
print "Found, and processing, $infile_A \n";

open(IN, "$inA_indir_path/$infile_A")
            || die "Unable to open $infile_A: $!";
            
            
             # define the arrays to store required values from infile_A
             my @A_flag; # SAM flag
             my @A_chr; # Chromosome ID 
             my @A_pos_left; # left position of read
             my @A_pos_right; # right position of read
             my @A_read_length; # read length
             
             
	
	# loop through infile to get values
        while(<IN>){
           
           
	    chomp;

            # split line by the Tab delimiter and store elements in an array
            @line_A = split('\t',$_);
            
             # store the columns we want in the two new arrays
             push(@A_flag,$line_A[1]);
             push(@A_chr,$line_A[2]);
             push(@A_pos_left,$line_A[3]);
             push(@A_pos_right,$line_A[7]);
             push(@A_read_length,$line_A[8]);
             
          }

	# close in file handle
        close(IN);
	closedir(DIR);

	
######################################################################################
# The output files
######################################################################################

# define outfile name and set ending to .txt
	$outfile = substr($infile_A,0,-4)."_".$outfile_name;
	$outfile .= '.txt';

	
# store size of array
        my $size = @A_flag;
	
	
# try and open output file
        open(OUT,"> $outdir_path/$outfile")
             || die "Unable to open $outfile: $!";             
             
             
# need a variable to store line count
        my $count = 0;
        my $dyad;
        
        # scale the desired chromosome by user defined scale factor
        
        
        while ($count < $size){
        
        if ($A_flag[$count] eq '99' or $A_flag[$count] eq '163')
        
	  {
	     $dyad = round(($A_pos_left[$count]+$A_pos_right[$count])/2);
		    
	   print(OUT	"chr".$A_chr[$count]."\t".
			$dyad."\t".
			$A_read_length[$count]."\n");
			
			 $count++;
	  
	  }
	  
        else
	  
	  {
	  
	  
	  $count++;
	  
	  }}
	  # close the file handle
	  close(OUT);
    }
}
