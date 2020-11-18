--[[---------------------------------------------------------------------------------------

	Wraith ARS 2X
	Created by WolfKnight
	
	For discussions, information on future updates, and more, join 
	my Discord: https://discord.gg/fD4e6WD 
	
	MIT License

	Copyright (c) 2020 WolfKnight

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

---------------------------------------------------------------------------------------]]--

-- Branding!
local label = 
[[ 
  //
  ||    __          __        _ _   _                _____   _____   ___ __   __
  ||    \ \        / /       (_) | | |         /\   |  __ \ / ____| |__ \\ \ / /
  ||     \ \  /\  / / __ __ _ _| |_| |__      /  \  | |__) | (___      ) |\ V / 
  ||      \ \/  \/ / '__/ _` | | __| '_ \    / /\ \ |  _  / \___ \    / /  > <  
  ||       \  /\  /| | | (_| | | |_| | | |  / ____ \| | \ \ ____) |  / /_ / . \ 
  ||        \/  \/ |_|  \__,_|_|\__|_| |_| /_/    \_\_|  \_\_____/  |____/_/ \_\
  ||
  ||                             Created by WolfKnight
  ||]]

-- Returns the current version set in fxmanifest.lua
function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end