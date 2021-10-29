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
			
			
			
D = Dict{String,Float64}()

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
	return dict
end

function couples(txt_url,dict)
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
