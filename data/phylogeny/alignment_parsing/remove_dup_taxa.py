#remove duplicate sequences and remove unidentified species 

from Bio import SeqIO
import os

all_files = os.listdir(os.getcwd())

os.makedirs('trimmed')

for file in all_files :
	if file != '.DS_Store' : 
		seq_recs = []
		names = []
		for seq_record in SeqIO.parse(file, "fasta") :
			if seq_record.description not in names and seq_record.description.split(" ")[1] != "sp." :
				seq_recs.append(seq_record)
			names.append(seq_record.description)
		with open('trimmed/' + file, 'w') as output_file : 
			SeqIO.write(seq_recs, output_file, "fasta")
	
			