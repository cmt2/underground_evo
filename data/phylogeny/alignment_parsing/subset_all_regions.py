import os
from Bio import SeqIO
import re


regions = [["ITS", "its", "internal transcribed spacer"], # or
		   ["ITS", "its", "internal transcribed spacer"], # or
		   ["atpB"],
		   ["atpB-rbcL"],
		   ["atpH", "atpF"], # and 
		   ["apocytochrome b-like", "cob"], # or
		   ["maturase K", "matK"], # or 
		   ["maturase", "matR"], # or 
		   ["nad5", "NADH dehydrogenase subunit 5"], # or 
		   ["NADH dehydrogenase subunit F", "ndhF"], # or 
		   ["ribulose-1,5-bisphosphate carboxylase/oxygenase large subunit", "rbcL"], # or
		   ["rpl16", "rpL16"], # or 
		   ["rpl32", "rpl32-trnL"], # or 
		   ["ribosomal protein S16", "rps16"], # or 
		   ["pbsA-trnH", "pbsA", "psbA", "psbA-trnH"], # or 
		   ["trnK"],
		   ["trnL-trnF", "trnL", "tRNA-Leu", "trnF", "tRNA-Phe"], # or
		   [],
		   ["trnY", "trnD", "tRNA-Asp", "trnY-trnD", "tRNA-Tyr"]] # or    

dir_name_input = "Desktop/align_orig/" # directory where original fasta files are saved

dir_name_output = "Desktop/align_new/" # directory where new files will be saved

filename_suffix = "fasta" # suffix of fasta files 

i = 0
		   
for item in regions : # for all alignments
	
	base_filename = str(i + 1) # the i + 1th region
	
	# set input file path and output file path for the region 
	
	input_fasta_path = os.path.join(dir_name_input, base_filename + "." + filename_suffix)
	
	output_fasta_path = os.path.join(dir_name_output, base_filename + "." + filename_suffix)
	
	output_other_fasta_path = os.path.join(dir_name_output, "".join([base_filename, "_other"])+ "." + filename_suffix)
	
	########### if you are only searching for 1 term
	if len(item) == 1 : 
		
		seqs = SeqIO.parse(input_fasta_path, "fasta") # read in the sequences for that fasta file
		
		search_terms = item[0] # set the search terms to the corresponding list 
		
		with open(output_fasta_path, "w") as f : # open output fasta file 
			
			for seq in seqs : # search in each sequences 
				
				if re.search(search_terms, seq.description) : # if it has the search term
					SeqIO.write([seq], f, "fasta") # save as the output fasta 
		
		seqs = SeqIO.parse(input_fasta_path, "fasta") # read in the sequences for that fasta file (again)
			
		with open(output_other_fasta_path, "w") as f : # open other output fasta file 
			
			for seq in seqs : # search in each sequences 
				
				if not re.search(search_terms, seq.description) : # if it DOES NOT have the search term
					SeqIO.write([seq], f, "fasta") # save as the other output fasta 	
	
	########### if you are searching for more than 1 item		
	if len(item) > 1 :
		
		seqs = SeqIO.parse(input_fasta_path, "fasta") # read in the sequences for that fasta file
				
		with open(output_fasta_path, "w") as f : # open output fasta file 
			
			for seq in seqs : # search in each sequences 
				
				if re.search("|".join(item), seq.description) : # if it has any of the search terms
					SeqIO.write([seq], f, "fasta") # save as the output fasta 
		
		seqs = SeqIO.parse(input_fasta_path, "fasta") # read in the sequences for that fasta file (again)
					
		with open(output_other_fasta_path, "w") as f : # open other output fasta file 
			
			for seq in seqs : # search in each sequences 
				
				if not re.search("|".join(item), seq.description) : # if it DOES NOT have the search term
					SeqIO.write([seq], f, "fasta") # save as the other output fasta 	
					
	
	i = i + 1