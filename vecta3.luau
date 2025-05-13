--!strict

local Vecta3 = {}

Vecta3.interface = {}
Vecta3.schema = {}
Vecta3.metatable = { __index = Vecta3.schema }

type Vecta3Object = { X: number, Y: number, Z: number, Magnitude: number, Unit: any }
export type Vecta3 = typeof(setmetatable({} :: Vecta3Object, {} :: typeof(Vecta3.metatable)))

--interface-----------------------------------------------------------------------------------------

--[[
returns a new vecta3 object with the given components
]]
function Vecta3.interface.new(X: number, Y: number, Z: number): Vecta3
	local self = { X = X, Y = Y, Z = Z }
	self.Magnitude = math.sqrt(self.X ^ 2 + self.Y ^ 2 + self.Z ^ 2)
	setmetatable(self, Vecta3.metatable)
	return table.freeze(self)
end

--[[
returns a new vecta3 object in the given direction with a magnitude of 1
]]
function Vecta3.interface.FromNormalId(normal: Enum.NormalId): Vecta3
	local cases = {
		[Enum.NormalId.Back] = Vecta3.interface.new(-1, 0, 0),
		[Enum.NormalId.Bottom] = Vecta3.interface.new(0, -1, 0),
		[Enum.NormalId.Front] = Vecta3.interface.new(1, 0, 0),
		[Enum.NormalId.Left] = Vecta3.interface.new(0, 0, -1),
		[Enum.NormalId.Right] = Vecta3.interface.new(0, 0, 1),
		[Enum.NormalId.Top] = Vecta3.interface.new(0, 1, 0),
	}
	return cases[normal]
end

--[[
returns a new vecta3 object with a value of 1 on the given axis
]]
function Vecta3.interface.FromAxis(axis: Enum.Axis): Vecta3
	local cases = {
		[Enum.Axis.X] = Vecta3.interface.new(1, 0, 0),
		[Enum.Axis.Y] = Vecta3.interface.new(0, 1, 0),
		[Enum.Axis.Z] = Vecta3.interface.new(0, 0, 1),
	}
	return cases[axis]
end

Vecta3.interface.one = Vecta3.interface.new(1, 1, 1)
Vecta3.interface.zero = Vecta3.interface.new(0, 0, 0)
Vecta3.interface.xAxis = Vecta3.interface.new(1, 0, 0)
Vecta3.interface.yAxis = Vecta3.interface.new(0, 1, 0)
Vecta3.interface.zAxis = Vecta3.interface.new(0, 0, 1)

--schema--------------------------------------------------------------------------------------------

--[[
same vecta3 object, but with a magnitude of 1
]]
function Vecta3.schema.Unit(self: Vecta3): Vecta3
	return self / self.Magnitude
end

--[[
returns the absolute values of the components of the vecta3
]]
function Vecta3.schema.Abs(self: Vecta3): Vecta3
	return Vecta3.interface.new((math.abs(self.X)), (math.abs(self.Y)), (math.abs(self.Z)))
end

--[[
returns a vecta3 with the components rounded up
]]
function Vecta3.schema.Ceil(self: Vecta3): Vecta3
	return Vecta3.interface.new((math.ceil(self.X)), (math.ceil(self.Y)), (math.ceil(self.Z)))
end

--[[
returns a vecta3 with the components rounded down
]]
function Vecta3.schema.Floor(self: Vecta3): Vecta3
	return Vecta3.interface.new((math.floor(self.X)), (math.floor(self.Y)), (math.floor(self.Z)))
end

--[[
returns a vecta3 with the components rounded
]]
function Vecta3.schema.Round(self: Vecta3): Vecta3
	return Vecta3.interface.new((math.round(self.X)), (math.round(self.Y)), (math.round(self.Z)))
end

--[[
returns the signs (-1, 0, 1) of a vecta3 based on its components
]]
function Vecta3.schema.Sign(self: Vecta3): Vecta3
	return Vecta3.interface.new((math.sign(self.X)), (math.sign(self.Y)), (math.sign(self.Z)))
end

--[[
returns the cross product between the two vecta3 objects
]]
function Vecta3.schema.Cross(self: Vecta3, other: Vecta3): Vecta3
	return Vecta3.interface.new(
		(self.Y * other.Z - other.Y * self.Z),
		(self.Z * other.X - other.Z * self.X),
		(self.X * other.Y - other.X * self.Y)
	)
end

--[[
returns the dot product between the two vecta3 objects
]]
function Vecta3.schema.Dot(self: Vecta3, other: Vecta3): number
	return (self.X * other.X) + (self.Y * other.Y) + (self.Z * other.Z)
end

--[[
returns the angle between the two vecta3 objects in radians
]]
function Vecta3.schema.Angle(self: Vecta3, other: Vecta3): number
	local dot = (self.X * other.X) + (self.Y * other.Y) + (self.Z * other.Z)
	return math.acos(dot / (self.Magnitude * other.Magnitude))
end

--[[
returns true if the difference of the squared magnitudes does not exceed epsilon
]]
function Vecta3.schema.FuzzyEq(self: Vecta3, other: Vecta3, epsilon: number?): boolean
	epsilon = epsilon or 1e-5
	return (self.Magnitude ^ 2 - other.Magnitude ^ 2) <= epsilon :: number
end

--[[
returns a vecta3 object between two given vecta3 objects. distance is dictated by alpha
]]
function Vecta3.schema.Lerp(self: Vecta3, other: Vecta3, alpha: number): Vecta3
	return Vecta3.interface.new(
		(self.X * (1 - alpha) + other.X * alpha),
		(self.Y * (1 - alpha) + other.Y * alpha),
		(self.Z * (1 - alpha) + other.Z * alpha)
	)
end

--[[
returns a vecta3 object with each component as the highest among the respective components of both provided vecta3 objects.
]]
function Vecta3.schema.Max(self: Vecta3, other: Vecta3): Vecta3
	return Vecta3.interface.new(math.max(self.X, other.X), math.max(self.Y, other.Y), math.max(self.Z, other.Z))
end

--[[
returns a vecta3 object with each component as the lowest among the respective components of both provided vecta3 objects.
]]
function Vecta3.schema.Min(self: Vecta3, other: Vecta3): Vecta3
	return Vecta3.interface.new(math.min(self.X, other.X), math.min(self.Y, other.Y), math.min(self.Z, other.Z))
end

function Vecta3.schema.ToVector3(self: Vecta3): Vector3
	return Vector3.new(self.X, self.Y, self.Z)
end

--metatable-----------------------------------------------------------------------------------------

function Vecta3.metatable.__add(self: Vecta3, x: Vecta3): Vecta3
	return Vecta3.interface.new((self.X + x.X), (self.Y + x.Y), (self.Z + x.Z))
end

function Vecta3.metatable.__sub(self: Vecta3, x: Vecta3): Vecta3
	return Vecta3.interface.new((self.X - x.X), (self.Y - x.Y), (self.Z - x.Z))
end

function Vecta3.metatable.__mul(self: Vecta3, x: Vecta3 | number): Vecta3
	if typeof(x) == "number" then
		return Vecta3.interface.new((self.X * x), (self.Y * x), (self.Z * x))
	else
		return Vecta3.interface.new((self.X * x.X), (self.Y * x.Y), (self.Z * x.Z))
	end
end

function Vecta3.metatable.__div(self: Vecta3, x: Vecta3 | number): Vecta3
	if typeof(x) == "number" then
		return Vecta3.interface.new((self.X / x), (self.Y / x), (self.Z / x))
	else
		return Vecta3.interface.new((self.X / x.X), (self.Y / x.Y), (self.Z / x.Z))
	end
end

function Vecta3.metatable.__idiv(self: Vecta3, x: Vecta3 | number): Vecta3
	if typeof(x) == "number" then
		return Vecta3.interface.new((self.X // x), (self.Y // x), (self.Z // x))
	else
		return Vecta3.interface.new((self.X // x.X), (self.Y // x.Y), (self.Z // x.Z))
	end
end

function Vecta3.metatable.__pow(self: Vecta3, x: Vecta3 | number): Vecta3
	if typeof(x) == "number" then
		return Vecta3.interface.new((self.X ^ x), (self.Y ^ x), (self.Z ^ x))
	else
		return Vecta3.interface.new((self.X ^ x.X), (self.Y ^ x.Y), (self.Z ^ x.Z))
	end
end

function Vecta3.metatable.__mod(self: Vecta3, x: Vecta3 | number): Vecta3
	if typeof(x) == "number" then
		return Vecta3.interface.new((self.X % x), (self.Y % x), (self.Z % x))
	else
		return Vecta3.interface.new((self.X % x.X), (self.Y % x.Y), (self.Z % x.Z))
	end
end

function Vecta3.metatable.__eq(self: Vecta3, x: Vecta3): boolean
	if typeof(x) == typeof(Vecta3) then
		return (self.X == x.X and self.Y == x.Y and self.Z == x.Z)
	end
	return false
end

function Vecta3.metatable.__unm(self: Vecta3): Vecta3
	return Vecta3.interface.new(-self.X, -self.Y, -self.Z)
end

function Vecta3.metatable.__tostring(self: Vecta3): string -- "x, y, z"
	return (tostring(self.X) .. ", " .. tostring(self.Y) .. ", " .. tostring(self.Z))
end

return table.freeze(Vecta3.interface)
