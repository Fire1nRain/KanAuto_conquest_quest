--###################################################################
--������������������ϸ�Ķ����������� Ȼ�����޸� 
--���������������� �밴Alt+F4������̺�����

Base.SetConfig("FindColorBinDefSite", 4) 
--Ǳͧ�����ݴ������������ű�������use_speed�����ǻ��ǱͧҲ�������ɵ��ߴ�ֵ���Ƽ�5-8��


math.randomseed(os.time())
f_count = math.random(30,50) --ս������ 50-70 ���
Win.Print("��ʼ���У����ν�����"..f_count.."��")
--ս������ ����ս����������ֻԶ��

boosting = true
slow_count = 0
--����ʮ��

Kan.DelBattleInfo()
--���ս������

Kan.AddBattleInfo(2,5,false,false)
--����ս�����ã���2\���͸���\��ҹս\������˾��˱�(��ǰ�汾��֧��)

use_speed = false
--����ʱ�� ��Ǳͧ�� �Ĵ��ƴ��Ƿ�ʹ��Ͱ������true

k2_conquest = C.�����������_ID6
k3_conquest = C.�����o�l�΄�_ID5
k4_conquest = C.������ݔ������_ID21
--����2��3��4����Զ����������C.Ȼ������ѡ��

Kan.EasyConquestInit(60*5, 60*10)
--���ü���Զ����ÿ5-10���ӽ���һ�μ�⣬1.5.3�汾KCA�ſ���ʹ��

run_hour = "[[0,23]]" 
--������ʱ������ Ĭ��"[[0,23]]"Ϊȫ����ʱ��ִ�У�1.5.3�汾KCA�ſ���ʹ��
--���þ�����"[8,10,[20,22]]" Ϊ8��10��20��21��22Ϊ�ű�����ʱ��

reset_battle_count = true 
--�Ƿ���ÿ�εȴ�����ִ�е�ʱ�������ս��������1.5.3�汾KCA�ſ���ʹ��
--����"[8,10,[20,22]]"�����ã�����8�㣬10�㣬20���������

destroy_kan = false 
--�Ƿ���ÿ�εȴ�����ִ�е�ʱ���ִ�в�
--����"[8,10,[20,22]]"�����ã�����8�㣬10�㣬20����в�

over_repair = true 
--�Ƿ���ս������������޴�����Ҫ�趨Զ������Ч��1.5.3�汾KCA�ſ���ʹ��

Base.SetConfig("Sleep+?",100) --������ʱ�������1-100
--###################################################################

m_lv = {SS=0,S=0,A=0,B=0,C=0,D=0,ALL=0,ERROR=0}

function CheckLv() --ͳ��ս������
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
	Win.SetState("�ۼ�ս��:"..m_lv.ALL.." SS:"..m_lv.SS.."  S:"..m_lv.S.."  A:"..m_lv.A.."  B:"..m_lv.B.."  C:"..m_lv.C.."  D:"..m_lv.D)
end
CheckLv() --����ͳ������
function SupplyStringMatch(_str)
    local t2 = { string.match(_str , "^(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --�����ص�����ƥ�䵽����
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --תΪ��ֵ
    return t
end
function ReSetBattleCount() --ÿ�ﵽĳ��ʱ�������赱ǰս������
	
	if reset_battle_count == true then
		Win.Print("ս���������㣬������")
		f_count_now = 0
	end 
	
	if destroy_kan == true then
		dofile(".\\example\\��_�Զ��𴬽ű�.lua")
	end
end

function CheckFlash()
	change_num = 0
	if boosting == true then --���ڼ�������״̬
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("��ʮ��Ķ�", 53, 63,  false, 1, 2);--���500��״̬
		ret = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		change_num = ret
		if ret == 0 then
			Win.Print("��ʼ��ʮ��ˢ��...")
			boosting = false
			slow_count = 0
			Kan.DelAllKanChangeColor()
			Kan.AddKanChangeName("��ʮ��Ķ�", 53, 63,  false, 0, 1);
			Kan.AddKanChangeName("������", 57, 67,  false, 0, 2);
			change_num = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		end
	else
		slow_count = slow_count + 1
		if slow_count > 3 then
			Win.Print("�л��콢����������")
			boosting = true
			Kan.DelAllKanChangeColor()
			Kan.AddKanChangeName("��ʮ��Ķ�", 53, 63,  false, 0, 2);
			Kan.AddKanChangeName("������", 57, 67,  false, 0, 1);
			change_num = Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
		end
	end
	return change_num
end

function ForceChangeKan()--ǿ�Ƹ��¶���
	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("�����ĸ��׸�", 82, 92,  true, 0, 1);
	Kan.ChangeDIY(1,1,C.SORT_LV,1,true)
	if boosting == true then
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("��ʮ��Ķ�", 53, 63,  false, 0, 2);
		Kan.AddKanChangeName("������", 57, 67,  false, 0, 1);;
		Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
	else
		Kan.DelAllKanChangeColor()
		Kan.AddKanChangeName("��ʮ��Ķ�", 53, 63,  false, 0, 1);
		Kan.AddKanChangeName("������", 57, 67,  false, 0, 2);
		Kan.ChangeDIY(1,1,C.SORT_LV,2,true)
	end
end
	
f_count_now = 0 ; run_count = 0; --��ʼ����ǰս�������������޸�
Kan.EasyConquestRun(false) --�״�������ʱ��ִ��һ��Զ��

while true do --��ʼ����ѭ��
Base.WaitRunHour(run_hour, true, "", "ReSetBattleCount")
run_count = run_count + 1
a = "��ʼ��:%d��"
Win.Print(a:format(run_count))

ret = Kan.Supply()

speed = 0
if use_speed == true then
	speed = 8
end

if ret == -1 then
	Win.Pop('�������㣬�ȴ�Զ�����ȴ�5��',true)
	Kan.EasyConquestWaitNextRun() --�ȴ���ִ��Զ��
	if Kan.EasyConquestIsEnabled() == false then Base.Sleep(1000*60*5) end
else
	if f_count_now >= f_count then --��������趨��ս����������ֱ�ӽ���Զ����ִ��
		if Kan.EasyConquestIsEnabled() == false then break end
		Kan.EasyConquestWaitNextRun() --ִ��Զ��
		if math.random(1,2) == 1 and over_repair == reue then
			Kan.RepairEx(4)
		end
	else
		ret = CheckFlash()
		if ret == 0 then
			Win.Print("����ʧ�ܣ�ǿ�ƻ���")
			ForceChangeKan()
		else
			Kan.Sally(1, 5) --����Ŀ�� 3-2
			if Kan.Battle(1, 1, false, 1) == false then 
				Win.Print('�����޷���������д���,��Ϣ10����')
				Kan.RepairEx(4,speed,12) --���������������ϵĽ�������
				Base.SleepSec(60*10)
			else
				CheckLv() --����ͳ������
				f_count_now = f_count_now  + 1 --ÿ��ս������1 
				Win.Print('ս����������ʼ����')
				Kan.RepairEx(4,speed,12) --���������������ϵĽ�������
				Kan.WaitHome(2000)
				Base.Sleep(2000)
			end
		end
	end
end

end

Kan.EasyConquestEnterLoop()


Win.Pop('�ű�ִ����ϣ�',true)