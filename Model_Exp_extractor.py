import pandas as pd 

# Get the list for the cell line with metabolic measurement 
model = pd.read_excel("NIHMS1033364-supplement-Supplementary_Tables_1__2__3__4.xlsx", sheet_name = "1-cell line annotations")
model_to_extract = []
for i in model['Name'] : 
    model_to_extract.append(i)
    
names = pd.read_csv("Model.csv")

filtered = names[names['StrippedCellLineName'].isin(model_to_extract)]
names_list = filtered['ModelID'].tolist()        

profils = pd.read_csv("OmicsDefaultModelProfiles.csv")
buffer = profils[profils['ModelID'].isin(names_list)]
profil_list = buffer['ProfileID'].tolist()  

#print(profil_list)
#print(len(profil_list))
    
with open("id_list.txt", "w") as f:
    for item in profil_list:
        f.write(f"{item}\n")
    
print ("####### DONE ####### ")

