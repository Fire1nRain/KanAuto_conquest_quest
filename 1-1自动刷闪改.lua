--�Զ�ˢ���ű�
--������Ҫ1.4.5�汾�ſ������У���ȴ����¡���
--ֻ������������Ҫˢ�Ĵ���
--���Զ���1-3������Ѳ����������2�� �����ٸ���������
--���ᴦ�����̵���С�������Ҫˢ�ܶ�ֻ���������һЩ��λ������1����С��
--[20151119]�Ż� ���û�з�������Ҫˢ�Ĵ� ������������д���ʣ�� ���Զ�����
--[20151119]���� �Ҵ�������ã�����޷���ȷʶ��󲿷ִ�����������
------------����������Ĭ�ϵ�2��
--[20151121]���� ��������ֻ�Գ�����Ч������
---------------------------------------------------------------------------------
--��������������
Kan.DelBattleInfo()
Kan.AddBattleInfo(1,1,false,false)
Kan.AddBattleInfo(2,1,true,false)
--ÿ�����ս������ һ�㲻�ø�

m_count = 3
--����ˢ���Ĵ�����3�γ����ɵ�85��

m_team_id = 1
--�����Ķ���ID

m_flash_kan = {}
--��Ҫ�޸�

---------------------------------------------------------------------------------

--Base.SetConfig("ChangeNameSiteString", 20)
--���������д����ֵ����ֵ Ĭ��Ϊ20 �����޸ģ���ȡ����һ��ע�� ��Ҫ1.4.8�汾

--Base.SetConfig("ChangeNameSiteNum",9)
--���������д��ȼ������ֵ Ĭ��Ϊ9 �����޸ģ���ȡ����һ��ע�� ��Ҫ1.4.8�汾

--�����������������޷���ȷʶ��ȼ������ֵ�������޸�

---------------------------------------------------------------------------------
--����������������������Ҫˢ�Ĵ��� 

--��KanAuto������С����ť�п��԰����������Ӹ���Ŀ 
--ˢ֮ǰ�ǵø���ˢ���Ĵ���װ��Ŷ���ر��ǿ�ĸ�ķɻ�
--������Ӷ���

--���������һ���㷺�������������ĸ��װ�׿�ĸ��ˢ���ˢս�����ȼ�80-150��ˢ10��
--֧��������ʽ
--table.insert(m_flash_kan,{name="Ϧ���Ķ�", min_lv=69, max_lv=79,  count=3});
--table.insert(m_flash_kan,{name="ľ����", min_lv=38, max_lv=48,  count=3});
--table.insert(m_flash_kan,{name="���¸�", min_lv=29, max_lv=39,  count=3});
--table.insert(m_flash_kan,{name="���¸�", min_lv=27, max_lv=37,  count=3});
table.insert(m_flash_kan,{name="���¸�", min_lv=28, max_lv=38,  count=3});
--table.insert(m_flash_kan,{name="���¸�", min_lv=26, max_lv=36,  count=3});
table.insert(m_flash_kan,{name="���¸�", min_lv=26, max_lv=36,  count=3});



--�������ӣ�
--table.insert(m_flash_kan,{name="�����", min_lv=80, max_lv=150, count=1})
--���һ�����������������ģ��ȼ�80-150��ˢ1�ң�������崬����������ˢ1��

--table.insert(m_flash_kan,{name=".*", min_lv=80, max_lv=150, count=10})
--���һ���㷺����������ѡ�����е�80-150����ȥˢ10��

---------------------------------------------------------------------------------
Base.SetConfig("Sleep+?",100) --������ʱ�������1-100


function SupplyAllStringMatch(_str)
    local t2 = { string.match(_str , "^(-?%d+),(-?%d+),(-?%d+),(-?%d+)|(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)") }
    --�����ص�����ƥ�䵽����
    t = {}
    for key, value in pairs(t2) do  
            table.insert(t,tonumber(value))
    end  --תΪ��ֵ
    Base.Print(string.format("����״̬:%d %d %d %d",t[1],t[2],t[3],t[4]))
    Base.Print(string.format("��һ���ӵ���״̬:%d %d %d %d %d %d",t[5],t[6],t[7],t[8],t[9],t[10]))
        
    return t
end

function ChangeKanMain(_name, _min_lv, _max_lv)
	Win.Print('Main�л���ֻ' .. _name)
	
	Kan.DelAllKanChangeColor()
	
	Kan.AddKanChangeName(_name, _min_lv, _max_lv, false, 2, 1,false,true)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_LV, 7, true)
	
	if ret == 1 then --���Ը�дʧ���˻���Ĵ�
		return true
	end
	return false
end

function ChangeKanAll(_name, _min_lv, _max_lv)
	Win.Print('�л���ֻ' .. _name)
	
	Kan.DelAllKanChangeColor()
	
	Kan.AddKanChangeName(_name, _min_lv, _max_lv, false, 2, 1)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_LV, 7, true)

	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("^(����).*", 1, 3, true, 0, 2, true)
	Kan.AddKanChangeName("^(����).*", 1, 3, true, 0, 3, true)
	ret2 = Kan.ChangeDIY(1, m_team_id, C.SORT_NEW, 15, true)
	
	if ret == 1 and ret2 == 2 then --���Ը�дʧ���˻���Ĵ�
		return true
	end
	return false
end

function ChangeKanMin() --�л�С��
	Win.Print('�л�С��')
	Kan.DelAllKanChangeColor()
	Kan.AddKanChangeName("^(����).*", 1, 3, true, 0, 2, true)
	Kan.AddKanChangeName("^(����).*", 1, 3, true, 0, 3, true)
	ret = Kan.ChangeDIY(1, m_team_id, C.SORT_NEW, 15, false)
	
	if ret == 2 then --���Ը�дʧ���˻���Ĵ�
		return true
	end
	return false
end

function GoGoFlash()

for n = 1, m_count do --ѭ������
    a = "��ʼ��:%d��"
    Win.Print(a:format(n))
    
    ret = Base.CallFunc("Kan.SupplyAll") --����ȫ����������������
    Base.Print(ret)
    
    t = SupplyAllStringMatch(ret) --���ص��ı�ת��table

	kan_2_id = 2 + (m_team_id-1)*6 + 4
	kan_3_id = 3 + (m_team_id-1)*6 + 4
	kan_1_id = 1 + (m_team_id-1)*6 + 4
	if t[kan_2_id] == C.KAN_STATE_MAX or t[kan_2_id] == C.KAN_STATE_MID then --�жϵ�2λ��
		--С����״̬���ʺϼ���ˢ
		if ChangeKanMin() == false then
			Win.Print('û�пɻ���С����')
			break
		end
		ret = Base.CallFunc("Kan.SupplyAll") --����ȫ����������������
	end
	
	if t[kan_3_id] == C.KAN_STATE_MAX or t[kan_3_id] == C.KAN_STATE_MID then --�жϵ�3λ��
		 --С����״̬���ʺϼ���ˢ
		Win.Print('С��״̬����')
		if ChangeKanMin() == false then
			Win.Print('û�пɻ���С����')
			break
		end
		ret = Base.CallFunc("Kan.SupplyAll")
	end
	
	
	if t[kan_1_id] == C.KAN_STATE_MAX or t[kan_1_id] == C.KAN_STATE_MID then --�ж��콢
		Win.Print('�����ƻ���ƣ�ֹͣ�ô�ˢ��������')
		break
	end
	
    if t[m_team_id] == -1 then
        Win.Pop('�������� �ű�ֹͣ��',true)
        break
    end

    Kan.Sally(1, 1)
    
    if Kan.BattleEx(m_team_id, m_count) == false then
		
    else
		
    end
    
    Kan.WaitHome(2000)
    Base.Sleep(2000)
end

end --gogo����

--�����￪ʼ����
for key,value in pairs(m_flash_kan) do  
	Win.Print('��ǰ����' .. value["name"])
	for n=1,value["count"] do
		if ChangeKanMain(value["name"], value["min_lv"], value["max_lv"]) == true then
			if ChangeKanMin() == true then
				Win.Print('�����ɹ�����ʼˢ��ս��')
				GoGoFlash()
			else
				Win.Print('û�з���������С�����滻��')
				break
			end
		else
			Win.Print('û���ҵ����������Ĵ���')
			break
		end
	end
end


Win.Pop('�ű�ִ����ϣ�')