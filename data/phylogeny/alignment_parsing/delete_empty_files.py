import os
from Bio import SeqIO


dir_name_output = "Desktop/align_new/" # directory where new files will be saved

filename_suffix = "fasta" # suffix of fasta files 

for file in os.listdir("Desktop/align_new") :
	
	new_fasta_path = "".join([dir_name_output, file])
	
	if len(list(SeqIO.parse(new_fasta_path, "fasta"))) == 0 : 
		 os.remove(new_fasta_path) 

		