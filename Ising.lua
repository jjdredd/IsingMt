-- print("Hello", math.exp(0))

local IsingMC = {}


Lattice = {L = {}, M = 10, N = 10, K = 10, J = 1.23, beta = 0.9}

function Lattice:New (o, M, N, K, J, beta)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   M = M or 10
   N = N or 10
   K = K or 10
   J = J or 1.23
   beta = beta or 0.9
   
   math.randomseed(os.time())
   self.L = {}
   for i = 0, M - 1 do
      self.L[i] = {}
      for j = 0, N - 1 do
	 self.L[i][j] = {}
	 for k = 0, K - 1 do
	    self.L[i][j][k] = math.random(2) == 1 and 1 or -1
	 end
      end
   end

   return o
end

function Lattice:RandomPoint()
   m = math.random(0, self.M - 1)
   n = math.random(0, self.N - 1)
   k = math.random(0, self.K - 1)
   return m, n, k
end

function Lattice:Clipto(i, l)
   local i1 = i
   if i > l - 1 then
      i1 = 0
   elseif i < 0 then
      i1 = l - 1
   end
   return i1
end

function Lattice:SpinEnergy(m, n, k)
   local E = 0
   for i = m - 1, m + 1, 2 do
      local x = self:Clipto(i, self.M)
      E = E - self.J * self.L[m][n][k] * self.L[x][n][k]
   end

   for j = n - 1, n + 1, 2 do
      local y = self:Clipto(j, self.N)
      E = E - self.J * self.L[m][n][k] * self.L[m][y][k]
   end

   for l = k - 1, k + 1, 2 do
      local z = self:Clipto(l, self.K)
      E = E - self.J * self.L[m][n][k] * self.L[m][n][z]
   end

   return E
end

function Lattice:SpinUHEnergy(m, n, k)

   local E = 0

   i = self:Clipto(m + 1, self.M)
   E = E - self.J * self.L[m][n][k] * self.L[i][n][k]

   j = self:Clipto(n + 1, self.N)
   E = E - self.J * self.L[m][n][k] * self.L[m][j][k]
   
   l = self:Clipto(k + 1, self.K)
   E = E - self.J * self.L[m][n][k] * self.L[m][n][l]

   return E
end

function Lattice:Energy()

   local E = 0
   for i = 0, self.M - 1 do
      for j = 0, self.N - 1 do
	 for k = 0, self.K - 1 do
	    E = E + self:SpinUHEnergy(i, j, k)
	 end
      end
   end

   return E
end

function Lattice:EnergyDiff(m, n, k)
   return - 2 * self:SpinEnergy(m, n, k)
end

function Lattice:Step()
   while true do
      m, n, k = self:RandomPoint()
      de = self:EnergyDiff(m, n, k)
      if de < 0 or math.random() < math.exp(- self.beta * de) then
	 self.L[m][n][k] = - self.L[m][n][k]
	 break
      end
   end
end

function Lattice:GetSpin(m, n, k)
   return self.L[m][n][k]
end

local M = 50
local N = 50
local K = 50
local J = 1.24
local beta = 2.6

ismc = Lattice:New(nil, M, N, K, J, beta)
 -- print(ismc:GetSpin(5,4,6))
while ismc:Energy() > -3500 do
   for i = 1, 100 do
      ismc:Step()
   end
   print(ismc:Energy())
end
