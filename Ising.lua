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
   L = {}
   for i = 1, M do
      L[i] = {}
      for j = 1, N do
	 L[i][j] = {}
	 for k = 1, K do
	    L[i][j][k] = math.random(2) == 1 and 1 or -1
	 end
      end
   end

   return o
end

function Lattice:RandomPoint()
   m = math.random(self.M)
   n = math.random(self.N)
   k = math.random(self.K)
   return m, n, k
end

function Lattice:Clipto(i, l)
   i1 = i
   if i > l - 1 then
      i1 = 0
   elseif i < 0 then
      i1 = l - 1
   end
   return i1
end

function Lattice:SpinEnergy()
   for i = m, m + 1, 1 do
      for j = n, 1,2 do
	 for l = -1,1,2 do
	    Clipto(i, M)
	    Clipto(j, N)
	    Clipto(l, K)
	    E = E - J * L[m][n][k] * L[i][j][l]
	 end
      end
   end

   return -1
end

function Lattice:SpinUHEnergy(m, n, k)

   E = 0

   return E
end

function Lattice:Energy()

   E = 0
   for i = 1,N do
      for j = 1,N do
	 for k = 1,K do
	    E = E + SpinUHEnergy(i, j, k)
	 end
      end
   end

   return E
end

function Lattice:GetSpin(m, n, k)
   return L[m][n][k]
end

-- ismc = Lattice:New(nil, 10, 10, 10, 1.2, 1)
-- print(ismc.M)
-- print(ismc:GetSpin(5,4,6))
