#Définition d'un dictionnaire : lettre vers chiffre
dictionnaire = Dict('a' => 1, 'à' => 1, 'â' => 1, 'b' => 2, 'c' => 3, 'ç' => 3,
            'd' => 4, 'e' => 5, 'é' => 5, 'è' => 5, 'ê' => 5, 'ë' => 5, 'æ' => 5,
			'œ' => 5, 'f' => 6, 'g' => 7, 'h' => 8, 'i' => 9, 'î' => 9, 'ï' => 9,
            'j' => 10, 'k' => 11, 'l' => 12, 'm' => 13, 'n' => 14, 'o' => 15,
			'ô' => 15, 'p' => 16, 'q' => 17, 'r' => 18, 's' => 19, 't' => 20,
            'u' => 21, 'ü' => 21, 'ù' => 21, 'û' => 21, 'v' => 22, 'w' => 23,
            'x' => 24, 'y' => 25, 'ÿ' => 25, 'z' => 26 )

#Défintiion d'un dicitionnaire inversé : chiffre vers lettre			
dictionnaireInverse = Dict(1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd', 5 => 'e',
			6 => 'f', 7 => 'g', 8 => 'h', 9 => 'i', 10 => 'j', 11 => 'k',
			12 => 'l', 13 => 'm', 14 => 'n', 15 => 'o', 16 => 'p', 17 => 'q',
			18 => 'r', 19 => 's', 20 => 't', 21 => 'u', 22 => 'v', 23 => 'w',
			24 => 'x', 25 => 'y',26 => 'z' )

function estlettreFr(cara)
    cara = lowercase(cara)
    if (cara >= 'a' && cara <= 'z')
        return true
    end
    return match(r"[àâçéèêëîïôûùüÿæœ]", string(cara, "")) !== nothing
end


function majcouple!(dict,av,ap)
	if(estlettreFr(av) && estlettreFr(ap))
		chaine = string(dictionnaireInverse[dictionnaire[lowercase(av)]])*string(dictionnaireInverse[dictionnaire[lowercase(ap)]])
		if(haskey(dict,chaine))
			dict[chaine]=dict[chaine]+1
		else
			dict[chaine]=1
		end
		base = dictionnaireInverse[dictionnaire[lowercase(av)]]*""
		if(haskey(dict,base))
			dict[base]=dict[base]+1
		else
			dict[base]=1
		end
	end
end


function proba!(dict)
	for i in 1:26
		res = filter(tuple -> startswith(first(tuple), dictionnaireInverse[i]), dict)
		total = res[""*dictionnaireInverse[i]]
		delete!(dict,""*dictionnaireInverse[i])
		delete!(res,""*dictionnaireInverse[i])
		cml=0
		for (key,value) in res
				dict[key]=(dict[key]/total)+cml
				cml = dict[key]
		end
	end
end

function couples!(dict, txt_url)
	cpt=0
	for line in eachline(txt_url)
		tmp = ' ' ;
		for char in line
			if(tmp==' ')
				tmp=char
			elseif (tmp!=' ')
				majcouple!(dict,tmp,char);
				cpt=cpt+1
				tmp=char;
			end	
		end
	end
	proba!(dict)
end

#méthode bonus qui permet de calculer la proba de la taille d'un mot selon un texte passé en paramètre
function moyenneTailleMot!(dictMot, txt_url)
	cptTotal = 0
	for line in eachline(txt_url)
		mots = split(line," ")
		for mot in mots
			if(sizeof(mot)>0)
				if haskey(dictMot,length(mot))
					dictMot[length(mot)] = dictMot[length(mot)]+1
				else
					dictMot[length(mot)] = 1
				end
				cptTotal = cptTotal+1 
			end		
		end
	end
	
	cml=0
	for (key,value) in dictMot
		dictMot[key] = (dictMot[key]/cptTotal)+cml
		cml =dictMot[key]  
	end
end

function lettreSuivante(probaLettre,letter)
	tirage = rand(Float64)
	res = filter(tuple -> startswith(first(tuple), ""*letter), probaLettre)
	before = 0 
	for (key,value) in res
		if tirage>=before && tirage<= value
			return key[2]
		end
		before = value
	end
	#dans le cas où une lettre n'aurait aucune probabilité, on retourne une lettre aléatoire
	return dictionnaireInverse[rand((1:26))]
end


#Méthode qui génère un mot par rapport à la proba des lettres et la proba des tailles des mots
function generationMot(probaLettre,probaMot)
	lettre = dictionnaireInverse[rand((1:26))]
	tirage = rand(Float64)
	tailleMot=-1
	before=0 
	for (key,value) in probaMot
		if tirage>=before && tirage<= value
			tailleMot= key
		end
		before = value
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

#Méthode lit un texte, apprend sur les probas de lettre et de taille de mot
#Génère un nombre de phrase spécifié en paramètre
function generationTexte(texteUrl,nbPhrase)
	D = Dict{String,Float64}()
	couples!(D, texteUrl)
	T = Dict()
	moyenneTailleMot!(T, texteUrl)
	paragraphe = ""
	for i in 1:nbPhrase
		paragraphe = paragraphe * " " * generationPhrase(D, T)	
	end
	return paragraphe[2:end]
end