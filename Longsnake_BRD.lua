    -- *** Credit goes to Flippant for helping me with Gearswap *** --
-- ** I Use Byrth & Motenten's Functions ** --


-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------
-- HotKeys: 
-- ^ = CTRL
-- ! = Alt
-- @ = Windows Key
-- # = Apps Key

-------------------------------------------------------------------------------------------------------------------
--  Custom Hotkeys. We can add more by unbinding keys, and adding them into the gear_sets() method
-------------------------------------------------------------------------------------------------------------------

--  Abilities:  [ CTRL+` ]          Army's Paeon
--              [ CTRL+q ]          Army's Paeon 2
--              [ CTRL+a ]          Army's Paeon 3s
--              [ WIN+e ]           Honor March
--              [ ALT+` ]           Chocobo Mazurka
--              [ ALT+q ]           Rudra's Storm
--

-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------
--  The commands blow, also add to your chat log, to help you know which weapon/song is being cast. Useful to use
--  these commands over in-game macros

--  [ Song Macros ]
--  gs c C1                         Casts "Victory March" on self
--  gs c C2                         Casts "Advancing March" on self
--  gs c C3                         Casts "Valor Minuet V" on self
--  gs c C4                         Casts "Valor Minuet IV" on self
--  gs c C9                         Casts "Blade Madrigal" on self
--  gs c C10                        Casts "Sword Madrigal" on self

--  [ Armor Macros ]
--  gs c C7                         This will manually toggle Darurdabla
--  gs c C15                        This will LOCK your PDT set, regardless if you are singing songs or not
--  gs c C17                        This locks your Main weapon. Useful when you want to stay in a melee state, vs a song-duration state.
--  gs c C18						This locks your Main weapon. Useful when you want to stay in a melee state, vs a song-duration state.
--  gs c C6                         Toggles your idle stance (Refresh, DT, Movement)

-- [ Melee Toggles ]
--  gs c C16                        Toggles Accuracy type
--  gs c C9                         Casts "Blade Madrigal" on self

--  [ Misc. Functions ]
--  gs c C12                        Forces an auto update if your gear doesnt seem to be swapping? UNSURE TBH
--  gs c C8                         Displays Distance from Target (not useful anymore with other addons)

-------------------------------------------------------------------------------------------------------------------
--  Beginning and set up of the lua:
-------------------------------------------------------------------------------------------------------------------

function get_sets()
    -- Additional local binds
    send_command('bind ^` input /ma "Army\'s Paeon V" <me>')
	send_command('bind ^q input /ma "Warding Round" <me>')
	send_command('bind ^a input /ma "Goblin Gavotte" <me>')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')
	send_command('bind !q input /ws "Rudra\'s Storm" <t>')
    send_command('bind @e input /ma "Honor March" <me>')
	

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    
    
	send_command('unbind ^`')
	send_command('unbind ^q')
	send_command('unbind ^a')
    send_command('unbind !`')
	send_command('unbind !q')
    send_command('unbind @e')
end
	
	AccIndex = 1
	AccArray = {"LowACC","MidACC","HighACC"} -- 3 Levels Of Accuracy Sets For TP/WS. First Set Is LowACC. Add More ACC Sets If Needed Then Create Your New ACC Below --
	IdleIndex = 1
	IdleArray = {"Movement","Refresh", "DT"} -- Default Idle Set Is Movement --
	Armor = 'None'
	timer_reg = {}
	Daurdabla = 'On' -- Set Default Lock Daurdabla ON or OFF Here --
	Elemental_Staff = 'OFF' -- Set Default Precast Elemental Staves ON or OFF Here --
	Lock_Main = 'OFF' -- Set Default Lock Main Weapon ON or OFF Here --
	target_distance = 5 -- Set Default Distance Here --
	select_default_macro_book() -- Change Default Macro Book At The End --

	-- Daurdabla Trigger Songs: Use The Following Songs or Daurdabla Toggle To Equip Daurdabla, Add or Remove Daurdabla Songs --
	DaurdSongs = S{"Army's Paeon III","Army's Paeon IV","Warding Round","Herb Pastoral","Goblin Gavotte","Horde Lullaby","Horde Lullaby II", "Ice Carol", "Fire Carol", "Wind Carol"}

	Cure_Spells = {"Cure","Cure II","Cure III","Cure IV"} -- Cure Degradation --
	Curaga_Spells = {"Curaga","Curaga II"} -- Curaga Degradation --
	sc_map = {SC1 = "ChocoboMazurka", SC2 = "HerbPastoral", SC3 = "GoblinGavotte"} -- 3 Additional Binds. Can Change Whatever JA/WS/Spells You Like Here. Remember Not To Use Spaces. --

	sets.Idle = {
        range={ name="Linos", augments={'Mag. Evasion+3','Magic dmg. taken -4%',}},
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        hands="Inyan. Dastanas +2",
        legs="Brioso Cannions +3",
        feet="Fili Cothurnes +1",
        neck="Loricate Torque +1",
        waist="Flume Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Defending Ring",
        right_ring="Woltaris Ring +1",
        back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},
    }
	-- Idle Sets --
	sets.Idle.Refresh = set_combine(sets.Idle, {
        main="Sangoma",
        sub="Genmei Shield",
        range={ name="Linos", augments={'Mag. Evasion+3','Magic dmg. taken -4%',}},
        head={ name="Chironic Hat", augments={'STR+3','Pet: Phys. dmg. taken -2%','"Refresh"+2','Accuracy+12 Attack+12','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
        body="Inyanga Jubbah +2",
        hands={ name="Chironic Gloves", augments={'Attack+20','"Refresh"+2','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
        legs="Assid. Pants +1",
        feet="Fili Cothurnes +1",
        neck="Loricate Torque +1",
        waist="Flume Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Defending Ring",
        right_ring="Woltaris Ring +1",
        back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},
        })

	sets.Idle.Movement =  set_combine(sets.Idle, {
		range={ name="Linos", augments={'Mag. Evasion+3','Magic dmg. taken -4%',}},
        head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
        hands="Aya. Manopolas +2",
        legs="Brioso Cannions +3",
        feet="Fili Cothurnes +1",
        neck="Loricate Torque +1",
        waist="Flume Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Defending Ring",
        right_ring="Woltaris Ring +1",
        back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},
		})
    
    sets.Idle.DT = set_combine(sets.Idle, {
        main="Sangoma",
        sub="Genmei Shield",
        range={ name="Linos", augments={'Mag. Evasion+3','Magic dmg. taken -4%',}},
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        hands="Inyan. Dastanas +2",
        legs="Brioso Cannions +3",
        feet="Fili Cothurnes +1",
        neck="Loricate Torque +1",
        waist="Flume Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Odnowa Earring +1",
        left_ring="Defending Ring",
        right_ring="Woltaris Ring +1",
        back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},
    })

	sets.Resting = set_combine(sets.Idle.Movement,{})

	-- PDT Set --
	sets.PDT = {
		range={ name="Linos", augments={'Mag. Evasion+3','Magic dmg. taken -4%',}},
        head="Inyanga Tiara +2",
        body="Ayanmo Corazza +2",
        hands="Inyan. Dastanas +2",
        legs="Brioso Cannions +3",
        feet="Fili Cothurnes +1",
        neck="Loricate Torque +1",
        waist="Flume Belt +1",
        left_ear="Etiolation Earring",
        right_ear="Genmei Earring",
        left_ring="Defending Ring",
        right_ring="Inyanga Ring",
        back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},}

	sets.Precast = {
        main="Kali",
        head={ name="Chironic Hat", augments={'STR+5','"Refresh"+1','Accuracy+16 Attack+16',}},
        body="Inyanga Jubbah +2",
        hands={ name="Kaykaus Cuffs", augments={'MP+60','"Conserve MP"+6','"Fast Cast"+3',}},
        legs="Ayanmo Cosciales +2",
        feet={ name="Chironic Slippers", augments={'Pet: INT+3','"Fast Cast"+1','Phalanx +2',}},
        neck="Sanctity Necklace",
        waist="Witful Belt",
        left_ear="Infused Earring",
        right_ear="Loquac. Earring",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','CHR+5','"Fast Cast"+10',}}, 
    }
	-- Song Precast Set (empty = To Fix Club/Staff Issue) --
	sets.Precast.SongCast = {
        main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        sub="Genmei Shield",
        head="Fili Calot +1",
        body="Brioso Justau. +3",
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
        legs="Querkening Brais",
        feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
        neck="Voltsurge Torque",
        waist="Witful Belt",
        left_ear="Loquac. Earring",
        right_ear="Enchntr. Earring +1",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

	-- Elemental Staves --
	sets.Precast.Lightning = {main='Apamajas I'}
	sets.Precast.Water = {main='Haoma I'}
	sets.Precast.Fire = {main='Atar I'}
	sets.Precast.Ice = {main='Vourukasha I'}
	sets.Precast.Wind = {main='Vayuvata I'}
	sets.Precast.Earth = {main='Vishrava I'}
	sets.Precast.Light = {main='Arka I'}
	sets.Precast.Dark = {main='Xsaeta I'}

	-- Precast Daurdabla Set --
	sets.Precast.Daurdabla = {
        main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        sub="Genmei Shield",
        range="Daurdabla",
        head="Fili Calot +1",
        body="Brioso Justau. +3",
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
        legs="Querkening Brais",
        feet={ name="Bihu Slippers +3", augments={'Enhances "Nightingale" effect',}},
        neck="Voltsurge Torque",
        waist="Witful Belt",
        left_ear="Loquac. Earring",
        right_ear="Enchntr. Earring +1",
        left_ring="Kishar Ring",
        right_ring="Prolix Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
}

	-- Fastcast Set --
	sets.Precast.FastCast = {
        main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        sub="Genmei Shield",
        head="Nahtirah Hat",
        body="Inyanga Jubbah +2",
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
        legs={ name="Kaykaus Tights +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
        feet="Fili Cothurnes +1",
        neck="Voltsurge Torque",
        waist="Witful Belt",
        left_ear="Enchntr. Earring +1",
        right_ear="Loquac. Earring",
        left_ring="Prolix Ring",
        right_ring="Kishar Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }

	-- Cure Precast Set --
	sets.Precast.Cure = set_combine(sets.Precast.FastCast, {
        main={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        sub="Genmei Shield",
        head="Nahtirah Hat",
        body="Inyanga Jubbah +2",
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
        legs={ name="Kaykaus Tights +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
        feet="Fili Cothurnes +1",
        neck="Voltsurge Torque",
        waist="Witful Belt",
        left_ear="Enchntr. Earring +1",
        right_ear="Loquac. Earring",
        left_ring="Prolix Ring",
        right_ring="Kishar Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    })

	-- Midcast Base Set --
	sets.Midcast = {
        main="Carnwenhan",
        sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        head={ name="Bihu Roundlet +3", augments={'Enhances "Foe Sirvente" effect',}},
        body="Brioso Justau. +3",
        hands="Brioso Cuffs +3",
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        waist="Luminary Sash",
        left_ear="Dignitary's Earring",
        right_ear="Regal Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }

	-- Song Debuff Set --
	sets.Midcast.Wind = {
        main="Carnwenhan",
        sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        range="Gjallarhorn",
        head={ name="Bihu Roundlet +3", augments={'Enhances "Foe Sirvente" effect',}},
        body="Brioso Justau. +3",
        hands="Brioso Cuffs +3",
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        waist="Luminary Sash",
        left_ear="Musical Earring",
        right_ear="Regal Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }

	-- Song Buff Set --
	sets.Midcast.WindBuff = {
        main="Carnwenhan",
        sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        range="Gjallarhorn",
        head="Fili Calot +1",
        body="Fili Hongreline +1",
        hands="Fili Manchettes +1",
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        waist="Luminary Sash",
        left_ear="Musical Earring",
        right_ear="Regal Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }

	sets.Midcast.March = {hands="Fili Manchettes +1"}
	sets.Midcast.Minuet = {body="Fili Hongreline +1"}
	sets.Midcast.Madrigal = {head="Fili Calot +1"}
	sets.Midcast.Ballad = {legs="Fili Rhingrave +1"}
	sets.Midcast.Scherzo = {feet="Fili Cothurnes +1"}
	sets.Midcast.Mazurka = {head="Nahtirah Hat"}
	sets.Midcast.Paeon = {head="Brioso Roundlet +2"}
	sets.Midcast.Honor = {range="Marsyas"}
	
    sets.Midcast.Finale = {
        main="Carnwenhan",
        sub="Ammurapi Shield",
        range="Gjallarhorn",
        head="Brioso Roundlet +3",
        body="Brioso Justau. +3",
        hands="Brioso Cuffs +3",
        legs="Brioso Cannions +3",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        waist="Luminary Sash",
        left_ear="Dignitary's Earring",
        right_ear="Gwati Earring",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }
	sets.Midcast.Lullaby = {
        main="Carnwenhan",
        sub={ name="Kali", augments={'Mag. Acc.+15','String instrument skill +10','Wind instrument skill +10',}},
        range="Gjallarhorn",
        head="Brioso Roundlet +3",
        body="Brioso Justau. +3",
        hands="Brioso Cuffs +3",
        legs="Inyanga Shalwar +3",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        waist="Luminary Sash",
        left_ear="Musical Earring",
        right_ear="Enchanter Earring +1",
        left_ring="Stikini Ring",
        right_ring="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}},
    }

	-- Cure Set --
	sets.Midcast.Cure = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +15','MND+6','Mag. Acc.+27','Magic Damage +6',}},
		sub="Achaq Grip",
		ammo="Hydrocera",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Incanter's Torque",
		waist="Bishop's Sash",
		left_ear="Beatific Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Sirona's Ring",
		back={ name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%',}},
	}

	-- Curaga Set --
	sets.Midcast.Curaga = set_combine(sets.Midcast.Cure,{})

	-- Haste Set --
	sets.Midcast.Haste = set_combine(sets.Precast.FastCast,{})

	-- Cursna Set --
	sets.Midcast.Cursna = set_combine(sets.Midcast.Haste,{})

	-- Stoneskin Set --
	sets.Midcast.Stoneskin = set_combine(sets.Midcast.Haste,{})

	-- JA Sets --
	sets.JA = {}
	sets.JA.Nightingale = {feet="Bihu Slippers +3"}
	sets.JA.Troubadour = {body="Bihu Jstcorps. +3"}
	sets.JA['Soul Voice'] = {legs="Bihu Cannions +3"}

	-- Waltz --
	sets.Waltz = {}

	-- Melee Sets --
	sets.Melee =	{
        main="Carnwenhan",
        sub="Genmei's Shield",
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+2','Quadruple Attack +2',}},
		head="Highwing Helm",
	    neck="Bard's Charm +2",
	    left_ear="Telos Earring",
		right_ear="Cessance Earring",
		body="Ayanmo Corazza +2",
		hands={ name="Chironic Gloves", augments={'Attack+20','"Dbl.Atk."+4','Accuracy+11',}},
	    left_ring="Hetairoi Ring",
		right_ring="Petrov Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Jokushu Haidate",
		feet="Aya. Gambieras +2",
					}
		
		
	sets.Melee.MidACC = {
        main="Carnwenhan",
        sub="Genmei's Shield",
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+2','Quadruple Attack +2',}},
		head="Highwing Helm",
	    neck="Bard's CHarm +2",
	    left_ear="Suppanomimi",
		right_ear="Telos Earring",
		body="Ayanmo Corazza +2",
		hands={ name="Chironic Gloves", augments={'Attack+20','"Dbl.Atk."+4','Accuracy+11',}},
	    left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}},
		waist="Reiki Yotai",
		legs="Jokushu Haidate",
		feet="Aya. Gambieras +2",
					}
	sets.Melee.HighACC = {
        main="Carnwenhan",
        sub="Genmei's Shield",
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+2','Quadruple Attack +2',}},
		head="Highwing Helm",
	    neck="Bard's Charm +2",
	    left_ear="Suppanomimi",
		right_ear="Telos Earring",
		body="Ayanmo Corazza +2",
		hands={ name="Chironic Gloves", augments={'Attack+20','"Dbl.Atk."+4','Accuracy+11',}},
	    left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10',}},
		waist="Reiki Yotai",
		legs="Jokushu Haidate",
		feet="Aya. Gambieras +2",
					}

	-- WS Base Set --
	sets.WS = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}

	sets.WS.Exenterator = set_combine(sets.WS, {
        neck="Fotia Gorget",
        waist="Fotia Belt",
        left_ear="Moonshade Earring",
        right_ear="Ishvara Earring",
        })

 --    {
	-- head="Aya. Zucchetto +2",
 --    body="Ayanmo Corazza +2",
 --    hands="Aya. Manopolas +2",
 --    legs="Aya. Cosciales +2",
 --    feet="Aya. Gambieras +2",
 --    neck="Fotia Gorget",
 --    waist="Fotia Belt",
 --    left_ear="Moonshade Earring",
 --    right_ear="Ishvara Earring",
 --    left_ring="Petrov Ring",
 --    right_ring="Ilabrat Ring",
 --    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},}
	
	sets.WS.Exenterator.MidACC = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}
								
	sets.WS.Exenterator.HighACC = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}

	sets.WS.Evisceration = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Fotia Gorget",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Fotio Belt",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}
	
	sets.WS.Evisceration.MidACC = set_combine(sets.WS.Evisceration,{})
	sets.WS.Evisceration.HighACC = set_combine(sets.WS.Evisceration.MidACC,{})

	sets.WS["Mercy Stroke"] = set_combine(sets.WS, {
        head="Aya. Zucchetto",
        body="Ayanmo Corazza",
        hands="Aya. Manopolas",
        legs="Ayanmo Cosciales",
        feet="Aya. Gambieras",
        neck="Ainia Collar",
        waist="Kentarch Belt",
        left_ear="Mache Earring",
        right_ear="Brutal Earring",
        left_ring="Rajas Ring",
        right_ring="Ilabrat Ring",
        back="Agema Cape",
    })
	
	sets.WS["Mercy Stroke"].MidACC = set_combine(sets.WS["Mercy Stroke"],{})
	sets.WS["Mercy Stroke"].HighACC = set_combine(sets.WS["Mercy Stroke"].MidACC,{})

	sets.WS["Rudra's Storm"] = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}
	
	sets.WS["Rudra's Storm"].MidACC = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}
								
	sets.WS["Rudra's Storm"].HighACC = {
	    range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		neck="Caro Necklace",
	    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Brutal Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
	    left_ring="Ilabrat Ring",
		right_ring="Ramuh Ring +1",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
								}

	sets.WS["Mordant Rime"] =  {
		range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head="Brioso Roundlet +3",
		left_ear="Regal Earring",
		neck="Mnbw. Whistle +1",
		right_ear="Ishvara Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands="Brioso Cuffs +3",
	    left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet="Brioso Slippers +3",
		}
	
	sets.WS["Savage Blade"] = {
		range={ name="Linos", augments={'Accuracy+10','"Dbl.Atk."+2','STR+5 DEX+5',}},
		head="Brioso Roundlet +3",
		right_ear="Moonshade Earring",
		neck="Mnbw. Whistle +1",
		left_ear="Ishvara Earring",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		hands="Brioso Cuffs +3",
	    left_ring="Ilabrat Ring",
		right_ring="Petrov Ring",
	    back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
	    waist="Grunfeld Rope",
		legs={ name="Bihu Cannions +3", augments={'Enhances "Soul Voice" effect',}},
		feet="Brioso Slippers +3",						
		}
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end
end


function pretarget(spell,action)
	if spell.action_type == 'Magic' and buffactive.silence then -- Auto Use Echo Drops If You Are Silenced --
		cancel_spell()
		send_command('input /item "Echo Drops" <me>')
	elseif spell.english:ifind("Cure") and player.mp<actualCost(spell.mp_cost) then
		degrade_spell(spell,Cure_Spells)
	elseif spell.english:ifind("Curaga") and player.mp<actualCost(spell.mp_cost) then
		degrade_spell(spell,Curaga_Spells)
	end
end


function precast(spell,action)
    add_to_chat(122, spell.action_type)
	if spell.action_type == 'Magic' then
		if buffactive.silence or spell.target.distance > 16+target_distance then -- Cancel Magic or Ninjutsu or BardSong If You Are Silenced or Out of Range --
			cancel_spell()
			add_to_chat(123, spell.name..' Canceled: [Silenced or Out of Casting Range]')
			return
		else
			if spell.type == 'BardSong' then
				if Daurdabla == 'ON' then
					equip(sets.Precast.Daurdabla)
				else
					if buffactive.Nightingale then
						equip_song_gear(spell)
						return
					else
						equip_song_gear(spell)
						equip(sets.Precast.SongCast)
                        add_to_chat(122, 'song cast gear equipped')
					end
				end
			elseif spell.english:startswith('Cur') and spell.english ~= "Cursna" then
				equip(sets.Precast.Cure)
			elseif spell.english == 'Utsusemi: Ni' then
				if buffactive['Copy Image (3)'] then
					cancel_spell()
					add_to_chat(123, spell.name .. ' Canceled: [3 Images]')
					return
				else
					equip(sets.Precast.FastCast)
                    add_to_chat(122, 'Fastcase gear equipped')
				end
			else
				equip(sets.Precast.FastCast)
                add_to_chat(122, 'Fastcast gear equipped')
			end
		end
	elseif spell.type == "WeaponSkill" then
		if player.status ~= 'Engaged' then -- Cancel WS If You Are Not Engaged. Can Delete It If You Don't Need It --
			cancel_spell()
			add_to_chat(123,'Unable To Use WeaponSkill: [Disengaged]')
			return
		else
			equipSet = sets.WS
			if equipSet[spell.english] then
				equipSet = equipSet[spell.english]
			end
			if equipSet[AccArray[AccIndex]] then
				equipSet = equipSet[AccArray[AccIndex]]
			end
			if spell.english == "Evisceration" and player.tp > 2990 then
				equipSet = set_combine(equipSet,{ear1="Jupiter's Pearl"})
			end
			equip(equipSet)
		end
	elseif spell.type == "JobAbility" then
		if sets.JA[spell.english] then
			equip(sets.JA[spell.english])
		end
	elseif spell.type == "Waltz" then
		refine_waltz(spell,action)
		equip(sets.Waltz)
	elseif spell.english == 'Spectral Jig' and buffactive.Sneak then
		cast_delay(0.2)
		send_command('cancel Sneak')
	end
	if sets.Precast[spell.element] and not buffactive.Nightingale and Elemental_Staff == 'ON' then
		equip(sets.Precast[spell.element])
	end
end

function midcast(spell,action)
	equipSet = {}
	if spell.action_type == 'Magic' then
		equipSet = sets.Midcast
		if equipSet[spell.english] then
			equipSet = equipSet[spell.english]
		elseif spell.english:startswith('Cur') and spell.english ~= "Cursna" then
			if spell.english:startswith('Cure') then
				equipSet = equipSet.Cure
			elseif spell.english:startswith('Cura') then
				equipSet = equipSet.Curaga
			end
			if world.day_element == spell.element or world.weather_element == spell.element then
				equipSet = set_combine(equipSet,{back="Twilight Cape",waist="Hachirin-no-Obi"})
			end
		elseif spell.english == "Stoneskin" then
			if buffactive.Stoneskin then
				send_command('@wait 2.8;cancel stoneskin')
			end
			equipSet = equipSet.Stoneskin
		elseif spell.english == "Sneak" then
			if spell.target.name == player.name and buffactive['Sneak'] then
				send_command('cancel sneak')
			end
			equipSet = equipSet.Haste
		elseif spell.english:startswith('Utsusemi') then
			if spell.english == 'Utsusemi: Ichi' and (buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)']) then
				send_command('@wait 1.7;cancel Copy Image*')
			end
			equipSet = equipSet.Haste
		elseif spell.english == 'Monomi: Ichi' then
			if buffactive['Sneak'] then
				send_command('@wait 1.7;cancel sneak')
			end
			equipSet = equipSet.Haste
		elseif spell.type == 'BardSong' then
			if Daurdabla == 'ON' then
				equip(sets.Precast.Daurdabla)
			else
				equip_song_gear(spell)
			end
		end
	end
	equip(equipSet)
end

function aftercast(spell,action)
	if midaction() then
		return
	else
		status_change(player.status)
	end
end

function status_change(new,old)
	check_equip_lock()
	if Armor == 'PDT' then
		equip(sets.PDT)
	elseif new == 'Engaged' then
		equipSet = sets.Melee
		if equipSet[AccArray[AccIndex]] then
			equipSet = equipSet[AccArray[AccIndex]]
		end
		equip(equipSet)
	elseif new == 'Idle' then
		equipSet = sets.Idle
		if equipSet[IdleArray[IdleIndex]] then
			equipSet = equipSet[IdleArray[IdleIndex]]
		end
		if buffactive['Reive Mark'] then -- Equip Arciela's Grace +1 During Reive --
			equipSet = set_combine(equipSet,{neck="Arciela's Grace +1"})
		end
		if world.area:endswith('Adoulin') then
			equipSet = set_combine(equipSet,{body="Councilor's Garb"})
		end
		equip(equipSet)
	elseif new == 'Resting' then
		equip(sets.Resting)
	end
end

function buff_change(buff,gain)
	buff = string.lower(buff)
	if buff == "aftermath: lv.3" then -- AM3 Timer/Countdown --
		if gain then
			send_command('timers create "Aftermath: Lv.3" 180 down;wait 150;input /echo Aftermath: Lv.3 [WEARING OFF IN 30 SEC.];wait 15;input /echo Aftermath: Lv.3 [WEARING OFF IN 15 SEC.];wait 5;input /echo Aftermath: Lv.3 [WEARING OFF IN 10 SEC.]')
		else
			send_command('timers delete "Aftermath: Lv.3"')
			add_to_chat(123,'AM3: [OFF]')
		end
	elseif buff == 'weakness' then -- Weakness Timer --
		if gain then
			send_command('timers create "Weakness" 300 up')
		else
			send_command('timers delete "Weakness"')
		end
	end
	if not midaction() then
		status_change(player.status)
	end
end

-- In Game: //gs c (command), Macro: /console gs c (command), Bind: gs c (command) --
function self_command(command)
	if command == 'C1' then
		send_command('input /ma "Victory March" <me>')
		add_to_chat(158,'Melee Speed II: [Victory March]')
	elseif command == 'C2' then
		send_command('input /ma "Advancing March" <me>')
		add_to_chat(158,'Melee Speed: [Advancing March]')
	elseif command == 'C3' then
		send_command('input /ma "Valor Minuet V" <me>')
		add_to_chat(158,'Melee Attack: [Valor Minuet V]')
    elseif command == 'C4' then
        send_command('input /ma "Valor Minuet IV" <me>')
        add_to_chat(158,'Melee Attack: [Valor Minuet IV]')
	elseif command == 'C5' then
		send_command('input /ma "Valor Minuet III" <me>')
		add_to_chat(158,'Melee Attack: [Valor Minuet III]')
	elseif command == 'C9' then
		send_command('input /ma "Blade Madrigal" <me>')
		add_to_chat(158,'Melee Accuracy II: [Blade Madrigal]')
	elseif command == 'C10' then
		send_command('input /ma "Sword Madrigal" <me>')
		add_to_chat(158,'Melee Accuracy: [Sword Madrigal]')
	elseif command == 'C15' then -- PDT Toggle --
		if Armor == 'PDT' then
			Armor = 'None'
			add_to_chat(123,'PDT Set: [Unlocked]')
		else
			Armor = 'PDT'
			add_to_chat(158,'PDT Set: [Locked]')
		end
		status_change(player.status)
	elseif command == 'C17' then -- Lock Main Weapon Toggle --
		if Lock_Main == 'ON' then
			Lock_Main = 'OFF'
			add_to_chat(123,'Main Weapon: [Unlocked]')
		else
			Lock_Main = 'ON'
			add_to_chat(158,'Main Weapon: [Locked]')

		end
		status_change(player.status)
	elseif command == 'C18' then -- Lock Sub Weapon Toggle --
		if Lock_Sub == 'ON' then
			Lock_Sub = 'OFF'
			add_to_chat(123,'Sub Weapon: [Unlocked]')
		else
			Lock_Sub = 'ON'
			add_to_chat(158,'Sub Weapon: [Locked]')

		end
		status_change(player.status)
	elseif command == 'C7' then -- Daurdabla Toggle --
		if Daurdabla == 'ON' then
			Daurdabla = 'OFF'
			add_to_chat(123,'Daurdabla: [OFF]')
		else
			Daurdabla = 'ON'
			add_to_chat(158,'Daurdabla: [ON]')
		end
		status_change(player.status)
	elseif command == 'C16' then -- Accuracy Level Toggle --
		AccIndex = (AccIndex % #AccArray) + 1
		status_change(player.status)
		add_to_chat(158,'Accuracy Level: ' .. AccArray[AccIndex])
	elseif command == 'C12' then -- Auto Update Gear Toggle --
		status_change(player.status)
		add_to_chat(158,'Auto Update Gear')
	elseif command == 'C8' then -- Distance Toggle --
		if player.target.distance then
			target_distance = math.floor(player.target.distance*10)/10
			add_to_chat(158,'Distance: '..target_distance)
		else
			add_to_chat(123,'No Target Selected')
		end
	elseif command == 'C6' then -- Idle Toggle --
		IdleIndex = (IdleIndex % #IdleArray) + 1
		add_to_chat(158,'Idle Set: '..IdleArray[IdleIndex])
		status_change(player.status)
	elseif command:match('^SC%d$') then
		send_command('//' .. sc_map[command])
	end
end

function check_equip_lock() -- Lock Equipment Here --
	if player.equipment.left_ring == "Warp Ring" or player.equipment.left_ring == "Capacity Ring" or player.equipment.right_ring == "Warp Ring" or player.equipment.right_ring == "Capacity Ring" then
		disable('ring1','ring2')
	elseif player.equipment.back == "Mecisto. Mantle" or player.equipment.back == "Aptitude Mantle +1" or player.equipment.back == "Aptitude Mantle" then
		disable('back')
	elseif Lock_Main == 'ON' then
		disable('main','sub')
	else
		enable('main','sub','ring1','ring2','back')
	end
end

function equip_song_gear(spell)
	if DaurdSongs:contains(spell.english) then
		equip(sets.Precast.Daurdabla)
		add_to_chat(158,'Daurdabla: [ON]')
	else
		if spell.target.type == 'MONSTER' then
			equip(sets.Midcast.Wind)
			if string.find(spell.english,'Finale') then equip(sets.Midcast.Finale) end
			if string.find(spell.english,'Lullaby') then equip(sets.Midcast.Lullaby) end
		else
			equip(sets.Midcast.WindBuff)
			if string.find(spell.english,'March') then equip(sets.Midcast.March) end
			if string.find(spell.english,'Minuet') then equip(sets.Midcast.Minuet) end
			if string.find(spell.english,'Madrigal') then equip(sets.Midcast.Madrigal) end
			if string.find(spell.english,'Ballad') then equip(sets.Midcast.Ballad) end
			if string.find(spell.english,'Scherzo') then equip(sets.Midcast.Scherzo) end
			if string.find(spell.english,'Mazurka') then equip(sets.Midcast.Mazurka) end
			if string.find(spell.english,'Paeon') then equip(sets.Midcast.Paeon) end
			if spell.english=="Honor March" then equip(sets.Midcast.Honor) end
		end
	end
end

function actualCost(originalCost)
	if buffactive["Penury"] then
		return originalCost*.5
	elseif buffactive["Light Arts"] or buffactive["Addendum: White"] then
		return originalCost*.9
	elseif buffactive["Dark Arts"] or buffactive["Addendum: Black"] then
		return originalCost*1.1
	else
		return originalCost
	end
end

function degrade_spell(spell,degrade_array)
	spell_index = table.find(degrade_array,spell.name)
	if spell_index > 1 then
		new_spell = degrade_array[spell_index - 1]
		change_spell(new_spell,spell.target.raw)
		add_to_chat(8,spell.name..' Canceled: ['..player.mp..'/'..player.max_mp..'MP::'..player.mpp..'%] Casting '..new_spell..' instead.')
	end
end

function change_spell(spell_name,target)
	cancel_spell()
	send_command('//'..spell_name..' '..target)
end

function refine_waltz(spell,action)
	if spell.type ~= 'Waltz' then
		return
	end

	if spell.name == "Healing Waltz" or spell.name == "Divine Waltz" then
		return
	end

	local newWaltz = spell.english
	local waltzID

	local missingHP

	if spell.target.type == "SELF" then
		missingHP = player.max_hp - player.hp
	elseif spell.target.isallymember then
		local target = find_player_in_alliance(spell.target.name)
		local est_max_hp = target.hp / (target.hpp/100)
		missingHP = math.floor(est_max_hp - target.hp)
	end

	if missingHP ~= nil then
		if player.sub_job == 'DNC' then
			if missingHP < 40 and spell.target.name == player.name then
				add_to_chat(123,'Full HP!')
				cancel_spell()
				return
			elseif missingHP < 150 then
				newWaltz = 'Curing Waltz'
				waltzID = 190
			elseif missingHP < 300 then
				newWaltz = 'Curing Waltz II'
				waltzID = 191
			else
				newWaltz = 'Curing Waltz III'
				waltzID = 192
			end
		else
			return
		end
	end

	local waltzTPCost = {['Curing Waltz'] = 20, ['Curing Waltz II'] = 35, ['Curing Waltz III'] = 50}
	local tpCost = waltzTPCost[newWaltz]

	local downgrade

	if player.tp < tpCost then

		if player.tp < 20 then
			add_to_chat(123, 'Insufficient TP ['..tostring(player.tp)..']. Cancelling.')
			cancel_spell()
			return
		elseif player.tp < 35 then
			newWaltz = 'Curing Waltz'
		elseif player.tp < 50 then
			newWaltz = 'Curing Waltz II'
		end

		downgrade = 'Insufficient TP ['..tostring(player.tp)..']. Downgrading to '..newWaltz..'.'
	end

	if newWaltz ~= spell.english then
		send_command('@input /ja "'..newWaltz..'" '..tostring(spell.target.raw))
		if downgrade then
			add_to_chat(8, downgrade)
		end
		cancel_spell()
		return
	end

	if missingHP > 0 then
		add_to_chat(8,'Trying to cure '..tostring(missingHP)..' HP using '..newWaltz..'.')
	end
end

function find_player_in_alliance(name)
	for i,v in ipairs(alliance) do
		for k,p in ipairs(v) do
			if p.name == name then
				return p
			end
		end
	end
end

function sub_job_change(newSubjob, oldSubjob)
	select_default_macro_book()
end

function set_macro_page(set,book)
	if not tonumber(set) then
		add_to_chat(123,'Error setting macro page: Set is not a valid number ('..tostring(set)..').')
		return
	end
	if set < 1 or set > 10 then
		add_to_chat(123,'Error setting macro page: Macro set ('..tostring(set)..') must be between 1 and 10.')
		return
	end

	if book then
		if not tonumber(book) then
			add_to_chat(123,'Error setting macro page: book is not a valid number ('..tostring(book)..').')
			return
		end
		if book < 1 or book > 20 then
			add_to_chat(123,'Error setting macro page: Macro book ('..tostring(book)..') must be between 1 and 20.')
			return
		end
		send_command('@input /macro book '..tostring(book)..';wait .1;input /macro set '..tostring(set))
	else
		send_command('@input /macro set '..tostring(set))
	end
end

function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WHM' then
		set_macro_page(1, 2)
	elseif player.sub_job == 'BLM' then
		set_macro_page(1, 2)
	elseif player.sub_job == 'DNC' then
		set_macro_page(1, 2)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 2)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 2)
	else
		set_macro_page(1, 2)
	end
end