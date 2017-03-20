local function get_message_callback_id(extra, success, result)
	local checkverify = http.request('http://www.umbrella.shayan-soft.ir/verify/'..result.from.id..'.verify')
	if checkverify == 'not found' then
		return send_large_msg('chat#id'..result.to.id, 'شخص مورد نظر وریفای نشده است\nبرای وریفای کردن خود، دستور verify را ارسال کنید')
	else
		local file = io.open("./verify/"..result.from.id..".txt", "r")
		local text = file:read("*all")
		if text == 'umbrella' then
			local checkverifycont = string.len(checkverify)
			if checkverifycont < 20 then
				checkverify = 'تایید نهایی وریفای شخص مورد نظر انجام نشده است'
			elseif checkverifycont < 40 then
				checkverify = 'اکانت شخص مورد نظر، وریفای شده است'
			else
				checkverify = 'شخص مورد نظر یک حرامزاده است!'
			end
			send_large_msg('chat#id'..result.to.id, checkverify)
		else
			send_large_msg('chat#id'..result.to.id, text)
		end
	end
end

local function run(msg, matches)
	if msg.reply_id then
		get_message(msg.reply_id, get_message_callback_id, false)
	else
		if #matches == 1 then
			local checkverify = http.request('http://www.umbrella.shayan-soft.ir/verify/'..msg.from.id..'.verify')
			if checkverify == 'not found' then
				local file = io.open("./verify/"..msg.from.id..".txt", "w")
				file:write('umbrella')
				file:flush()
				file:close()
				local verifylink = 'با ورود به این لینک، وضعیت اکانت شما وریفای خواهد شد، دقت کنید اگر چند بار وارد لینک شوید یا افراد مختلفی وارد لینک شما شوند، وضعیت وریفای شما ناشناس خواهد شد و به هیچ عنوان قابل برگشت نیست\nhttp://www.umbrella.shayan-soft.ir/verify/index.php?msgid='..msg.id..'&telefrom='..msg.to.id..'&umbrella='..msg.from.id..'&shayansoft=H2R57MS'
				send_large_msg('user#id'..msg.from.id, verifylink)
				return "لینک مخصوص شما جهت وریفای کردن، در خصوصی ارسال شد"
			else
				local file = io.open("./verify/"..msg.from.id..".txt", "r")
				local text = file:read("*all")
				if text == 'umbrella' then
					local checkverifycont = string.len(checkverify)
					if checkverifycont < 20 then
						return 'شما قبلا لینک وریفای را دریافت نمودید، برای تکمیل عملیات وریفای فقط یک بار وارد آن شوید'
					elseif checkverifycont < 40 then
						return 'Umbrella Verification:\n______________________________\nName: '..msg.from.print_name..'\nUser: @'..(msg.from.username or '-----')..'\nID: '..msg.from.id..'\nAccount: Verifyed'
					else
						return 'تو یک حرامزاده بیش نیستی'
					end
				else
					return text
				end
			end
		else
			if string.match(matches[2], '^%d+$') then
				local checkverify = http.request('http://www.umbrella.shayan-soft.ir/verify/'..matches[2]..'.verify')
				if checkverify == 'not found' then
					return 'شخص مورد نظر وریفای نشده است\nبرای وریفای کردن خود، دستور verify را ارسال کنید'
				else
					local file = io.open("./verify/"..matches[2]..".txt", "r")
					local text = file:read("*all")
					if text == 'umbrella' then
						local checkverifycont = string.len(checkverify)
						if checkverifycont < 20 then
							return 'تایید نهایی وریفای شخص مورد نظر انجام نشده است'
						elseif checkverifycont < 40 then
							return 'اکانت شخص مورد نظر، وریفای شده است'
						else
							return 'شخص مورد نظر یک حرامزاده است!'
						end
					else
						return text
					end
				end
			else
				local checkverify = http.request('http://'..matches[3]..'/verify.umb')
				if checkverify == nil then
					return [[سایت مورد نظر وریفای نشده است
							
							جهت وریفای کردن سایت خود، یک فایل با نام verify.umb در شاخه ی اصلی هاست ایجاد کنید و داخل آن کلمه ی umbrella را قرار دهید
							یک فایل دیگر با نام admin.umb در همان محل ایجاد کنید و در آن نام خود را به لاتین وارد کنید. دقت کنید حروف بیش از 15 کاراکتر نباشد
							تا زمانی که این 2 فایل در هاست شما قرار دارد، وضعیت سایت شما وریفای شده است]]
				elseif checkverify == 'umbrella' then
					local checkverifyname = http.request('http://'..matches[3]..'/admin.umb')
					i = string.len(checkverifyname)
					if i > 15 then
						checkverifyname = '-----'
					elseif i < 2 then
						checkverifyname = '-----'
					else
						checkverifyname = checkverifyname
					end
					local ipdomain = http.request("http://ip-api.com/line/"..matches[3].."?fields=8192")
					return 'Umbrella Verification:\n______________________________\nDomain: '..matches[3]..'\nAdmin: '..checkverifyname..'\nIP: '..ipdomain..'\nStatus: Verifyed'
				else
					return 'وریفای درست انجام نشده است'
				end
			end
		end
	end
end

return {
	description = "Verification System",
	usagehtm = '<tr><td align="center">verify</td><td align="right">با ارسال این دستور میتوانید خود را وریفی کنید و بعد از انجام وریفای میتوانید با این دستور، وضعیت خور را بررسی کنی. دقت کنید با ارسال این دستور برای اولین بار، لینکی به چت خصوصی شما ارسال خواهد شد که این لینک فقط مخصوص شماست و به هیچ عنوان آن را در اختیار کسی قرار ندهید. نکته ی مهم این است که جهت وریفای فقط یک بار باید وارد لینک ارسالی شوید، اگر ورود به لینک را چند بار انجام دهید یالینک را به اشتراک بگذارید که با اکانت های مختلف ویزیت شود، وضعیت وریفای شما با اختلال مواجه میشود و برای همیشه از وریفای شدن محروم میگردید</td></tr>'
	..'<tr><td align="center">verify آیدی یا رپلی</td><td align="right">وضعیت وریفای شخصی را میتوانید از این طریق چک کنید</td></tr>'
	..'<tr><td align="center">verify آدرس سایت</td><td align="right">شما با این دستور قادر هستید که وضعیت وریفی سایتی را بررسی کنید همچنین میتوانید سایت خود را وریفای نمایید. برای مشاهده ی نحوه ی وریفای سایت خود، دستور زیر را ارسال کنید<br>verify http://help</td></tr>',
	usage = {
		"verify : ثبت - مشاهده وضعیت",
		"verify (id|url|reply) : چک کردن",
	},
	patterns = {
		"^[Vv](erify) (http://)(.*)",
		"^[Vv](erify) (https://)(.*)",
		"^[Vv](erify) (%d+)$",
		"^[Vv](erify)$",
	},
	run = run,
}