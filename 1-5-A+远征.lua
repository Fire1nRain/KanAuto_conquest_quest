--=========================��������===========================
--�δ��б���һλ�Ǵ���
shipList = {
	{name="��Ѳ����ʮ��Ķ�",minLv=54,maxLv=64},
	{name="���𽢳�����",minLv=62,maxLv=70},
	{name="��������",minLv=53,maxLv=64},
	{name="�������",minLv=35,maxLv=45}
}

--�趨��Ҫ���е�Զ��
k2_conquest = C.�����o�l�΄�_ID5
k3_conquest = C.�����������_ID6
k4_conquest = C.������ݔ������_ID21

--ս������ 50-70 ���
math.randomseed(os.time())
f_count = math.random(30,50) 
Win.Print("��ʼ���У����ν�����"..f_count.."��")

--ÿ10-15���Ӽ��һ��Զ��
Kan.EasyConquestInit(60*10,60*15)

--������ʱ�������1-100
Base.SetConfig("Sleep+?",100)

--��������ʧ�ܼ���
consecFail = 0

--�Ƿ�����������
fullteam = true

--�ֻ�����
roster = 0

--���ֳ����Ƿ�������+
notGood = false


--ͳ�Ƴ������
m_lv = {SS=0,S=0,A=0,B=0,C=0,D=0,ALL=0,ERROR=0}

--=========================���ú���===========================
--ͳ��ս������
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
	Win.SetState("�ۼ�ս��:"..m_lv.ALL.." SS:"..m_lv.SS.."  S:"..m_lv.S.."  A:"..m_lv.A.."  B:"..m_lv.B.."  C:"..m_lv.C.."  D:"..m_lv.D)
end

--����Supply��������ֵ
function SupplyStringMatch(_str)
    local t2 = { string.match(_str , "^(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --�����ص�����ƥ�䵽����
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --תΪ��ֵ
    return t
end

--�������н���
--_shipList�ǽ����б�_good��ʾ�ǲ�����ý��ﻹ�����н���
function changeAll(_shipList,_good)

	Kan.DelAllKanChangeColor()
	for i=1,#_shipList do
		--�콢���ȳ�����Ӳ������Ĵ��֣�Ȼ�󰴶���˳���Լ��뽢��
		if i==1 then
		--��Ӳ�������
			Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,2,i,false,true)
		
		--ĩλ���ȳ�����������֣�Ȼ�󰴶���˳���Լ��뽢��	
		elseif i==#_shipList then
			--���������
			Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,1,i)
		end
		
		--����λ�����������������
		for j=2,#_shipList do
			Kan.AddKanChangeName(_shipList[j].name,_shipList[j].minLv,_shipList[j].maxLv,_good,0,i)
		end
		
		--ȷ�����ֱ��������
		Kan.AddKanChangeName(_shipList[1].name,_shipList[1].minLv,_shipList[1].maxLv,false,0,i)
	end
	
	--���������л���
	ret = Kan.ChangeDIY(1,1,C.SORT_LV,3,true)
	return ret
end

--=========================������===========================
--��ʼ�����ݺ���ʾ
CheckLv()
--��ʼ������
changeAll(shipList,false)
--��ʼԶ��
Kan.EasyConquestRun(false)
--����������
f_count_now = 1
--��ʼ����ѭ��
--����ѭ��������ʵ������continue��Ч��
while true do
while true do
	
	Win.Print("��ʼ��"..f_count_now.."�γ���..")
	
	--����
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
		
		--���ֻ������һ�Ҵ�����������ǰѭ������������ʧ�ܴ�����һ
		if ret <= 1 then
			Win.Print("������������٣������������е�λ���ٳ���")
			Kan.RepairEx(4,0,1+2+4+8)
			consecFail = consecFail + 1
			break
		end
		
	end
	
	--׼����������ʼ��
	Kan.Sally(1,5)
	--���������ʧ�ܣ���
	if Kan.Battle(1,2,false,5) == false then
		Win.Print("����ʧ��..")
		Kan.RepairEx(4,0,4+8)
		consecFail = consecFail + 1
	--��������ɹ�����
	else
		Win.Print("��"..f_count_now.."�γ����ɹ�")
		--����״̬
		CheckLv()
		--�����ɹ������+1
		f_count_now = f_count_now + 1
		--��������ʧ�ܼ���
		consecFail = 0
	end
	
	if consecFail >= 3 then
		Win.Print("��������ʧ�ܣ��ȴ�һ��Զ�����ٳ���")
		Kan.EasyConquestWaitNextRun()
		consecFail = 0
	else
		Win.Print("Զ��һ��")
		--����һ��Զ��
		Kan.EasyConquestRun(false)
	end
	
	--�������֮ǰ�������Ļ����ѵ��ֻ���������ô������������
	if fullteam == false or roster > 4 then
		changeAll(shipList,false)
		roster = 0
		--���ֻ������һ�Ҵ�����������ǰѭ������������ʧ�ܴ�����һ
		if ret <= 1 then
			Kan.RepairEx(4,0,4+8)
			consecFail = consecFail + 1
			break
		end
	else
		Win.Print("�����ֻ�����"..4-roster.."��")
		roster = roster + 1
	end
	
	if f_count_now > f_count then
		Win.Print("��������������ޣ����ٳ���!")
		break
	end
end
	--�����ڶ���ѭ�������׽���
	if f_count_now > f_count then
		Win.Print("��������������ޣ����ٳ���!")
		break
	end
end
--���ٸδ���ֻԶ��
Win.Print("��ʼר��Զ��...")
Kan.EasyConquestEnterLoop()