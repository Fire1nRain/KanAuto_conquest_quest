--设定参数
k2_conquest = C.東京急行_ID37
k3_conquest = C.防空射撃演習_ID6

--等待次数
waitCount = 0

checkQuest = true

--函数
function gotoQuest()
	Kan.WaitHomeEx(500,3*60*1000)
	Win.Print("点击母港任务")
	Base.Click(555,51) --点击母港任务
	ret = Base.WaitColor("[[660,475,4081991],[688,475,7376854]]","任务",400,30000,100)
	if ret == true then Base.Click(579,209) end
	return ret
end

function waitLoading()
	ret = Base.WaitColor("[[172,476,15395305],[774,475,14478322]]","载入完成",500,30000,100)
	return ret
end

function waitReward()
	ret = Base.WaitColor("[[375,399,10460707],[400,402,9211167],[435,403,10460707]]","奖励界面",500,30000,100)
	if ret == true then
		Base.Click(399,400)
	end
	return ret
end

function IsForward()

	if Base.ImageHashContrast(Base.ImageHash(289,453,20,20),"FFFFE9C101C1E9FF") < 10 then
		return true
	else
		return false
	end
end

function findIcon(_str)
	return Base.CallFunc("Base.FindColorExAllBin", _str)
end

function findTarget(_target,_ongoing,_finished)
	questStat = -1
	_x = 0
	_y = 0
	if _target ~= nil then --没有找到的话 返回值为nil 需要判断 否则出错
		
		questStat = 0
		
		for k, v in string.gmatch(_target, "(%d+),(%d+)") do
			_x = tonumber(k)
			_y = tonumber(v)
		end
		Win.Print("找到任务坐标：".._x..",".._y)
		
		if _ongoing ~= nil then
			for k, v in string.gmatch(_ongoing, "(%d+),(%d+)") do
				Win.Print("找到进行中："..k..","..v)
				if _y - tonumber(v) <15 and _y - tonumber(v) > -15 then
					questStat = 1
					break
				end
	        end
		end
		
		if _finished ~= nil then
			for k, v in string.gmatch(_finished, "(%d+),(%d+)") do
				Win.Print("找到已完成："..k..","..v)
				if _y - tonumber(v) <15 and _y - tonumber(v) > -15 then
					questStat = 2
					break
				end
	        end
		end
	end
	return questStat,_x,_y
end

function tryQuest()

	waitCount = 0
	
	ret = gotoQuest()
	if ret == true then
	
		Base.Sleep(1000)
			
		Base.Click(651,460) --到任务最后一页
		
		Base.Sleep(500)
			
		ret = waitLoading()
		if ret == true then
		
			Base.Sleep(500)
			
			Base.Print("载入完成")
			
			while true do --如果有向前翻页的箭头 就进入循环
				
				Base.Sleep(500)
				
				--找远征任务
				conquest = findIcon("[3,145,\"1QBH4NV,1UTU1\",\"1Q694GV,1QDOV\"]")
		
				--找进行中图标
				ongoing = findIcon("[3,250,	\"19RVOCF,17SPU\",\"19UC0C3,160P6\"]")
				
				--找到完成图标
				finished = findIcon("[3,210,\"101HG2R,1V1G1\",\"101HG3T,1P003\"]")
				
				questStat,x,y = findTarget(conquest,ongoing,finished)
				
				--如果任务存在且还没接受
				if questStat == 0 then
				
					Win.Print("接受任务："..x..","..y)
					Base.Click(x,y)
					ret = waitLoading()
					if ret == false then
						Win.Print("载入超时！after click")
						break
					end
				
				--如果任务已完成
				elseif questStat == 2 then
					
					Win.Print("完成任务："..x..","..y)
					Base.Click(x,y)
					ret = waitReward()
					if ret == false then
						Win.Print("载入超时！after finish")
						break
					end
					ret = waitLoading()
					if ret == false then
						Win.Print("载入超时！ after finish2")
						break
					end
				end
				--只要任务被找到，就跳出循环
				if questStat >= 0 then
					Win.Print("返回母港")
					Kan.GoHome()
					break
				end
				
				
				Win.Print("翻页")
				Base.Sleep(500)
				Base.Click(297,463) --向前翻页
				Base.Sleep(500)
				
				ret = waitLoading()
				if ret == false then
					Win.Print("载入超时！ after paging")
					break
				end
				
				Base.Sleep(500)
				
				if IsForward() == false then
					Win.Print("到达首页")
					break
				end
			end
		else
			Win.Print("载入超时！on last page")
		end
	else
		Win.Print("无法打开任务列表！")
	end	
	Kan.GoHome()
	return questFound
end

Kan.EasyConquestInit(60*5,60*7)
Kan.EasyConquestRun()
 
while true do
	Kan.RepairEx(4,0,1+2+4+8)
	--如果标记为接受任务，且时间在JST5点更新任务后，则每次循环检查任务
	if checkQuest == true and Base.CheckHour("[[6,18]]") == true then
		hasQuest = tryQuest()
		Kan.WaitHomeEx(500.10000)
	end
	Kan.EasyConquestWaitNextRun()
end