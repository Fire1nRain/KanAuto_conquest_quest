--�趨����
k2_conquest = C.�|������_ID37
k3_conquest = C.�����������_ID6

--�ȴ�����
waitCount = 0

checkQuest = true

--����
function gotoQuest()
	Kan.WaitHomeEx(500,3*60*1000)
	Win.Print("���ĸ������")
	Base.Click(555,51) --���ĸ������
	ret = Base.WaitColor("[[660,475,4081991],[688,475,7376854]]","����",400,30000,100)
	if ret == true then Base.Click(579,209) end
	return ret
end

function waitLoading()
	ret = Base.WaitColor("[[172,476,15395305],[774,475,14478322]]","�������",500,30000,100)
	return ret
end

function waitReward()
	ret = Base.WaitColor("[[375,399,10460707],[400,402,9211167],[435,403,10460707]]","��������",500,30000,100)
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
	if _target ~= nil then --û���ҵ��Ļ� ����ֵΪnil ��Ҫ�ж� �������
		
		questStat = 0
		
		for k, v in string.gmatch(_target, "(%d+),(%d+)") do
			_x = tonumber(k)
			_y = tonumber(v)
		end
		Win.Print("�ҵ��������꣺".._x..",".._y)
		
		if _ongoing ~= nil then
			for k, v in string.gmatch(_ongoing, "(%d+),(%d+)") do
				Win.Print("�ҵ������У�"..k..","..v)
				if _y - tonumber(v) <15 and _y - tonumber(v) > -15 then
					questStat = 1
					break
				end
	        end
		end
		
		if _finished ~= nil then
			for k, v in string.gmatch(_finished, "(%d+),(%d+)") do
				Win.Print("�ҵ�����ɣ�"..k..","..v)
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
			
		Base.Click(651,460) --���������һҳ
		
		Base.Sleep(500)
			
		ret = waitLoading()
		if ret == true then
		
			Base.Sleep(500)
			
			Base.Print("�������")
			
			while true do --�������ǰ��ҳ�ļ�ͷ �ͽ���ѭ��
				
				Base.Sleep(500)
				
				--��Զ������
				conquest = findIcon("[3,145,\"1QBH4NV,1UTU1\",\"1Q694GV,1QDOV\"]")
		
				--�ҽ�����ͼ��
				ongoing = findIcon("[3,250,	\"19RVOCF,17SPU\",\"19UC0C3,160P6\"]")
				
				--�ҵ����ͼ��
				finished = findIcon("[3,210,\"101HG2R,1V1G1\",\"101HG3T,1P003\"]")
				
				questStat,x,y = findTarget(conquest,ongoing,finished)
				
				--�����������һ�û����
				if questStat == 0 then
				
					Win.Print("��������"..x..","..y)
					Base.Click(x,y)
					ret = waitLoading()
					if ret == false then
						Win.Print("���볬ʱ��after click")
						break
					end
				
				--������������
				elseif questStat == 2 then
					
					Win.Print("�������"..x..","..y)
					Base.Click(x,y)
					ret = waitReward()
					if ret == false then
						Win.Print("���볬ʱ��after finish")
						break
					end
					ret = waitLoading()
					if ret == false then
						Win.Print("���볬ʱ�� after finish2")
						break
					end
				end
				--ֻҪ�����ҵ���������ѭ��
				if questStat >= 0 then
					Win.Print("����ĸ��")
					Kan.GoHome()
					break
				end
				
				
				Win.Print("��ҳ")
				Base.Sleep(500)
				Base.Click(297,463) --��ǰ��ҳ
				Base.Sleep(500)
				
				ret = waitLoading()
				if ret == false then
					Win.Print("���볬ʱ�� after paging")
					break
				end
				
				Base.Sleep(500)
				
				if IsForward() == false then
					Win.Print("������ҳ")
					break
				end
			end
		else
			Win.Print("���볬ʱ��on last page")
		end
	else
		Win.Print("�޷��������б�")
	end	
	Kan.GoHome()
	return questFound
end

Kan.EasyConquestInit(60*5,60*7)
Kan.EasyConquestRun()
 
while true do
	Kan.RepairEx(4,0,1+2+4+8)
	--������Ϊ����������ʱ����JST5������������ÿ��ѭ���������
	if checkQuest == true and Base.CheckHour("[[6,18]]") == true then
		hasQuest = tryQuest()
		Kan.WaitHomeEx(500.10000)
	end
	Kan.EasyConquestWaitNextRun()
end