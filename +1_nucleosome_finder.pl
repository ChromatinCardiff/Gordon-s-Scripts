#!/usr/bin/perl
# Made by Gordon Beattie, December 2014
# Script will search for sites surrounding TSSs, or other retgions of interest,
# within a user defined boundary. The output will be a list of sites that have
# a peak falling within that bondary.
# Script will take two site files, the first is intended to be a list of peak
# sites derived from the peakfinder script (NK) .sgr output (easily converted
# to a site file in excel). The second site file is the standard TSS site 
# file. 

################################################################################

use strict;
use warnings;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);

################################################################################
# SET THE VARIABLES BELOW AS REQUIRED
# $peak_file_indir_path   - The directory containing the first site file
# $site_file_indir_path   - The directory containing the second site file
# $outdir_path  - The directory to store the output file
# $outfile name  - outfile name
# $plus_1_min	- minimum distance from site to detect peak
# $plus_1_max	- maximum distance from boundary to detect peak
################################################################################

my $peak_file_indir_path ="./peak_file";
my $site_file_indir_path ="./site_file";
my $outdir_path ="./+1_nucleosome";
my $outfile_name = "SH2_150bp_t14_+1_WTsites";
my $plus_1_min = 80;
my $plus_1_max = 200;
################################################################################
################################################################################
# MAIN PROGRAM
################################################################################
################################################################################

# define some variables

my $peak_file_A;
my $site_file_B;
my $outfile; 
my @line_A;
my @line_B;
my @files_A;
my @files_B;

################################################################################
# Read in peak file A (.txt) file values to four arrays
################################################################################

# store input file name in an array
opendir(DIR,$peak_file_indir_path) || die "Unable to access file at: $peak_file_indir_path $!\n";

@files_A = readdir(DIR);

# process the input file within indir_path
foreach $peak_file_A (@files_A){    

    # ignore hidden files and only get those ending .txt
    if (($peak_file_A !~ /^\.+/) && ($peak_file_A =~ /.*\.txt/)){
        
        
print "Found, $peak_file_A \n";

open(IN, "$peak_file_indir_path/$peak_file_A")
            || die "Unable to open $$peak_file_A: $!";
        
        
             # define the arrays to store required values from infile_B
             my @A_chr; # Chromosome ID in first column
             my @A_gene_ref; # Unique gene ID
             my @A_peak; # position of peak
             my @A_strand; # Forward or reverse strand gene
             
             
	
	# loop through infile to get values
        while(<IN>){
           
           
	    chomp;

            # split line by the Tab delimiter and store elements in an array
            @line_A = split('\t',$_);
            
             # store the columns we want in the two new arrays
             push(@A_chr,$line_A[0]);
             push(@A_gene_ref,$line_A[1]);
             push(@A_peak,$line_A[2]);
             push(@A_strand,$line_A[3]);
             
          }

	# close in file handle
        close(IN);
	closedir(DIR);
        


################################################################################
# Read in the B file values to four arrays
################################################################################


opendir(DIR,$site_file_indir_path) || die "Unable to access file at: $site_file_indir_path $!\n";

@files_B = readdir(DIR);

# process the input file within indir_path
foreach $site_file_B(@files_B){    

    # ignore hidden files and only get those ending .txt
    if (($site_file_B!~ /^\.+/) && ($site_file_B=~ /.*\.txt/)){
        
       

print "and comparing to, $site_file_B\n\n";

open(IN, "$site_file_indir_path/$site_file_B")
            || die "Unable to open $site_file_B: $!";
        
        
             # define the arrays to store required values from infile_B
             my @B_chr; # Chromosome ID in first column
             my @B_gene_ref; # Unique gene ID
             my @B_TSS; # position of TSS
             my @B_strand; # Forward or reverse strand gene
             
             
	
	# loop through infile to get values
        while(<IN>){
           
           
	    chomp;

            # split line by the Tab delimiter and store elements in an array
            @line_B = split('\t',$_);
            
             # store the columns we want in the two new arrays
             push(@B_chr,$line_B[0]);
             push(@B_gene_ref,$line_B[1]);
             push(@B_TSS,$line_B[2]);
             push(@B_strand,$line_B[3]);
             
          }

        
        # close in file handle
        close(IN);



######################################################################################
# The output files
######################################################################################

# define outfile name and set ending to .txt
	$outfile = $outfile_name."_".$plus_1_min."-".$plus_1_max;
	$outfile .= '.txt';

# try and open output file
        open(OUT,"> $outdir_path/$outfile")
             || die "Unable to open $outfile: $!";       	

# store size of A and B array
        my $A_size = @A_peak;
        my $B_size = @B_chr;
        
             
             
# need some counters
        my $A_count = 0;
        my $B_count = 0;
        
# For each site, search for a peak withing the user defined region around the site,
# if a peak is found, output the enry for that site
	
	until ($B_count == $B_size){
	 until ($A_count == $A_size){
	 
	 if   (($B_chr[$B_count] eq $A_chr[$A_count]) &&
	      ($B_strand[$B_count] eq 'F') &&
	      ($A_peak[$A_count]>($B_TSS[$B_count]+$plus_1_min)) &&
	      ($A_peak[$A_count]<($B_TSS[$B_count]+$plus_1_max))
	     
	    or  ($B_chr[$B_count] eq $A_chr[$A_count]) &&
	        (($B_strand[$B_count] eq 'R')) &&
	        ($A_peak[$A_count]<($B_TSS[$B_count]-$plus_1_min)) &&
	        ($A_peak[$A_count]>($B_TSS[$B_count]-$plus_1_max)))
	     
	     {
	      	 print(OUT	$B_chr[$B_count]."\t".
				$B_gene_ref[$B_count]."\t".
				$B_TSS[$B_count]."\t".
				$B_strand[$B_count]."\n");
	      
		$A_count ++;
	      }
		      
	  else{
	
	  $A_count ++;
	
	  }
	
	}
	
	$B_count ++;
	$A_count = 0;
	
      }
      
 print "Have just created $outfile\n";
        # close out file handle
        close(OUT);
      
      }}}}
