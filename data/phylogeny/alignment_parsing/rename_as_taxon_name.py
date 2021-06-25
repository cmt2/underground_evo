# rename fasta file seqs with taxon name only 

from Bio import SeqIO
import os

all_files = os.listdir(os.getcwd())

os.makedirs('renamed')

for file in all_files :
	seqs = []
	names = []
	for seq_record in SeqIO.parse(file, "fasta"):
		seq_record.description = seq_record.description.replace("Ripogonum", "Rhipogonum")
		seq_record.id = seq_record.id.replace("Ripogonum", "Rhipogonum")
		seq_record.description = seq_record.description.replace("Bulbocodium", "Colchicum")
		seq_record.id = seq_record.id.replace("Bulbocodium", "Colchicum")
		seq_record.description = seq_record.description.replace("Trillidium", "Trillium")
		seq_record.id = seq_record.id.replace("Trillidium", "Trillium")
		seq_record.description = seq_record.description.replace("Leontochir", "Bomarea")
		seq_record.id = seq_record.id.replace("Leontochir", "Bomarea")
		if seq_record.description.split(" ")[1] == "UNVERIFIED:" and seq_record.description.split(" ")[3] == "cf.":
			new_id = seq_record.description.split(" ")[2] + " " + seq_record.description.split(" ")[4]
		elif seq_record.description.split(" ")[1] == "UNVERIFIED:" :
			new_id = seq_record.description.split(" ")[2] + " " + seq_record.description.split(" ")[3]
		elif seq_record.description.split(" ")[2] == "x" :
			new_id = seq_record.description.split(" ")[1] + " " + seq_record.description.split(" ")[2] + " " + seq_record.description.split(" ")[3]
		elif seq_record.description.split(" ")[2] == "aff." or seq_record.description.split(" ")[2] == "cf." :
			new_id = seq_record.description.split(" ")[1] + " " + seq_record.description.split(" ")[3]
		elif seq_record.description.find("Tulipa edulis") != -1 :
			new_id = "Amana edulis"		
		elif seq_record.description.find("Tulipa erythronioides") != -1 :
			new_id = "Amana erythronioides"
		else:
			new_id = seq_record.description.split(" ")[1] + " " + seq_record.description.split(" ")[2]
		names.append(new_id)
		seqs.append(str(seq_record.seq))
	with open("renamed/" + file, "w+") as output_file:
		i = 0
		for seq in seqs:    
			output_file.write(">" + names[i] + "\n" + seq + "\n")
			i = i + 1 
			
	
		
