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
	println(matrice)
	for i in 1:26
		total = sum(matrice[i,:])
		println(total);
		for j in 1:26
			P[i,j] = matrice[i,j]/total
		end 
	end	
	return P
end

#réaliser des tranches en fonction de la proba et tirer un nombre aleatoire 
			
