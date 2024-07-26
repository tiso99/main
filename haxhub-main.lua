--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   SKIDD HELL NAWWW, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			local FlatIdent_7126A = 0;
			while true do
				if (FlatIdent_7126A == 0) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local FlatIdent_12703 = 0;
				local b;
				while true do
					if (FlatIdent_12703 == 0) then
						b = Rep(a, repeatNext);
						repeatNext = nil;
						FlatIdent_12703 = 1;
					end
					if (FlatIdent_12703 == 1) then
						return b;
					end
				end
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local FlatIdent_475BC = 0;
			local Res;
			while true do
				if (FlatIdent_475BC == 0) then
					Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
					return Res - (Res % 1);
				end
			end
		else
			local FlatIdent_60EA1 = 0;
			local Plc;
			while true do
				if (FlatIdent_60EA1 == 0) then
					Plc = 2 ^ (Start - 1);
					return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
				end
			end
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local FlatIdent_31A5A = 0;
		local Str;
		local FStr;
		while true do
			if (FlatIdent_31A5A == 2) then
				FStr = {};
				for Idx = 1, #Str do
					FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
				end
				FlatIdent_31A5A = 3;
			end
			if (FlatIdent_31A5A == 1) then
				Str = Sub(ByteString, DIP, (DIP + Len) - 1);
				DIP = DIP + Len;
				FlatIdent_31A5A = 2;
			end
			if (FlatIdent_31A5A == 3) then
				return Concat(FStr);
			end
			if (FlatIdent_31A5A == 0) then
				Str = nil;
				if not Len then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
				end
				FlatIdent_31A5A = 1;
			end
		end
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local FlatIdent_104D4 = 0;
		local Instrs;
		local Functions;
		local Lines;
		local Chunk;
		local ConstCount;
		local Consts;
		while true do
			if (FlatIdent_104D4 == 1) then
				ConstCount = gBits32();
				Consts = {};
				for Idx = 1, ConstCount do
					local FlatIdent_40CF = 0;
					local Type;
					local Cons;
					while true do
						if (FlatIdent_40CF == 0) then
							Type = gBits8();
							Cons = nil;
							FlatIdent_40CF = 1;
						end
						if (FlatIdent_40CF == 1) then
							if (Type == 1) then
								Cons = gBits8() ~= 0;
							elseif (Type == 2) then
								Cons = gFloat();
							elseif (Type == 3) then
								Cons = gString();
							end
							Consts[Idx] = Cons;
							break;
						end
					end
				end
				Chunk[3] = gBits8();
				FlatIdent_104D4 = 2;
			end
			if (2 == FlatIdent_104D4) then
				for Idx = 1, gBits32() do
					local Descriptor = gBits8();
					if (gBit(Descriptor, 1, 1) == 0) then
						local FlatIdent_79536 = 0;
						local Type;
						local Mask;
						local Inst;
						while true do
							if (FlatIdent_79536 == 3) then
								if (gBit(Mask, 3, 3) == 1) then
									Inst[4] = Consts[Inst[4]];
								end
								Instrs[Idx] = Inst;
								break;
							end
							if (FlatIdent_79536 == 2) then
								if (gBit(Mask, 1, 1) == 1) then
									Inst[2] = Consts[Inst[2]];
								end
								if (gBit(Mask, 2, 2) == 1) then
									Inst[3] = Consts[Inst[3]];
								end
								FlatIdent_79536 = 3;
							end
							if (FlatIdent_79536 == 0) then
								Type = gBit(Descriptor, 2, 3);
								Mask = gBit(Descriptor, 4, 6);
								FlatIdent_79536 = 1;
							end
							if (FlatIdent_79536 == 1) then
								Inst = {gBits16(),gBits16(),nil,nil};
								if (Type == 0) then
									local FlatIdent_25DF3 = 0;
									while true do
										if (FlatIdent_25DF3 == 0) then
											Inst[3] = gBits16();
											Inst[4] = gBits16();
											break;
										end
									end
								elseif (Type == 1) then
									Inst[3] = gBits32();
								elseif (Type == 2) then
									Inst[3] = gBits32() - (2 ^ 16);
								elseif (Type == 3) then
									local FlatIdent_5BA5E = 0;
									while true do
										if (FlatIdent_5BA5E == 0) then
											Inst[3] = gBits32() - (2 ^ 16);
											Inst[4] = gBits16();
											break;
										end
									end
								end
								FlatIdent_79536 = 2;
							end
						end
					end
				end
				for Idx = 1, gBits32() do
					Functions[Idx - 1] = Deserialize();
				end
				return Chunk;
			end
			if (FlatIdent_104D4 == 0) then
				Instrs = {};
				Functions = {};
				Lines = {};
				Chunk = {Instrs,Functions,nil,Lines};
				FlatIdent_104D4 = 1;
			end
		end
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				local FlatIdent_324DE = 0;
				while true do
					if (FlatIdent_324DE == 1) then
						if (Enum <= 3) then
							if (Enum <= 1) then
								if (Enum > 0) then
									Stk[Inst[2]]();
								else
									local FlatIdent_7909D = 0;
									local A;
									while true do
										if (FlatIdent_7909D == 0) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											break;
										end
									end
								end
							elseif (Enum > 2) then
								local FlatIdent_64E40 = 0;
								local Edx;
								local Results;
								local Limit;
								local B;
								local A;
								while true do
									if (FlatIdent_64E40 == 0) then
										Edx = nil;
										Results, Limit = nil;
										B = nil;
										A = nil;
										FlatIdent_64E40 = 1;
									end
									if (5 == FlatIdent_64E40) then
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										FlatIdent_64E40 = 6;
									end
									if (FlatIdent_64E40 == 3) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_64E40 = 4;
									end
									if (FlatIdent_64E40 == 1) then
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										FlatIdent_64E40 = 2;
									end
									if (6 == FlatIdent_64E40) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										FlatIdent_64E40 = 7;
									end
									if (7 == FlatIdent_64E40) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]]();
										VIP = VIP + 1;
										FlatIdent_64E40 = 8;
									end
									if (8 == FlatIdent_64E40) then
										Inst = Instr[VIP];
										do
											return;
										end
										break;
									end
									if (FlatIdent_64E40 == 2) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_64E40 = 3;
									end
									if (FlatIdent_64E40 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_64E40 = 5;
									end
								end
							else
								do
									return;
								end
							end
						elseif (Enum <= 5) then
							if (Enum > 4) then
								Stk[Inst[2]] = Env[Inst[3]];
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum == 6) then
							Stk[Inst[2]] = Inst[3];
						else
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
						VIP = VIP + 1;
						break;
					end
					if (0 == FlatIdent_324DE) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_324DE = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!043O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034A3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F7469736F2O392F4861784875624C6F616465722F6D61696E2F6861786875622D6D61696E2E6C756100083O0012033O00013O00122O000100023O00202O00010001000300122O000300046O000100039O0000026O000100016O00017O00", GetFEnv(), ...);
