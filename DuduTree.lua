DuduTree = {}

function DuduTree:Filter(raw)
	ret = ""
	current = self.tree
	matching = false
	censored = ""
	original = ""
	for uchar in string.gfind(raw, "([%z\1-\127\194-\244][\128-\191]*)") do
		if not matching then
			if current[uchar] ~= nil then
				matching = true
				current = current[uchar]
				censored = "*"
				original = uchar
			else
				ret = ret..uchar
			end
		else
			if current[uchar] ~= nil then
				current = current[uchar]
				censored = censored.."*"
				original = original..uchar
			else
				if current['end'] then
					ret = ret..censored
				else 
					ret = ret..original
				end
				if self.tree[uchar] ~= nil then
					current = self.tree[uchar]
					censored = "*"
					original = uchar
				else
					matching = false
					original = ""
					current = self.tree
					ret = ret..uchar
				end
			end
		end
	end
	if matching and current['end'] then
		ret = ret..censored
	else 
		ret = ret..original
	end
	return ret
end

function DuduTree:Build(words)
	self.tree = {}
	for _,word in pairs(words) do 
		self:AddToTree(word)
	end
end

function DuduTree:AddToTree(word)
	local current = self.tree
	for uchar in string.gfind(word, "([%z\1-\127\194-\244][\128-\191]*)") do
    	if current[uchar] == nil then
    		current[uchar] = {}
    	end
    	current = current[uchar]
    	-- table.insert(uchars,uchar)
    end	
    current['end'] = true
end

f_words = {'川普','伊万卡','黑奸','奥巴马','阿萨德','奥巴'}

DuduTree:Build(f_words)
print(DuduTree:Filter("阿阿萨阿萨德奥巴奥巴马黑-奸奥巴川普xijinping"))


return DuduTree