# edit taxon names for types/ synonyms 

from Bio import SeqIO
import os

all_files = os.listdir(os.getcwd())

os.makedirs('post_raxml_edits')

for file in all_files :
	if file != '.DS_Store' and file != 'super_matrix.phylip' :
		with open(file) as original, open('post_raxml_edits/' + file, 'w') as corrected:  
			records = SeqIO.parse(original, 'fasta')
			for record in records:
				record.description = record.description.replace("Ripogonum", "Rhipogonum")
				record.id = record.id.replace("Ripogonum", "Rhipogonum")
				record.description = record.description.replace("Bulbocodium", "Colchicum")
				record.id = record.id.replace("Bulbocodium", "Colchicum")
				if record.description == "Ravenea hildebrandti" :
					record.description = record.description.replace("Ravenea hildebrandti", "Ravenea hildebrandtii")
					record.id = record.id.replace("Ravenea hildebrandti", "Ravenea hildebrandtii")
				record.description = record.description.replace("Trillidium", "Trillium")
				record.id = record.id.replace("Trillidium", "Trillium")
				record.description = record.description.replace("Leontochir", "Bomarea")
				record.id = record.id.replace("Leontochir", "Bomarea")
				SeqIO.write(record, corrected, 'fasta')			


