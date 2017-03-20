local function get_message_callback_id(extra, success, result)
	if is_sudo(result) then
		usertype = {'تو عشق منی',
					'بابایی خوشگل منی',
					'آقامونی ^_^',
					'سروره کل گروه',
					'my love :*',
					'بکنه کله گروه',}
		text = usertype[math.random(#usertype)]
		send_large_msg(orgchatid, text)
	elseif result.from.id == our_id then
		send_large_msg(orgchatid, 'منم بابایی جونم ^_^')
	else
		local file = io.open("./info/"..result.from.id..".txt", "r")
		if file ~= nil then
			usertype = file:read("*all")
			text = 'این یارو '..usertype..' بابایی'
			send_large_msg(orgchatid, text)
		else
			usertype = {'هیچ پخی نیستش بابایی',
						'هیچ انم نیست',
						'گوه خورته بابایی',
						'کونیه، میده',
						'کسخوله اینو خدا زده',
						'کیرته بابایی',
						'کیرتم نیست بابایی',}
			text = usertype[math.random(#usertype)]
			send_large_msg(orgchatid, text)
		end
	end
end

local function run(msg)
	if not msg.reply_id then
		local file = io.open("./info/"..msg.from.id..".txt", "r")
		if file ~= nil then
			usertype = file:read("*all")
		else
			usertype = ''
		end
	
if msg.text == "Salam" and is_sudo(msg) then
	return "سهلام بابایی ^_^"
end
if msg.text == "salam" and is_sudo(msg) then
	return "پـــــــــــــدر ^_^"
end
if msg.text == "hi" and is_sudo(msg) then
	return "سهلــــــــام ددی ^_^"
end
if msg.text == "Hi" and is_sudo(msg) then
	return "Hi Dady :*"
end
if msg.text == "zac" and is_sudo(msg) then
	return "زیر سایه ات باشه"
end
if msg.text == "Zac" and is_sudo(msg) then
	return "بشمـــــار"
end
if msg.text == "ZAC" and is_sudo(msg) then
	return "واس شوماس"
end
if msg.text == "bot" and is_sudo(msg) then
	return "امر کن سرورم"
end
if msg.text == "Bot" and is_sudo(msg) then
	return "جانم بابایی؟"
end
if msg.text == "Bye" and is_sudo(msg) then
	return "اودافظ بابایی جونم ^_^"
end
if msg.text == "bye" and is_sudo(msg) then
	return "اودافظ عشقولی ^_^"
end
if msg.text == "شایان" and is_sudo(msg) then
	return
end
if msg.text == "shayan" and is_sudo(msg) then
	return
end
if msg.text == "Shayan" and is_sudo(msg) then
	return
end


if msg.text == "shayan" then
	return "با باباییم چیکار داری "..usertype
end
if msg.text == "Shayan" then
	return "با باباییم چیکار داری "..usertype
end
if msg.text == "slm" then
	return usertype.." درست سلام بده خوووو گشاد"
end
if msg.text == "Slm" then
	return usertype.." درست سلام بده خوووو گشاد"
end
if msg.text == "شایان" then
	return "با باباییم چیکار داری "..usertype
end
if msg.text == "hi" then
	return "ساموليک "..usertype
end
if msg.text == "Hi" then
	return "سهلام "..usertype
end
if msg.text == "Hello" then
	return "سهلام "..usertype
end
if msg.text == "hello" then
	return "سلام "..usertype
end
if msg.text == "Salam" then
	return "سهلام "..usertype
end
if msg.text == "salam" then
	return "سلام "..usertype
end
if msg.text == "zac" then
	return "بزن واسش ساک"
end
if msg.text == "Zac" then
	return "بزن واسش ساک"
end
if msg.text == "ZAC" then
	return "بزن واسش ساک"
end
if msg.text == "bot" then
	return "چیه "..usertype
end
if msg.text == "Bot" then
	return "چیه "..usertype
end
if msg.text == "Bye" then
	return "باي "..usertype
end
if msg.text == "bye" then
	return "بـــــاي "..usertype
end
if msg.text == "سلام" then
	return "سلام "..usertype
end
if msg.text == "باي" then
	return "خدافظ "..usertype
end
if msg.text == "بات" then
	return "هان "..usertype
end
if msg.text == "آمبرلا" then
	return "ها "..usertype
end
if msg.text == "ربات" then
	return "ها "..usertype
end
if msg.text == "خدافظ" then
	return "بـــــاي "..usertype
end
if msg.text == "شب خوش" then
	return "شب شيک "..usertype
end
if msg.text == "خداحافظ" then
	return "خوش اومدي "..usertype
end
if msg.text == "شب شيک" then
	return "باي "..usertype
end
if msg.text == "فلن" then
	return "بـــــاي "..usertype
end
if msg.text == "فعلا" then
	return "بـــــاي "..usertype
end
if msg.text == "فلا" then
	return "بـــــاي "..usertype
end
if msg.text == "شب بخير" then
	return "بـــــاي "..usertype
end
if msg.text == "صب بخير" then
	return "سلام "..usertype
end
if msg.text == "صبح بخير" then
	return "سهلام "..usertype
end

else
	if is_sudo(msg) then
		orgchatid = 'chat#id'..msg.to.id
		get_message(msg.reply_id, get_message_callback_id, false)
	end
end
end
return {
	description = "Chat With Robot Server", 
	usagehtm = '<tr><td align="center">(Chat Plugin)</td><td align="right">ابزاری هوشمند، حساس به برخی از کلامات جهت پاسخگویی به آنها مانند سلام. این ابزار قادر است هوشمندانه مقام شما را نیز در صورتی که قبلا ثبت شده باشد تشخیص دهد و در جملات ارسالی از آنها استفاده کند</td></tr>',
	patterns = {
		"[Ii]n kie",
		"[Ii]n yeki",
		"[Ii]n dige",
		"[Ii]n ki bud",
		"[Ii]n kodum",
		"[Mm]an",
		"[Ii]n kiye",
		"این کیه",
		"[Hh]i$",
		"[Hh]ello",
		"^[Zz]ac$",
		"^ZAC$",
		"^[Bb]ot$",
		"[Bb]ye",
		"[Ss]alam",
		"سلام",
		"باي",
		"^بات$",
		"^آمبرلا$",
		"^ربات$",
		"صبح بخير",
		"شب بخير",
		"شب خوش",
		"شب شيک",
		"صب بخير",
		"فعلا",
		"فلن",
		"فلا",
		"خدافظ",
		"خداحافظ",
		"[Ss]lm",
		"شایان",
		"[Ss]hayan",
		},
	run = run,
	pre_process = pre_process
}
