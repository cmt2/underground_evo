# concatenate in python

from Bio.Nexus import Nexus

file_list = ['atpB-rbcL.nexus', 'atpB.nexus', 'matK.nexus', 
			 'nadhF.nexus', 'rbcL.nexus', 'rpl16.nexus', 
			 'trnL_trnF.nexus','unique_combined_its.nexus', 
			 'unique_combined_psba_new_aligned.nexus', 
			 'unique_combined_rps16.nexus']
			 
nexi =  [(fname, Nexus.Nexus(fname)) for fname in file_list]

combined = Nexus.combine(nexi)
combined.write_nexus_data(filename=open('supermatrix.nex', 'w'))
