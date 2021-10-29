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
		chaine = lowercase(string(av)*string(ap))
		if(haskey(dict,chaine))
			dict[chaine]=dict[chaine]+1
		else
			dict[chaine]=1
		end
	end
end


function proba(dict)
	som=0
	res = filter(tuple -> startswith(first(tuple), "a"), dict)
	for (key, value) in res
		println(key," ",value)
		som=som+value
	end
	for (key, value) in res
		dict[key]=value/som
	end
	for (key, value) in dict
		println(key," ",value)
	end
			
	
	
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
	proba(dict)
	print("cpt",cpt)
	for (key, value) in dict
		dict[key]=dict[key]/cpt
	end
	println(filter(tuple -> startswith(first(tuple), "a"), dict))
end


			
