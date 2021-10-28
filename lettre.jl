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
			

			
M = zeros(Int, 26, 26)

function estlettreFr(cara)
    cara = lowercase(cara)
    if (cara >= 'a' && cara <= 'z')
        return true
    end
    return match(r"[àâçéèêëîïôûùüÿæœ]", string(cara, "")) !== nothing
end


            
function indiceLettre(dict,lettre)
    return dict[lowercase(lettre)]
end 



function majcouple!(M,av,ap)
	if(estlettreFr(av) && estlettreFr(ap))
    	M[indiceLettre(dictionnaire,av), indiceLettre(dictionnaire,ap)] = M[indiceLettre(dictionnaire,av), indiceLettre(dictionnaire,ap)]+1
	end
end

function couples(txt_url,matrice)
	P = Array{Float64}(undef, 26,26)
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
		for j in 1:26
			P[i,j] = matrice[i,j]/total
		end 
	end	
	for i in 1:26
		tmp=0
		for j in 1:26
			P[i,j]=tmp+P[i,j]
			tmp= P[i,j]
		end
	end
	return P
end

T = zeros(Float64, 30)
function moyenneTailleMot(txt_url,tableauMot)
	cptTotal = 0
	for line in eachline(txt_url)
		mots = split(line," ")
		for mot in mots
			if(sizeof(mot)>0)
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

function generationPhrase(probaLettre,probaMot)
	tirage = rand((7:25))
	phrase = ""
	for i in 1:tirage 
		phrase = phrase*" "*generationMot(probaLettre,probaMot)
	end
	return uppercase(phrase[2])*phrase[3:end]*"."
	
end

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
