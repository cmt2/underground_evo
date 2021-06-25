import os
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

#read in partition file to get break points 
part  = open('part.txt.excl') 

#create empty lists to store partition info 
name = []
start = []
stop = []

#split partition document 
for line in part:
	name.append(line.split(",")[1].split(" = ")[0].split())
	start.append(line.split(",")[1].split(" = ")[1].split("-")[0])
	stop.append(line.split(",")[1].split(" = ")[1].split("-")[1].split("\n")[0])

#minus one to match with python counting starting at 0
start[:] = [int(x) - 1 for x in start] 
	
# create new directory for files
os.makedirs("new_files")


# generate new files

for i in range(len(name)) :
	records = SeqIO.parse("trimmed_alignment.nexus", "nexus")
	with open("new_files/" + name[i][0] + ".fasta", "w") as f :
		for rec in records : 
			trimmed_rec = rec.seq[start[i]:int(stop[i])]
			new_rec = SeqRecord(trimmed_rec, rec.id, '', '')
			SeqIO.write(new_rec, f, "fasta") 

# then convert all the fasta files to nexus files using seqmagick convert infile.fasta outfile.nex --alphabet dna
# then remove all the .fasta files 
