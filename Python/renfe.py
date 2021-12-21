#!/usr/bin/env python3

from time import strftime

bitllets_ATM = ['T-Casual','T-Usual','T-Grup','T-Familia','T-Jove','T-Dia','T-Aire']
bitllets_REN = ['General','Bonotren','Abonament mensual','Abonament trimestral']
bitllets = [bitllets_ATM, bitllets_REN]

zones = [' 1 zona',' 2 zones',' 3 zones',' 4 zones',' 5 zones',' 6 zones']

tcasual = [11.35,22.40,30.50,39.20,45.05,47.90]
tusual  = [40.00,53.85,75.60,92.55,106.20,113.75]
tgrup   = [79.45,156.80,213.50,274.40,315.35,335.30]
tfamilia= [10.00,19.00,27.00,35.00,40.00,42.00]
tjove   = [80.00,105.20,147.55,180.75,207.40,222.25]
tdia    = [10.50,16.00,20.10,22.45,25.15,28.15]
taire   = [2.05,4.05,5.50,7.55,8.10,8.60]

rgeneral= [2.40,2.80,3.85,4.60,5.50,6.95]
rbonotren=[10.25,16.35,24.20,31.45,38.20,47.75]
rabmens = [25.55,30.50,47.05,57.90,69.95,83.85]
rabtrim = [92.15,104.10,148.15,176.10,208.15,249.30]

merda1 = [tcasual,tusual,tgrup,tfamilia,tjove,tdia,taire]
merda2 = [rgeneral,rbonotren,rabmens,rabtrim]

for pos in range(0,len(bitllets)):
	for j in range(0,len(bitllets[pos])):
		for i in range(0,len(zones)):
			print("INSERT INTO producte (nom,familia,descripcio) SELECT '" + str(bitllets[pos][j]) + "','Transport','" + str(bitllets[pos][j]) + str(zones[i]) + "' WHERE NOT EXISTS (SELECT * FROM producte WHERE  nom = '" + str(bitllets[pos][j]) + "' AND familia = 'Transport' AND descripcio = '" + str(bitllets[pos][j]) + str(zones[i]) + "');")
			if pos < 1:
				print("INSERT INTO historicpreus (pvp,data,ofertes,fkey_producte,fkey_beneficiari) SELECT '" + str(merda1[j][i]) + "','" + strftime('%Y-%m-%d') + "','no',(SELECT id FROM producte WHERE  nom = '" + str(bitllets[pos][j]) + "' AND familia = 'Transport' AND descripcio = '" + str(bitllets[pos][j]) + str(zones[i]) + "'),(SELECT id FROM beneficiari WHERE comerc = 'Renfe') WHERE NOT EXISTS ( SELECT * FROM historicpreus WHERE pvp = '" + str(merda1[j][i]) + "' AND ofertes = 'no' AND fkey_beneficiari = (SELECT id FROM beneficiari WHERE comerc = 'Renfe') AND fkey_producte = (SELECT id FROM producte WHERE  nom = '" + str(bitllets[pos][j]) + "' AND familia = 'Transport' AND descripcio = '" + str(bitllets[pos][j]) + str(zones[i]) + "') );")
			else:
				print("INSERT INTO historicpreus (pvp,data,ofertes,fkey_producte,fkey_beneficiari) SELECT '" + str(merda2[j][i]) + "','" + strftime('%Y-%m-%d') + "','no',(SELECT id FROM producte WHERE  nom = '" + str(bitllets[pos][j]) + "' AND familia = 'Transport' AND descripcio = '" + str(bitllets[pos][j]) + str(zones[i]) + "'),(SELECT id FROM beneficiari WHERE comerc = 'Renfe') WHERE NOT EXISTS ( SELECT * FROM historicpreus WHERE pvp = '" + str(merda2[j][i]) + "' AND ofertes = 'no' AND fkey_beneficiari = (SELECT id FROM beneficiari WHERE comerc = 'Renfe') AND fkey_producte = (SELECT id FROM producte WHERE  nom = '" + str(bitllets[pos][j]) + "' AND familia = 'Transport' AND descripcio = '" + str(bitllets[pos][j]) + str(zones[i]) + "') );")
