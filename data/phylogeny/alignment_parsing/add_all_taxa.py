### modify alignments so they contain rows for all taxa (appropriate for super matrix construction in RevBayes) 

import os 
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

# get list of all files 

all_files = os.listdir(os.getcwd())

# generate list of all taxa in all alignments 

names = []
for file in all_files :
	for seq_record in SeqIO.parse(file, "fasta"):
		names.append(seq_record.description)

all_names = list(set(names))

# create new fasta files with all taxa 

all_files = os.listdir(os.getcwd())

for file in all_files: 
	file_names = []
	for seq_record in SeqIO.parse(file, "fasta"):
		file_names.append(seq_record.description)
		align_length = len(seq_record.seq)
	
	missing_names = [i for i in file_names + all_names if i not in file_names or i not in all_names]
	
	with open(file, "r") as myfile:
		addition = []
		for n in missing_names:
			addition.append([">" + n + "\n" + "-" * align_length])
		
		addition = [item for sublist in addition for item in sublist]
	
	with open(file, "a") as myfile:
		myfile.write('\n'.join(addition))
    
