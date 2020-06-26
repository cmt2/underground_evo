#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  ParseLiliFile.py
#  
#  Copyright 2016 Carrie Tribble <carrietribble@Carries-MacBook-Air.local>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
##read in text file and parse out species and geophyte type
 
import re
import os
import pandas as pd
import csv
import string
import glob

species=[]
habit=[]
lifeforms = [" hydrogeophyte", " tuber", " geophyte", " bulb", " rhizome", " cl.", " bamboo", " biennial", " pseudobulb", " pachycaul", " cereiform", " cauduciform", " ther", " hydrother", " hydrophyte", " hel.", " hemicr", " cham", " nanophan", " herb. phan", " phan", " succ", " holomycotroph", " holopar", " hemipar", " epiphyt", " lithophyt"]
geo_code=[]

files = glob.glob("/Users/carrietribble/Documents/liliales_paper/Liliales_checklists/checklists/*.txt")


for i in files:
	print i
	fam = open(i)
	for line in fam:
		if line.strip() == '':
			continue
		elif "===" in line:
			continue
		elif "*" in line:
			continue
		elif "var." in line:
			continue
		elif "subsp." in line:
			continue
		elif len(line.split()) == 1:
			continue
		elif len(line.split()[0]) < 3:
			continue
		elif len(line.split()[1]) < 3:
			continue
		elif len([l for l in line.split()[0] if l.isupper()]) != 1:
			continue
		elif len([l for l in line.split()[1] if l.isupper()]) == 0: 
			#print [line.split()[0],line.split()[1]]
			species.append([line.split()[0],line.split()[1]])
			y=next(fam)
			forms = []
			for lf in lifeforms:
				if lf in y.lower():
					forms.append(lf) 
			habit.append(string.join(forms))
			geo_code.append(' '.join(map(str,[int(s) for s in y.split() if s.isdigit()])))
					
	fam.close()

	

df=pd.DataFrame(data=[species,habit,geo_code])
df=df.transpose()
df.to_csv("/Users/carrietribble/Documents/liliales_paper/Liliales_checklists/LilialesTraits.csv", sep=',')




