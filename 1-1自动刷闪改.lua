--自动刷闪脚本
--★★★需要1.4.5版本才可以运行，请等待更新★★★
--只需自行设置需要刷的船名
--会自动上1-3级的轻巡和驱逐陪练2个 无需再改陪练设置
--不会处理新捞到的小船，如果要刷很多只船，最好留一些空位，留俩1级的小船
--[20151119]优化 如果没有符合条件要刷的船 如果该条件还有次数剩余 会自动跳出
--[20151119]增加 找船误差设置，如果无法正确识别大部分船，请提高误差
------------建议误差不超过默认的2倍
--[20151121]修正 队伍设置只对出击有效的问题
---------------------------------------------------------------------------------
--这里是设置区域
Kan.DelBattleInfo()
Kan.AddBattleInfo(1,1,false,false)
Kan.AddBattleInfo(2,1,true,false)
--每个点的战斗设置 一般不用改

m_count = 3
--单船刷闪的次数，3次出击可到85闪

m_team_id = 1
--出击的队伍ID

m_flash_kan = {}
--不要修改

---------------------------------------------------------------------------------

--Base.SetConfig("ChangeNameSiteString", 20)
--定义检测编成中船名字的误差值 默认为20 如需修改，请取消上一行注释 需要1.4.8版本

--Base.SetConfig("ChangeNameSiteNum",9)
--定义检测编成中船等级的误差值 默认为9 如需修改，请取消上一行注释 需要1.4.8版本

--以上两个设置请在无法正确识别等级或船名字的情况下修改

---------------------------------------------------------------------------------
--★★★请在这里自行设置需要刷的船名 

--在KanAuto顶部的小船按钮中可以帮助你快速添加该项目 
--刷之前记得给会刷到的船上装备哦，特别是空母的飞机
--可以添加多条

--这里是添加一个广泛的条件，正规空母和装甲空母，刷完后刷战舰，等级80-150，刷10艘
--支持正则表达式
--table.insert(m_flash_kan,{name="夕立改二", min_lv=69, max_lv=79,  count=3});
--table.insert(m_flash_kan,{name="木曾改", min_lv=38, max_lv=48,  count=3});
--table.insert(m_flash_kan,{name="长月改", min_lv=29, max_lv=39,  count=3});
--table.insert(m_flash_kan,{name="文月改", min_lv=27, max_lv=37,  count=3});
table.insert(m_flash_kan,{name="月月改", min_lv=28, max_lv=38,  count=3});
--table.insert(m_flash_kan,{name="如月改", min_lv=26, max_lv=36,  count=3});
table.insert(m_flash_kan,{name="睦月改", min_lv=26, max_lv=36,  count=3});



--其他例子：
--table.insert(m_flash_kan,{name="岛风改", min_lv=80, max_lv=150, count=1})
--添加一个单体的条件，岛风改，等级80-150，刷1艘，如果定义船名，请设置刷1次

--table.insert(m_flash_kan,{name=".*", min_lv=80, max_lv=150, count=10})
--添加一个广泛的条件，会选择所有的80-150级船去刷10次

---------------------------------------------------------------------------------
Base.SetConfig("Sleep+?",100) --所有延时随机增加1-100


function SupplyAllStringMatch(_str)
    local t2 = { string.match(_str , "^(-?%d+),(-?%d+),(-?%d+),(-?%d+)|(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --将返回的数据匹配到表中
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --转为数值
    Base.Print(string.format("舰队状态:%d %d %d %d",t[1],t[2],t[3],t[4]))
    Base.Print(string.format("第一舰队单船状态:%d %d %d %d %d %d",t[5],t[6],t[7],t[8],t[9],t[10]))
        
    return t
end

function ChangeKanMain(_name, _min_lv, _max_lv)
	Win.Print('Main切换船只' .. _name)
	
	Kan.DelAllKanChangeColor()
	
	Kan.AddKanChangeName(_name, _min_lv, _max_lv, false, 2, 1,false,true)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_LV, 7, true)
	
	if ret == 1 then --可以改写失败了换别的船
		return true
	end
	return false
end

function ChangeKanAll(_name, _min_lv, _max_lv)
	Win.Print('切换船只' .. _name)
	
	Kan.DelAllKanChangeColor()
	
	Kan.AddKanChangeName(_name, _min_lv, _max_lv, false, 2, 1)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_LV, 7, true)

	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("^(驱逐舰).*", 1, 3, true, 0, 2, true)
	Kan.AddKanChangeName("^(驱逐舰).*", 1, 3, true, 0, 3, true)
	ret2 = Kan.ChangeDIY(1, m_team_id, C.SORT_NEW, 15, true)
	
	if ret == 1 and ret2 == 2 then --可以改写失败了换别的船
		return true
	end
	return false
end

function ChangeKanMin() --切换小船
	Win.Print('切换小船')
	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("^(驱逐舰).*", 1, 3, true, 0, 2, true)
	Kan.AddKanChangeName("^(驱逐舰).*", 1, 3, true, 0, 3, true)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_NEW, 15, false)
	
	if ret == 2 then --可以改写失败了换别的船
		return true
	end
	return false
end

function GoGoFlash()

for n = 1, m_count do --循环次数
    a = "开始第:%d次"
    Win.Print(a:format(n))
    
    ret = Base.CallFunc("Kan.SupplyAll") --补给全部并返回所有数据
    Base.Print(ret)
    
    t = SupplyAllStringMatch(ret) --返回的文本转到table

	kan_2_id = 2 + (m_team_id-1)*6 + 4
	kan_3_id = 3 + (m_team_id-1)*6 + 4
	kan_1_id = 1 + (m_team_id-1)*6 + 4
	if t[kan_2_id] == C.KAN_STATE_MAX or t[kan_2_id] == C.KAN_STATE_MID then --判断第2位置
		--小船的状态不适合继续刷
		if ChangeKanMin() == false then
			Win.Print('没有可换的小船！')
			break
		end
		ret = Base.CallFunc("Kan.SupplyAll") --补给全部并返回所有数据
	end
	
	if t[kan_3_id] == C.KAN_STATE_MAX or t[kan_3_id] == C.KAN_STATE_MID then --判断第3位置
		 --小船的状态不适合继续刷
		Win.Print('小船状态不佳')
		if ChangeKanMin() == false then
			Win.Print('没有可换的小船！')
			break
		end
		ret = Base.CallFunc("Kan.SupplyAll")
	end
	
	
	if t[kan_1_id] == C.KAN_STATE_MAX or t[kan_1_id] == C.KAN_STATE_MID then --判断旗舰
		Win.Print('大船中破或大破，停止该船刷闪，换船')
		break
	end
	
    if t[m_team_id] == -1 then
        Win.Pop('补给不足 脚本停止！',true)
        break
    end

    Kan.Sally(1, 1)
    
    if Kan.BattleEx(m_team_id, m_count) == false then
		
    else
		
    end
    
    Kan.WaitHome(2000)
    Base.Sleep(2000)
end

end --gogo结束

--从这里开始运行
for key,value in pairs(m_flash_kan) do  
	Win.Print('当前条件' .. value["name"])
	for n=1,value["count"] do
		if ChangeKanMain(value["name"], value["min_lv"], value["max_lv"]) == true then
			if ChangeKanMin() == true then
				Win.Print('换船成功，开始刷闪战斗')
				GoGoFlash()
			else
				Win.Print('没有符合条件的小船供替换！')
				break
			end
		else
			Win.Print('没有找到符合条件的船！')
			break
		end
	end
end


Win.Pop('脚本执行完毕！')