import os
from Bio import SeqIO
import re


dir_name_input = "Desktop/align_orig/" # directory where original fasta files are saved

dir_name_output = "Desktop/align_new/" # directory where new files will be saved

filename_suffix = "fasta" # suffix of fasta files 

for i in xrange(1,20) :
	
	if i != 18:
		
		# create integer strings to reference files by number
		base_filename = str(i)
		
		base_filename_other = "_".join([base_filename, "other"])
		
		
		# create paths to load input files, output files, and other output files
		input_fasta_path = os.path.join(dir_name_input, base_filename + "." + filename_suffix)
		
		new_fasta_path = os.path.join(dir_name_output, base_filename + "." + filename_suffix)
		
		other_fasta_path = os.path.join(dir_name_output, base_filename_other + "." + filename_suffix)
		
		
		# read in the 3 files 	
		orig = list(SeqIO.parse(input_fasta_path, "fasta"))
		
		new = list(SeqIO.parse(new_fasta_path, "fasta"))
		
		other = list(SeqIO.parse(other_fasta_path, "fasta"))
		
		
		if len(orig) != len(new) + len(other) : 
			print " ".join(["file:", str(i)])
			print " ".join(["orig:", str(len(orig)), "new:", str(len(new))])