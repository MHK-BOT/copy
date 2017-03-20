do
local NUM_MSG_MAX = 4
local TIME_CHECK = 2
local function user_print_name(user)
	if user.print_name then
		return user.print_name
	end
	local text = ''
	if user.first_name then
		text = user.last_name..' '
	end
	if user.lastname then
		text = text..user.last_name
	end
	return text
end

local function get_msgs_user_htm(user_id, chat_id)
	local user_info = {}
	local uhash = 'user:'..user_id
	local user = redis:hgetall(uhash)
	local um_hash = 'msgs:'..user_id..':'..chat_id
	user_info.msgs = tonumber(redis:get(um_hash) or 0)
	user_info.name = user_print_name(user)..'</td><td align="center">'..user_id
	return user_info
end

local function get_msgs_user_chat(user_id, chat_id)
	local user_info = {}
	local uhash = 'user:'..user_id
	local user = redis:hgetall(uhash)
	local um_hash = 'msgs:'..user_id..':'..chat_id
	user_info.msgs = tonumber(redis:get(um_hash) or 0)
	user_info.name = user_print_name(user)..'\n> آي دي: '..user_id
	return user_info
end

local function chat_stats(chat_id, chatname)
	local hash = 'chat:'..chat_id..':users'
	local users = redis:smembers(hash)
	local users_info = {}
	for i = 1, #users do
		local user_id = users[i]
		local user_info = get_msgs_user_chat(user_id, chat_id)
		table.insert(users_info, user_info)
	end
	table.sort(users_info, function(a, b) 
		if a.msgs and b.msgs then
			return a.msgs > b.msgs
		end
	end)
	local text = 'نام گروه: '..chatname..' آي دي گروه: '..chat_id..'\n______________________________\n\n'
	for k,user in pairs(users_info) do
		text = text..'> نام: '..user.name..'\n> تعداد چت: '..user.msgs..'\n______________________________\n'
	end
	return text
end

local function chat_statstxt(receiver, chat_id, chatname)
	local hash = 'chat:'..chat_id..':users'
	local users = redis:smembers(hash)
	local users_info = {}
	for i = 1, #users do
		local user_id = users[i]
		local user_info = get_msgs_user_chat(user_id, chat_id)
		table.insert(users_info, user_info)
	end
	table.sort(users_info, function(a, b) 
		if a.msgs and b.msgs then
			return a.msgs > b.msgs
		end
	end)
	local text = 'نام گروه: '..chatname..' آي دي گروه: '..chat_id..'\n______________________________\n\n'
	for k,user in pairs(users_info) do
		text = text..'> نام: '..user.name..'\n> تعداد چت: '..user.msgs..'\n______________________________\n'
	end
	local file = io.open("./file/Stats.txt", "w")
	file:write(text)
	file:flush()
	file:close() 
	send_document(receiver,"./file/Stats.txt", ok_cb, false)
	return --text
end

local function chat_statshtm(receiver, chat_id, chatname)
	local hash = 'chat:'..chat_id..':users'
	local users = redis:smembers(hash)
	local users_info = {}
	for i = 1, #users do
		local user_id = users[i]
		local user_info = get_msgs_user_htm(user_id, chat_id)
		table.insert(users_info, user_info)
	end
	table.sort(users_info, function(a, b) 
		if a.msgs and b.msgs then
			return a.msgs > b.msgs
		end
		end)
		local text = '<html><head><title>Umbrella Bot</title></head><body>'
		..'<center><font size=5 face=tahoma color=#ff0000><b>Umbrella Bot - Stats Log Pro</b></font><br>'
		..'<font size=3 face=tahoma color=#000000>'
		..'Group Name: <b>'..chatname..'</b><br>Group ID: <b>'..chat_id..'</b></font><br><br>'
		..'<center><font size=2 face=tahoma color=#000000><table width=500 border=1 cellSpacing=1 cellPadding=1><tr>'
		..'<td width="10%" align="center" valign="middle"><b>Num</b></b></td>'
		..'<td width="45%" align="center" valign="middle"><b>Name</b></td>'
		..'<td width="25%" align="center" valign="middle"><b>ID</b></td>'
		..'<td width="20%" align="center" valign="middle"><b>Chat</b></td></tr>'
		i2 = 0
	for k,user in pairs(users_info) do
		i2 = i2+1
		text = text..'<tr><td align="center">'..i2..'</td><td>'..user.name..'</td><td align="center">'..user.msgs..'</td></tr>'
	end
		local text = text..'</table><br><br></font><font size=3 face=tahoma><b><a href="http://umbrella.shayan-soft.ir" target="_blank">www.Umbrella.shayan-soft.ir</a></b></center></font><br></body></html>'
		local file = io.open("./file/Stats.htm", "w")
		file:write(text)
		file:flush()
		file:close() 
		send_document(receiver,"./file/Stats.htm", ok_cb, false)
	return --text
end

local function pre_process(msg)
	if msg.service then
		print('Service message')
		return msg
	end
	if msg.from.type == 'user' then
		local hash = 'user:'..msg.from.id
		print('Saving user', hash)
		if msg.from.print_name then
			redis:hset(hash, 'print_name', msg.from.print_name)
		end
		if msg.from.first_name then
			redis:hset(hash, 'first_name', msg.from.first_name)
		end
		if msg.from.last_name then
			redis:hset(hash, 'last_name', msg.from.last_name)
		end
	end
	if msg.to.type == 'chat' then
		local hash = 'chat:'..msg.to.id..':users'
		redis:sadd(hash, msg.from.id)
	end
	local hash = 'msgs:'..msg.from.id..':'..msg.to.id
	redis:incr(hash)
	if msg.from.type == 'user' then
		local hash = 'user:'..msg.from.id..':msgs'
		local msgs = tonumber(redis:get(hash) or 0)
		if msgs > NUM_MSG_MAX then
			print('User '..msg.from.id..'is flooding '..msgs)
			if is_sudo(msg) then
				return
			elseif is_admin(msg) then
				return
			elseif is_momod(msg) then
				return
			else
				local chat = 'chat#id'..msg.to.id
				local user = 'user#id'..msg.from.id
				chat_del_user(chat, user, ok_cb, true)
			end
			msg = nil
		end
		redis:setex(hash, TIME_CHECK, msgs+1)
	end
	return msg
end

local function bot_stats()
	local redis_scan = [[
	local cursor = '0'
	local count = 0
	
    repeat
		local r = redis.call("SCAN", cursor, "MATCH", KEYS[1])
		cursor = r[1]
		count = count + #r[2]
    until cursor == '0'
    return count]]
	local hash = 'msgs:*:'..our_id
	local r = redis:eval(redis_scan, 1, hash)
	local text = 'وضعيت ربات آمبرلا: \n______________________________'
	hash = 'chat:*:users'
	r = redis:eval(redis_scan, 1, hash)
	text = text..'\n> تعداد گروه ها: '..r
	return text
end

local function run(msg, matches)
    if matches[1] == "tat gp" then
		if msg.to.type == 'chat' then
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			local chat_id = msg.to.id
			return chat_stats(chat_id, chatname)
		else
			return 'فقط در گروه'
		end
	end
    if matches[1] == "&stat gp" then
		if not is_admin(msg) then
			return "شما ادمين نيستيد"
		else
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			return chat_stats(matches[2], chatname)
		end
	end
    if matches[1] == "tat gp>" then
		if msg.to.type == 'chat' then
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			local receiver = get_receiver(msg)
			local chat_id = msg.to.id
			return chat_statstxt(receiver, chat_id, chatname)
		else
			return 'فقط در گروه'
		end
	end
	if matches[1] == "/stat gp>" then
		if msg.to.type == 'chat' then
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			local receiver = get_receiver(msg)
			local chat_id = msg.to.id
			return chat_statshtm(receiver, chat_id, chatname)
		else
			return 'فقط در گروه'
		end
	end
    if matches[1] == "&stat gp>" then
		if not is_admin(msg) then
			return "شما ادمين نيستيد"
		else
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			local receiver = get_receiver(msg)
			return chat_statstxt(receiver, matches[2], chatname)
		end
	end
	if matches[1] == "&/stat gp>" then
		if not is_admin(msg) then
			return "شما ادمين نيستيد"
		else
			local chatname = string.gsub(user_print_name(msg.to), '_', ' ')
			local receiver = get_receiver(msg)
			return chat_statshtm(receiver, matches[2], chatname)
		end
    end
    if matches[1] == "tat bot" then
		if not is_admin(msg) then
			return "شما ادمين نيستيد"
		else
			return bot_stats()
		end
	end
end

return {
	description = "Robot, Groups and Member Stats", 
	usagehtm = '<tr><td align="center">stat gp</td><td align="right">نمایش لیست کاربرانی که از ابتدا تاکنون چت نموده اند به همراه نمایش تعداد چت های هر نفر</td></tr>'
	..'<tr><td align="center">stat gp></td><td align="right">فایل لوگ از لیست کاربرانی که از ابتدا تاکنون چت نموده اند به همراه نمایش تعداد چت های هر نفر</td></tr>'
	..'<tr><td align="center">/stat gp></td><td align="right">فایل لوگ به صورت حرفه ای در قالب اچ تب ام ال از لیست کاربرانی که از ابتدا تاکنون چت نموده اند به همراه نمایش تعداد چت های هر نفر</td></tr>'
	..'<tr><td align="center">stat bot</td><td align="right">نمایش تعداد گروه های ساخته شده با ربات قدرتمند آمبرلا</td></tr>',
	usage = {
		moderator = {
			"stat gp : کنتور چت ها",
			"stat gp> : لوگ کنتور",
			"/stat gp> : لوگ حرفه ای کنتور",
		},
		admin = {
			"stat bot : کنتور ربات"
		},
	},
	patterns = {
		"^(&stat gp) (%d+)",
		"^(&stat gp>) (%d+)",
		"^(&/stat gp>) (%d+)",
		"^[Ss](tat gp)$",
		"^(/stat gp>)$",
		"^[Ss](tat gp>)$",
		"^[Ss](tat bot)",
	}, 
	run = run,
	moderated = true,
	pre_process = pre_process
}
end