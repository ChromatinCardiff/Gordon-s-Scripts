#!/usr/bin/perl

# Written by Gordon Beattie 17th Sept 2014
# This script aims to produce a list of paired genes which could be classified
# as "divergent", based on having a TSSs which initiate transcription in
# opposite directions. For each gene pair the midpoint between the TSSs is 
# also calculated.
# This script takes a .txt file which is layed out in a format identical to
# the "Site" file used in Nick Kents Site_writer*.pl scripts (i.e. four tab
# delimited columns containing chromosome ID, gene reference, transcriptional
# start site position and strand direction respectively). Entries to this file
# MUST be ordered by chromosome and TSS position.
# The max_dist and min_dist variables define how far two TSSs are allowed/need 
# to be apart for them to be called "divergent", this is a very subjective
# parameter, but it is useful if having the TSSs too far or close to one another
# obscures downstream analysis in some way.
################################################################################

use strict;
use warnings;
use List::Util qw(max);
use Math::Round;

################################################################################
# SET THE VARIABLES BELOW AS REQUIRED
# $indir_path   - The directory containing the .txt site files to be processed
# $outdir_path  - The directory to store the .txt output files
# $outfile_name - Whatever you want to name the output .txt file
# $max_dist     - TSSs further apart than this will not be included in the output
# $min_dist     - TSSs closer together than this won't be included either
################################################################################
my $inA_indir_path ="./in";
my $outdir_path ="./out";
my $outfile_name = "Divergent_genes_mid_points";
my $max_dist = 1000;
my $min_dist = 900;

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

################################################################################
# Read in the A file values to four arrays
################################################################################

# store input file name in an array
opendir(DIR,$inA_indir_path) || die "Unable to access file at: $inA_indir_path $!\n";

@files_A = readdir(DIR);

# process the input file within indir_path
foreach $infile_A (@files_A){    

    # ignore hidden files and only get those ending .txt
    if (($infile_A !~ /^\.+/) && ($infile_A =~ /.*\.txt/)){
        
        
print "Found, and processing, $infile_A \n";

open(IN, "$inA_indir_path/$infile_A")
            || die "Unable to open $infile_A: $!";
            
            
             # define the arrays to store required values from infile_A
             my @A_chr; # Chromosome ID in first column
             my @A_gene_ref; # Unique gene ID
             my @A_TSS; # position of TSS
             my @A_strand; # Forward or reverse strand gene
             
             
	
	# loop through infile to get values
        while(<IN>){
           
           
	    chomp;

            # split line by the Tab delimiter and store elements in an array
            @line_A = split('\t',$_);
            
             # store the columns we want in the two new arrays
             push(@A_chr,$line_A[0]);
             push(@A_gene_ref,$line_A[1]);
             push(@A_TSS,$line_A[2]);
             push(@A_strand,$line_A[3]);
             
          }

	# close in file handle
        close(IN);
	closedir(DIR);

	
######################################################################################
# The output files
######################################################################################

# define outfile name and set ending to .txt
	$outfile = $outfile_name."_".$infile_A."_".$min_dist."_".$max_dist;
	$outfile .= '.txt';

	
# store size of array
        my $size = @A_TSS;
	
	
# try and open output file
        open(OUT,"> $outdir_path/$outfile")
             || die "Unable to open $outfile: $!";             
             
             
# need a variable to store line count
        my $count = 0;
        my $thing;
        
        # This determines whether a pair of genes are "divergent" based on whether
        # they are transcribed in opposite directions, and their TSSs are within a
        # user defined boundary
        
        
        while ($count < $size){
        
        if (($A_strand[$count] eq 'R') &&
	      ($A_strand[$count+1] eq 'F') &&
		 ($A_TSS[$count+1]-$A_TSS[$count]>=$min_dist) &&
		    ($A_TSS[$count+1]-$A_TSS[$count]<=$max_dist)){
		    
		    $thing = round(($A_TSS[$count]+$A_TSS[$count+1])/2);
		    
	  print(OUT	$A_chr[$count]."\t".
			$A_gene_ref[$count]."_".$A_gene_ref[$count+1]."\t".
			$thing."\t"."F"."\n");
			
	  $count++;
	  
	  }else{
	  $count++;
	  
	  }}
	  # close the file handle
	  close(OUT);
    }
}
