DuduPool = {}
dp_mt = {__index = DuduPool}
-- setmetatable(DuduPool, DuduPool)

function DuduPool:new()
	p = {}
	setmetatable(p, dp_mt)
	return p
end

function DuduPool:Init(new, onCollect, onReuse)
	self.container = {}
	self.new = new
	self.onCollect = onCollect
	self.onReuse = onReuse
end

function DuduPool:Get()
	if #self.container > 0 then
		local r = self.container[#self.container]
		self.container[#self.container] = nil
		if self.onReuse ~= nil then
			self.onReuse(r)
		end
		return r
	else
		local r = self.new()
		if self.onReuse ~= nil then
			self.onReuse(r)
		end
		return r
	end
end

function DuduPool:Collect( item )
	self.container[#self.container+1] = item
	if self.onCollect ~= nil then
		self.onCollect(item)
	end
end


return DuduPool