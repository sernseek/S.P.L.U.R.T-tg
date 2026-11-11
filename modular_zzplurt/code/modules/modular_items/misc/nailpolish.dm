// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
//Nail polish
/obj/item/nailpolish
	name = "nail polish"
	desc = "Paint with a fine brush to do your nails, or someone elses."
	icon = 'modular_zzplurt/icons/obj/cosmetic.dmi'
	icon_state = "nailcap"
	w_class = WEIGHT_CLASS_SMALL
	var/paint = "black"
	var/mutable_appearance/bottle //show the colour on the bottle.

/obj/item/nailpolish/red
	name = "red nail polish"
	paint = "red"

/obj/item/nailpolish/blue
	name = "blue nail polish"
	paint = "blue"

/obj/item/nailpolish/aqua
	name = "cyan nail polish"
	paint = "aqua"

/obj/item/nailpolish/black
	name = "black nail polish"
	paint = "black"

/obj/item/nailpolish/white
	name = "white nail polish"
	paint = "white"

/obj/item/nailpolish/navy
	name = "navy nail polish"
	paint = "navy"

/obj/item/nailpolish/yellow
	name = "yellow nail polish"
	paint = "yellow"

/obj/item/nailpolish/purple
	name = "purple nail polish"
	paint = "purple"

/obj/item/nailpolish/Initialize(mapload)
	. = ..()
	bottle = mutable_appearance('modular_zzplurt/icons/obj/cosmetic.dmi', "nailpolish")
	bottle.color = paint
	add_overlay(bottle)

/mob/living/carbon/human
	var/nail_style = null
	var/nail_color = "white"

/obj/item/nailpolish/attack(mob/M, mob/user)
	if(!ismob(M))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nail_style) //to stop stacking bugs
			to_chat(user, span_warning(LANG("obj.3e2fef09434771f4", null)))

		if(H == user)
			user.visible_message(span_notice(LANG("obj.3e36c833e72e0413", list(user, user.p_their(), src))), \
								span_notice(LANG("obj.49bba65b9ba5ce6f", list(src))))
			H.nail_style = "nails"
			H.nail_color = paint
			H.update_body()
		else
			user.visible_message(span_warning(LANG("obj.c8bc97bfcca9a0c3", list(user, H, src))), \
								span_notice(LANG("obj.5f28ff1407f3bc29", list(src, H))))
			if(do_after(user, 20, target = H))
				user.visible_message(LANG("obj.c40bce62d412455e", list(user, H, src)), \
									span_notice(LANG("obj.db729c58573a5874", list(src, H))))
				H.nail_style = "nails"
				H.nail_color = paint
				H.update_body()
	else
		to_chat(user, span_warning(LANG("obj.3dd4baee3577fd00", null)))
