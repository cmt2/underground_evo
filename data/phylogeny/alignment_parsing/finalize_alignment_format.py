### Finalize alignments by changing name spaces to underscores and alphabetizing 

import os 
from Bio import SeqIO
from Bio import AlignIO
from Bio import Alphabet
from Bio.SeqRecord import SeqRecord


# get list of all files 

all_files = os.listdir(os.getcwd())

# for each file, change space to underscore, alphabetize, and convert to nexus

for file in all_files: 
	new_records = []
	for seq_record in SeqIO.parse(file, "fasta"):
		seq_record.description = seq_record.description.replace(" ", "_")
		seq_record.description = seq_record.description.replace("-", "_")
		seq_record.id = seq_record.description
		seq_record.name = seq_record.description
		new_records.append(seq_record)
	
	with open(file, "w+") as output_file:
		print("writing underscored version of " + file)
		SeqIO.write(new_records, output_file, "fasta")

os.mkdir("nexus_files")		

for file in all_files:
	if file.split(".")[1] == "fasta" : 
		alignment = AlignIO.read(open(file), "fasta")
		alignment.sort()
		AlignIO.write(alignment, file, "fasta")
		print("writing alphabetical and nexus version of " + file)
		AlignIO.convert(file, "fasta", "nexus_files/" + file.split(".fasta")[0] + ".nexus", "nexus", alphabet=Alphabet.generic_dna)
	elif file.split(".")[0] == "pastajob":
		alignment = AlignIO.read(open(file), "fasta")
		alignment.sort()
		AlignIO.write(alignment, file, "fasta")
		print("writing alphabetical and nexus version of " + file)
		AlignIO.convert(file, "fasta", "nexus_files/" + file.split('pastajob.marker001.')[1].split('.aln')[0] + ".nexus", "nexus", alphabet=Alphabet.generic_dna)
		
				
		