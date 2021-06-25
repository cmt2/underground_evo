import os
from Bio import SeqIO


sequences={}

# read in combined file 
for seq_record in SeqIO.parse("unique_combined_psbA_r.fasta", "fasta"): 
	sequence = str(seq_record.seq.ungap('-')).upper()
	if sequence not in sequences: # check to be sure the sequence isn't already saved
                sequences[sequence] = seq_record.description

# write out unique sequences 
with open("unique_combined_psbA_r.fasta", "w+") as output_file:
	for sequence in sequences:        
		output_file.write(">" + sequences[sequence] + "\n" + sequence + "\n")
	