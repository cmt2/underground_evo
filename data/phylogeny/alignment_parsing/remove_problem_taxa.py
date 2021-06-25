# remove problem taxa

from Bio import SeqIO
import os

all_files = os.listdir(os.getcwd())

problem_taxa = ["Tricyrtis_amethystina", "Gagea_spathacea"]

for file in all_files:
	print file
	in_file = file 
	out_file = "mod_" + file
	with open(in_file) as original, open(out_file, 'w') as corrected:
		records = SeqIO.parse(original, 'nexus')
		records_output = []
		for seq_record in records :
			if seq_record.id != problem_taxa[0] and seq_record.id != problem_taxa[1]: 
				records_output.append(seq_record)
			else: 
				print seq_record
		SeqIO.write(records_output, corrected, 'nexus')