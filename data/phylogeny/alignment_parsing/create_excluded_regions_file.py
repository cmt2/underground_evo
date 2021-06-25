# identify columns with too few taxa (<5%) to exclude from analysis using RAxML exclude regions feature 

from Bio import AlignIO
from cStringIO import StringIO
import sys

cut_off_percent = 0.01
alignment_path = "super_matrix_edited.fasta"
output_path = "excluded_regions.txt" 


align = AlignIO.read(alignment_path, "fasta")

class Capturing(list):
    def __enter__(self):
        self._stdout = sys.stdout
        sys.stdout = self._stringio = StringIO()
        return self
    def __exit__(self, *args):
        self.extend(self._stringio.getvalue().splitlines())
        del self._stringio    # free up some memory
        sys.stdout = self._stdout
        

with Capturing() as output:
	align

num_cols = int(str(output).split(" ")[7].split(",")[0])

bad_cols = []

for i in range(num_cols) : 
	col = str(align[ :, i]).replace("?", "-")
	perc_ungapped = (float(len(col)) - float(col.count("-")))/float(len(col))
	if perc_ungapped < cut_off_percent :
		bad_cols.append(i)

file = open(output_path, "w")
for num in bad_cols : 
	file.write(str(num + 1) + "-" + str(num + 1) + " ")

file.close()


	