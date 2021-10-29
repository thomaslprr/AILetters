#Définition d'un dictionnaire : lettre vers chiffre
dictionnaire = Dict('a' => 1,
            'à' => 1,
            'â' => 1,
            'b' => 2,
            'c' => 3,
            'ç' => 3,
            'd' => 4,
            'e' => 5,
            'é' => 5,
            'è' => 5,
            'ê' => 5,
            'ë' => 5,
            'æ' => 5,
            'œ' => 5,
            'f' => 6,
            'g' => 7,
            'h' => 8,
            'i' => 9,
            'î' => 9,
            'ï' => 9,
            'j' => 10,
            'k' => 11,
            'l' => 12,
            'm' => 13,
            'n' => 14,
            'o' => 15,
            'ô' => 15,
            'p' => 16,
            'q' => 17,
            'r' => 18,
            's' => 19,
            't' => 20,
            'u' => 21,
			'ü' => 21,
            'ù' => 21,
            'û' => 21,
            'v' => 22,
            'w' => 23,
            'x' => 24,
            'y' => 25,
            'ÿ' => 25,
            'z' => 26
            )

#Défintiion d'un dicitionnaire inversé : chiffre vers lettre			
dictionnaireInverse = Dict(1 => 'a',
			2 => 'b',
			3 => 'c',
			4 => 'd',
			5 => 'e',
			6 => 'f',
			7 => 'g',
			8 => 'h',
			9 => 'i',
			10 => 'j',
			11 => 'k',
			12 => 'l',
			13 => 'm',
			14 => 'n',
			15 => 'o',
			16 => 'p',
			17 => 'q',
			18 => 'r',
			19 => 's',
			20 => 't',
			21 => 'u',
			22 => 'v',
			23 => 'w',
			24 => 'x',
			25 => 'y',
			26 => 'z',
			)
			

			
M = zeros(Float64, 26, 26)
#méthode prenant en paramètre un caractère et renvoie true s'il s'agit d'un caractère français sinon renvoie false
function estlettreFr(cara)
    cara = lowercase(cara)
    if (cara >= 'a' && cara <= 'z')
        return true
    end
    return match(r"[àâçéèêëîïôûùüÿæœ]", string(cara, "")) !== nothing
end


#méthode renvoyant l'indice d'une lettre selon la lettre passée en paramètre et le dictionnaire            
function indiceLettre(dict,lettre)
    return dict[lowercase(lettre)]
end 


#méthode permettant de mettre à jour un dictionnaire
function majcouple!(M,av,ap)
	if(estlettreFr(av) && estlettreFr(ap))
    	M[indiceLettre(dictionnaire,av), indiceLettre(dictionnaire,ap)] = M[indiceLettre(dictionnaire,av), indiceLettre(dictionnaire,ap)]+1
	end
end

#méthode pour créer la matrice de proba de succession de lettre à une lettre selon un fichier passé en paramètre
function couples!(txt_url,matrice)
	for line in eachline(txt_url)
		tmp = ' ' ;
		for char in line
			if(tmp==' ')
				tmp=char
			elseif (tmp!=' ')
				majcouple!(matrice,tmp,char);
				tmp=char;
			end	
		end
	end
	for i in 1:26
		total = sum(matrice[i,:])
		tmp=0
		for j in 1:26
			matrice[i,j] = tmp+matrice[i,j]/total
			tmp = matrice[i,j]
		end 
	end	
	return matrice
end

T = zeros(Float64, 30)
#méthode bonus qui permet de calculer la proba de la taille d'un mot selon un texte passé en paramètre
function moyenneTailleMot!(txt_url,tableauMot)
	cptTotal = 0
	for line in eachline(txt_url)
		mots = split(line," ")
		for mot in mots
			if(length(mot)>0)
				if haskey(dictionnaire,lowercase(mot[1])) 
					tableauMot[length(mot)] = tableauMot[length(mot)]+1
					cptTotal = cptTotal+1 
				end
			end		
		end
	end
	
	cml=0
	for i in 1:30
		tableauMot[i]=cml+(tableauMot[i]/cptTotal)
		cml = tableauMot[i]
	end
	return tableauMot
end

#Méthode qui génère un mot par rapport à la proba des lettres et la proba des tailles des mots
function generationMot(probaLettre,probaMot)
	lettre = dictionnaireInverse[rand((1:26))]
	tirage = rand(Float64)
	tailleMot = -1
	intervalle=0 
	for i in 1:30
		if(tirage >=intervalle && tirage <= probaMot[i])
			 tailleMot = i
			 break
		end
		intervalle=probaMot[i]
	end
	chaine = ""*lettre
	for i in 1:tailleMot 
		lettre = lettreSuivante(probaLettre,lettre)
		chaine = chaine*lettre
	end
	return chaine
end

#Méthode qui génère une phrase par rapport à une proba des lettres et une proba des tailles de mot
function generationPhrase(probaLettre,probaMot)
	tirage = rand((7:25))
	phrase = ""
	for i in 1:tirage 
		phrase = phrase*" "*generationMot(probaLettre,probaMot)
	end
	return uppercase(phrase[2])*phrase[3:end]*"."
	
end

#Méthode qui annonce la lettre suivante par rapport à une lettre donnée en entrée et des probas
function lettreSuivante(probaLettre,lettre)
	tirage = rand(Float64)
	indice = indiceLettre(dictionnaire,lettre)
	intervalle=0  
	for i in 1:26
		if(tirage >=intervalle && tirage <= probaLettre[indice,i])
			return dictionnaireInverse[i]
		end
		intervalle=probaLettre[indice,i]
	end
end	

#Méthode lit un texte, apprend sur les probas de lettre et de taille de mot
#Génère un nombre de phrase spécifié en paramètre
function test!(texteUrl,matriceLettre,matriceMot,nbPhrase)
	probaLettre = couples(texteUrl,matriceLettre)
	probaTailleMot = moyenneTailleMot(texteUrl,matriceMot)
	paragraphe = ""
	for i in 1:nbPhrase
		paragraphe = paragraphe * " "*generationPhrase(probaLettre,probaTailleMot)	
	end
	return paragraphe[2:end]
end
