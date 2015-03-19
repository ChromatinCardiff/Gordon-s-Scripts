#!/usr/bin/perl
# Made by Gordon Beattie, October 2014
# Script will take two site files and output genes that are common to both in 
# the standard site file format. No fancy file naming here, change outfile
# name for every comparison

################################################################################

use strict;
use warnings;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);

################################################################################
# SET THE VARIABLES BELOW AS REQUIRED
# $cluster_A_indir_path   - The directory containing the first site file
# $cluster_B_indir_path   - The directory containing the second site file
# $outdir_path  - The directory to store the output file
# $outfile name  - outfile name
################################################################################

my $cluster_A_indir_path ="./cluster_in/file_A";
my $cluster_B_indir_path ="./cluster_in/file_B";
my $outdir_path ="./common_genes_out";
my $outfile_name = "WTSC_150bp_C6_SH2_150bp_C6_common_genes";
################################################################################
################################################################################
# MAIN PROGRAM
################################################################################
################################################################################

# define some variables

my $cluster_file_A;
my $cluster_file_B;
my $outfile; 
my @line_A;
my @line_B;
my @files_A;
my @files_B;

################################################################################
# Read in cluster file A (.txt) file values to two arrays
################################################################################

# store input file name in an array
opendir(DIR,$cluster_A_indir_path) || die "Unable to access file at: $cluster_A_indir_path $!\n";

@files_A = readdir(DIR);

# process the input file within indir_path
foreach $cluster_file_A (@files_A){    

    # ignore hidden files and only get those ending .txt
    if (($cluster_file_A !~ /^\.+/) && ($cluster_file_A =~ /.*\.txt/)){
        
        
print "Found, $cluster_file_A \n";

open(IN, "$cluster_A_indir_path/$cluster_file_A")
            || die "Unable to open $$cluster_file_A: $!";
        
        
             # define the arrays to store required values from infile_B
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
        


################################################################################
# Read in the B file values to four arrays
################################################################################


opendir(DIR,$cluster_B_indir_path) || die "Unable to access file at: $cluster_B_indir_path $!\n";

@files_B = readdir(DIR);

# process the input file within indir_path
foreach $cluster_file_B(@files_B){    

    # ignore hidden files and only get those ending .txt
    if (($cluster_file_B!~ /^\.+/) && ($cluster_file_B=~ /.*\.txt/)){
        
       

print "and comparing to, $cluster_file_B\n\n";

open(IN, "$cluster_B_indir_path/$cluster_file_B")
            || die "Unable to open $cluster_file_B: $!";
        
        
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
	$outfile = $outfile_name;
	$outfile .= '.txt';

# try and open output file
        open(OUT,"> $outdir_path/$outfile")
             || die "Unable to open $outfile: $!";       	

# store size of A and B array
        my $A_size = @A_TSS;
        my $B_size = @B_TSS;
        
             
             
# need some counters
        my $A_count = 0;
        my $B_count = 0;
	
	until ($A_count == $A_size){
	 until ($B_count == $B_size){
	 
	 if (($A_gene_ref[$A_count] eq $B_gene_ref[$B_count]))
	      {
	      	 print(OUT	$A_chr[$A_count]."\t".
				$A_gene_ref[$A_count]."\t".
				$A_TSS[$A_count]."\t".
				$A_strand[$A_count]."\n");
	      
		$B_count ++;
	      }
		      
	  else{
	
	  $B_count ++;
	
	  }
	
	}
	
	$A_count ++;
	$B_count = 0;
	
      }
      
 print "Have just created $outfile\n";
        # close out file handle
        close(OUT);
      
      }}}}
