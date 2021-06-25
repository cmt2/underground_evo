import os
from Bio import SeqIO
import re

regions = [["ITS", "its", "internal transcribed spacer"], 
		   ["ITS", "its", "internal transcribed spacer"], 
		   ["atpB"],
		   ["atpB-rbcL"],
		   ["atpH", "atpF"],  
		   ["apocytochrome b-like", "cob"], 
		   ["maturase K", "matK"],
		   ["maturase", "matR"], 
		   ["nad5", "NADH dehydrogenase subunit 5"], 
		   ["NADH dehydrogenase subunit F", "ndhF"],  
		   ["ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit", "rbcL"], 
		   ["rpl16", "rpL16"],
		   ["rpl32", "rpl32-trnL"],
		   ["ribosomal protein S16", "rps16"],  
		   ["pbsA-trnH", "pbsA", "psbA", "psbA-trnH"], 
		   ["trnK"],
		   ["trnL-trnF", "trnL", "tRNA-Leu", "trnF", "tRNA-Phe"], 
		   ["trnY", "trnD", "tRNA-Asp", "trnY-trnD", "tRNA-Tyr"]] 

# get list of all 'other' fasta files
all_files = os.listdir(os.getcwd())
fasta_dirs = {}
for file in all_files: 
	if re.search("other", file):
		fasta_dirs[file] = file 
		


out_files = ["ITS_other.fasta", "atpB_other.fasta", "atpB-rbcL_other.fasta",
			 "atpH_atpF_other.fasta", "cob_other.fasta", "matK_other.fasta",
			 "matR_other.fasta", "nad5_other.fasta", "ndhF_other.fasta", 
			 "rbcL_other.fasta", "rpl16_other.fasta", "rpL16_other.fasta",
			 "rpl32_other.fasta", "rps16_other.fasta", "psbA_other.fasta",
			 "trnk_other.fasta", "trnL_other.fasta", "trnY_trnD_other.fasta"]

# for each region 
for reg in enumerate(regions):
	if len(reg[1]) == 1 :
		reg_seqs = {} 
		for file in fasta_dirs:
			seqs = SeqIO.parse(file, "fasta") 
			search_terms = reg[1][0]
			for seq in seqs : 
				if re.search(search_terms, seq.description) : 
					reg_seqs[seq] = seq.description
		
		with open(out_files[reg[0]], "w") as f :
			for seq in reg_seqs :
				SeqIO.write([seq], f, "fasta")
	
	if len(reg[1]) > 1 :
		reg_seqs = {} 
		for file in fasta_dirs:
			seqs = SeqIO.parse(file, "fasta") 
			search_terms = reg[1]
			for seq in seqs : 
				if re.search("|".join(search_terms), seq.description) :
					reg_seqs[seq] = seq.description
		
		with open(out_files[reg[0]], "w") as f :
			for seq in reg_seqs :
				SeqIO.write([seq], f, "fasta")
			