--=========================参数设置===========================
--肝船列表，第一位是打手
shipList = {
	{name="轻巡洋舰五十铃改二",minLv=54,maxLv=64},
	{name="驱逐舰朝潮改",minLv=62,maxLv=70},
	{name="驱逐舰晓改",minLv=53,maxLv=64},
	{name="驱逐舰响改",minLv=35,maxLv=45}
}

--设定想要进行的远征
k2_conquest = C.海上護衛任務_ID5
k3_conquest = C.防空射撃演習_ID6
k4_conquest = C.北方鼠輸送作戦_ID21

--战斗次数 50-70 随机
math.randomseed(os.time())
f_count = math.random(30,50) 
Win.Print("开始运行，本次将出击"..f_count.."次")

--每10-15分钟检测一次远征
Kan.EasyConquestInit(60*10,60*15)

--所有延时随机增加1-100
Base.SetConfig("Sleep+?",100)

--出击连续失败计数
consecFail = 0

--是否是完整队伍
fullteam = true

--轮换计数
roster = 0

--上轮出击是否有中破+
notGood = false


--统计出击结果
m_lv = {SS=0,S=0,A=0,B=0,C=0,D=0,ALL=0,ERROR=0}

--=========================调用函数===========================
--统计战斗评级
function CheckLv()
	count = Base.GetValueInt("LastBattleCount")
	Base.Print("LastBattleCount:"..count)
	if count > 0 then
		m_lv.ALL = m_lv.ALL+count
		for n=1,count do
			ret = Base.GetValueInt("Battle_Lv_"..n)
			if ret == C.WIN_SS then
				m_lv.SS = m_lv.SS+1
			elseif  ret == C.WIN_S then
				m_lv.S = m_lv.S+1
			elseif  ret == C.WIN_A then
				m_lv.A = m_lv.A+1
			elseif  ret == C.WIN_B then
				m_lv.B = m_lv.B+1
			elseif  ret == C.WIN_C then
				m_lv.C = m_lv.C+1
			elseif  ret == C.WIN_D then
				m_lv.D = m_lv.D+1
			elseif  ret == C.WIN_ERROR then
				m_lv.ERROR = m_lv.ERROR+1
			end
			
		end
	end
	Win.SetState("累计战斗:"..m_lv.ALL.." SS:"..m_lv.SS.."  S:"..m_lv.S.."  A:"..m_lv.A.."  B:"..m_lv.B.."  C:"..m_lv.C.."  D:"..m_lv.D)
end

--解析Supply函数返回值
function SupplyStringMatch(_str)
    local t2 = { string.match(_str , "^(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --将返回的数据匹配到表中
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --转为数值
    return t
end

--编入所有舰娘
--_shipList是舰娘列表，_good表示是插入完好舰娘还是所有舰娘
function changeAll(_shipList,_good)

	Kan.DelAllKanChangeColor()
	for i=1,#_shipList do
		--旗舰首先尝试添加不再闪的打手，然后按定义顺序尝试加入舰娘
		if i==1 then
		--添加不闪打手
			Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,2,i,false,true)
		
		--末位首先尝试添加闪打手，然后按定义顺序尝试加入舰娘	
		elseif i==#_shipList then
			--添加闪打手
			Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,1,i)
		end
		
		--其他位置随意添加其他舰娘
		for j=2,#_shipList do
			Kan.AddKanChangeName(_shipList[j].name,_shipList[j].minLv,_shipList[j].maxLv,_good,0,i)
		end
		
		--确保打手被编入队伍
		Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,0,i)
	end
	
	--别忘记运行换船
	ret = Kan.ChangeDIY(1,1,C.SORT_LV,3,true)
	return ret
end

--=========================程序本体===========================
--初始化数据和显示
CheckLv()
--初始化舰娘
changeAll(shipList,false)
--开始远征
Kan.EasyConquestRun(false)
--出击计数器
f_count_now = 1
--开始主体循环
--两层循环，用于实现类似continue的效果
while true do
while true do
	
	Win.Print("开始第"..f_count_now.."次出击..")
	
	--补给
	ret = Base.CallFunc("Kan.Supply")
	t = SupplyStringMatch(ret)
	for i=1,#t do
		if t[i] ~= C.KAN_STATE_OK and t[i] ~= C.KAN_STATE_MIN then
			notGood = true
			break
		end
	end
	if notGood == true then
		ret = changeAll(shipList,true)
		notGood = false
		
		--如果只换上了一艘船，则跳过当前循环，并且连续失败次数加一
		if ret <= 1 then
			Win.Print("编队中人数过少，尝试修理所有单位后再出击")
			Kan.RepairEx(4,0,1+2+4+8)
			consecFail = consecFail + 1
			break
		end
		
	end
	
	--准备就绪，开始肝
	Kan.Sally(1,5)
	--出击，如果失败，则
	if Kan.Battle(1,2,false,5) == false then
		Win.Print("出击失败..")
		Kan.RepairEx(4,0,4+8)
		consecFail = consecFail + 1
	--如果出击成功，则
	else
		Win.Print("第"..f_count_now.."次出击成功")
		--更新状态
		CheckLv()
		--出击成功则次数+1
		f_count_now = f_count_now + 1
		--重置连续失败计数
		consecFail = 0
	end
	
	if consecFail >= 3 then
		Win.Print("出击连续失败，等待一次远征后再出击")
		Kan.EasyConquestWaitNextRun()
		consecFail = 0
	else
		Win.Print("远征一次")
		--尝试一次远征
		Kan.EasyConquestRun(false)
	end
	
	--如果队伍之前不是满的或者已到轮换次数，那么重新填满队伍
	if fullteam == false or roster > 4 then
		changeAll(shipList,false)
		roster = 0
		--如果只换上了一艘船，则跳过当前循环，并且连续失败次数加一
		if ret <= 1 then
			Kan.RepairEx(4,0,4+8)
			consecFail = consecFail + 1
			break
		end
	else
		Win.Print("距离轮换还有"..4-roster.."场")
		roster = roster + 1
	end
	
	if f_count_now > f_count then
		Win.Print("到达出击次数上限，不再出击!")
		break
	end
end
	--跳出第二个循环，彻底结束
	if f_count_now > f_count then
		Win.Print("到达出击次数上限，不再出击!")
		break
	end
end
--不再肝船，只远征
Win.Print("开始专心远征...")
Kan.EasyConquestEnterLoop()