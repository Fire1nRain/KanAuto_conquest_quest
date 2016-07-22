--###################################################################
--这里是设置区域！请仔细阅读！！！！！ 然后再修改 
--如果设置区域读不懂 请按Alt+F4提高智商后再来

Base.SetConfig("FindColorBinDefSite", 4) 
--潜艇入渠容错，如果您的这个脚本开启了use_speed，但是会把潜艇也入渠，可调高此值（推荐5-8）


math.randomseed(os.time())
f_count = math.random(30,50) --战斗次数 50-70 随机
Win.Print("开始运行，本次将出击"..f_count.."次")
--战斗次数 满足战斗次数将会只远征

boosting = true
slow_count = 0
--闪五十铃

Kan.DelBattleInfo()
--清空战斗配置

Kan.AddBattleInfo(2,5,false,false)
--增加战斗配置，点2\阵型复纵\不夜战\不接受司令部退避(当前版本不支持)

use_speed = false
--修理时对 除潜艇外 的大破船是否使用桶，建议true

k2_conquest = C.防空射撃演習_ID6
k3_conquest = C.海上護衛任務_ID5
k4_conquest = C.北方鼠輸送作戦_ID21
--设置2、3、4队伍远征，可输入C.然后下拉选择

Kan.EasyConquestInit(60*5, 60*10)
--设置简易远征，每5-10分钟进行一次检测，1.5.3版本KCA才可以使用

run_hour = "[[0,23]]" 
--出击的时间设置 默认"[[0,23]]"为全天随时都执行，1.5.3版本KCA才可以使用
--设置举例："[8,10,[20,22]]" 为8、10、20、21、22为脚本出击时间

reset_battle_count = true 
--是否在每次等待到可执行的时间后重置战斗次数，1.5.3版本KCA才可以使用
--比如"[8,10,[20,22]]"的设置，会在8点，10点，20点进行重置

destroy_kan = false 
--是否在每次等待到可执行的时间后执行拆船
--比如"[8,10,[20,22]]"的设置，会在8点，10点，20点进行拆船

over_repair = true 
--是否在战斗次数满足后修船，需要设定远征才生效，1.5.3版本KCA才可以使用

Base.SetConfig("Sleep+?",100) --所有延时随机增加1-100
--###################################################################

m_lv = {SS=0,S=0,A=0,B=0,C=0,D=0,ALL=0,ERROR=0}

function CheckLv() --统计战斗评级
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
CheckLv() --更新统计数据
function SupplyStringMatch(_str)
    local t2 = { string.match(_str , "^(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --将返回的数据匹配到表中
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --转为数值
    return t
end
function ReSetBattleCount() --每达到某个时间点后重设当前战斗次数
	
	if reset_battle_count == true then
		Win.Print("战斗次数清零，并清理")
		f_count_now = 0
	end 
	
	if destroy_kan == true then
		dofile(".\\example\\舰_自定拆船脚本.lua")
	end
end

function CheckFlash()
	change_num = 0
	if boosting == true then --处于加速升级状态
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("五十铃改二", 53, 63,  false, 1, 2);--检测500的状态
		ret = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		change_num = ret
		if ret == 0 then
			Win.Print("开始五十铃刷闪...")
			boosting = false
			slow_count = 0
			Kan.DelAllKanChangeColor()
			Kan.AddKanChangeName("五十铃改二", 53, 63,  false, 0, 1);
			Kan.AddKanChangeName("朝潮改", 57, 67,  false, 0, 2);
			change_num = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		end
	else
		slow_count = slow_count + 1
		if slow_count > 3 then
			Win.Print("切换旗舰，加速升级")
			boosting = true
			Kan.DelAllKanChangeColor()
			Kan.AddKanChangeName("五十铃改二", 53, 63,  false, 0, 2);
			Kan.AddKanChangeName("朝潮改", 57, 67,  false, 0, 1);
			change_num = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		end
	end
	return change_num
end

function ForceChangeKan()--强制更新队伍
	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("正规空母瑞鹤改", 82, 92,  true, 0, 1);
	Kan.ChangeDIY(1,1,C.SORT_LV,1,true)
	if boosting == true then
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("五十铃改二", 53, 63,  false, 0, 2);
		Kan.AddKanChangeName("朝潮改", 57, 67,  false, 0, 1);;
		Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
	else
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("五十铃改二", 53, 63,  false, 0, 1);
		Kan.AddKanChangeName("朝潮改", 57, 67,  false, 0, 2);
		Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
	end
end
	
f_count_now = 0 ; run_count = 0; --初始化当前战斗次数，请勿修改
Kan.EasyConquestRun(false) --首次启动的时候执行一次远征

while true do --开始无限循环
Base.WaitRunHour(run_hour, true, "", "ReSetBattleCount")
run_count = run_count + 1
a = "开始第:%d次"
Win.Print(a:format(run_count))

ret = Kan.Supply()

speed = 0
if use_speed == true then
	speed = 8
end

if ret == -1 then
	Win.Pop('补给不足，等待远征、等待5分',true)
	Kan.EasyConquestWaitNextRun() --等待并执行远征
	if Kan.EasyConquestIsEnabled() == false then Base.Sleep(1000*60*5) end
else
	if f_count_now >= f_count then --如果超过设定的战斗次数，则直接进入远征的执行
		if Kan.EasyConquestIsEnabled() == false then break end
		Kan.EasyConquestWaitNextRun() --执行远征
		if math.random(1,2) == 1 and over_repair == reue then
			Kan.RepairEx(4)
		end
	else
		ret = CheckFlash()
		if ret == 0 then
			Win.Print("换船失败，强制换船")
			ForceChangeKan()
		else
			Kan.Sally(1, 5) --出击目标 3-2
			if Kan.Battle(1, 1, false, 1) == false then 
				Win.Print('可能无法出击或道中大破,休息10分钟')
				Kan.RepairEx(4,speed,12) --将队伍中中破以上的舰船入渠
				Base.SleepSec(60*10)
			else
				CheckLv() --更新统计数据
				f_count_now = f_count_now  + 1 --每次战斗增加1 
				Win.Print('战斗归来，开始检修')
				Kan.RepairEx(4,speed,12) --将队伍中中破以上的舰船入渠
				Kan.WaitHome(2000)
				Base.Sleep(2000)
			end
		end
	end
end

end

Kan.EasyConquestEnterLoop()


Win.Pop('脚本执行完毕！',true)