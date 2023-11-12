local currentStage = 1
local FINAL_STAGE = 13
local TUTORIAL_STAGES = {
    --[[[1] = {"Welcome", "Hello and Welcome to OwlGaming! \n\nYou've successfully passed the application stage and you're on your journey to begin roleplaying here. To help you get started we've created this tutorial, enjoy!", 1271.6337890625, -2037.69140625, 81.409843444824, 1125.6396484375, -2036.96484375, 69.880661010742},
    [2] = {"Properties", "Los Santos offers a variety of properties you may buy, including both commercial and residential locations such as shops, garages, businesses, and houses. New characters receive a property token allowing you to purchase a house with a value up to $40,000, allowing you to start roleplaying immediately as if you were already a resident of Los Santos!\n\nWhen purchasing a property you may choose to use a default interior provided or you may upload your own custom mapped interior, purchasable with GameCoins through our interior uploader on the User Control Panel.", 2092.314453125, -1220.6669921875, 35.311351776123, 2108.9404296875, -1240.2802734375, 27.001424789429},
    [3] = {"Vehicles", "There's a large variety of vehicles always available from the scripted shops (not including player sold vehicles): \n\n - Ocean Docks Car Shop (Standard Cars) \n - Ocean Docks Truck/Industrial Shop (Industrial Vehicles) \n - Jefferson Car Shop (Standard Cars) \n - Santa Maria Beach Boat Shop (Boats) \n - Grotti's Car Shop (Sports Vehicles) \n - Idlewood Bike Shop (Motorcycles) \n\nNew characters are provided with a vehicle token, just like property tokens, these tokens allow you to buy a vehicle right away without having to grind a script job. They have a value of up to $35,000. Don't forget to /park your new vehicle! If a vehicle respawn occurs and you do not /park it, it will get deleted.", 2111.3681640625, -2116.8876953125, 21.02206993103, 2128.1513671875, -2138.896484375, 15.001725196838},
    [4] = {"DMV", "Here at the Department of Motor Vehicles (otherwise known as DMV) you can do many of things. The main reason why you would visit here is to acquire a drivers license, but you can always acquire many different types of licenses here and even register / unregister your vehicles. \n\nFrom the DMV you can also buy DMV Transaction papers, these allow you to sell your vehicle to another player within the DMV parking lot. (You cannot sell your token vehicle).", 1061.421875, -1752.6943359375, 25.57329750061, 1105.625, -1792.9228515625, 17.421173095703},
    [5] = {"Bank", "Here is the Los Santos Bank. At the bank, you can withdraw, deposit, and transfer money between other players and factions. The bank is also the place where you can order ATM cards.", 626.2001953125, -1207.552734375, 35.195793151855, 600.30859375, -1239.025390625, 20.625173568726},
    [6] = {"ATMS", "Around Los Santos, you'll notice a lot of ATMs.\n\nThese may be utilized by dragging the card you ordered at the bank onto the machine itself. Depending on the card you bought at the Bank you'll be able to withdraw a certain amount from an ATM.\n\nWe offer three types of ATM cards, these are: \n - Basic ATM Card ($0 -> $10,000) \n - Premium ATM Card ($0 -> $50,000) \n - Ultimate ATM Card (Unlimited)\n\nEach ATM card has its own cost, you can view the costs at the Bank NPC.", 1106.2578125, -1792.5869140625, 19.298328399658, 1110.90625, -1790.431640625, 16.59375},
    [7] = {"County Hall", "Here at County Hall, there are a variety of jobs you may choose from, these jobs are designed to help you get on your feet financially. They include:\n- City Maintenance\n- Bus Driving\n- Taxi Driving\n- Delivery Driver\n\nAnother starting job which you can't sign up for at City Hall is fishing. To begin fishing you need to buy a Fishing Rod from a General Store, a boat from the boat store and then head out to sea! Players seeking the Mechanic Job should report for an administrator to set it for them and should have an RP reason for acquiring that job.", 1526.1279296875, -1712.4970703125, 25.736494064331, 1497.982421875, -1738.583984375, 18.620281219482},
    [8] = {"Taxi & Bus Driver", "Here is the Taxi and Bus depot. \n\nYou'll be able to find both taxis and buses ready for you to take (You need the job before you may drive the vehicle(s) and transport the citizens of Los Santos around!). Keep in mind that these vehicles should be used for the purposes of the job and not personal transportation.", 1823.2099609375, -1912.7138671875, 30.250659942627, 1789.2900390625, -1910.4990234375, 19.221006393433},
    [9] = {"RSHaul", "Here is RSHaul \n\nAt RSHaul there are 5 levels of progression, starting with the small vans and working your way up to the big commercial transport trucks. As an RSHaul driver, you're tasked with making deliveries to locations decided by the trucking company, depending on each job you'll be paid a certain amount. These deliveries are made to both pre-scripted locations and player stores, so your delivery helps stock the stores and make a difference in the server's economy.", -104.125, -1119.65234375, 2.7560873031616, -79.01953125, -1117.978515625, 1.078125},
    [10] = {"Fishing", "Do you wanna be the next Ray Scott? \n\nTo fish all you need is a rod and a boat then head out into the bay! You can begin fishing once you have the items with /startfishing. After a few moments, you'll see that you've caught a fish. After reeling in your fish you'll be given the fish item which you can later sell to Fisherman John who is located by the bait store in Los Santos at the docks.", 163.1201171875, -1903.20703125, 19.174238204956, 134.77734375, -1962.0517578125, 15.005571365356},
    [11] = {"Legal Factions", "After making a bit of starting cash with one of our many scripted jobs you might want to start looking at joining a legal faction.\n\nYou can normally find recruitment for legal factions on OwlGaming's forums or the factions website (Links to Government websites can be found on owlgaming.net and most factions websites can be found on docs.owlgaming.net)", 1513.9677734375, -1674.328125, 33.480712890625, 1552.08203125, -1675.1279296875, 17.445131301882},
    [12] = {"Illegal Factions", "Do you fancy making a bit of money but don't wanna make it through legal means?\n\nIn that case, you might be interested in joining an illegal faction. Illegal factions are responsible for supplying the streets with contraband. Each faction supplies different types of contraband. Some illegal factions roleplay on the streets and some factions roleplay behind the scenes, depending on how you develop your character you have a choice of what sort of illegal faction you may join. You can view illegal factions on the OwlGaming Forums.", 2180.5078125, -1647.9208984375, 29.288076400757, 2140.115234375, -1625.4150390625, 15.865843772888},
    [13] = {"Final Note", "Roleplaying with factions is as endless as your imagination, by exploring the server and meet new people. You'll find lots of interesting scenarios both legal and illegal.", 1981.0166015625, -1349.6162109375, 61.649375915527, 1925.7919921875, -1400.3291015625, 34.439781188965}
--]]
    [1] = {"Vítejte", "Ahoj a vítejte na MNTK RP! \n\nÚspěšně jsi se přihlásil a začínáš svou cestu s roleplayingem. Abychom vám pomohli začít, vytvořili jsme tento tutoriál, užijte si to!", 1271.6337890625, -2037.69140625, 81.409843444824, 1125.6396484375, -2036.96484375, 69.880661010742},
    [2] = {"Nemovitosti", "Los Santos nabízí širokou škálu nemovitostí, které můžete koupit, včetně obchodních a obytných prostorů, jako jsou obchody, garáže, podniky a domy.", 2092.314453125, -1220.6669921875, 35.311351776123, 2108.9404296875, -1240.2802734375, 27.001424789429},
    [3] = {"Vozidla", "Vždy jsou k dispozici různé typy vozidel ze skriptovaných obchodů (nezahrnuje vozidla prodaná hráči): \n\n - Ocean Docks Car Shop (Standardní auta) \n - Ocean Docks Truck/Industrial Shop (Průmyslová vozidla) \n - Jefferson Car Shop (Standardní auta) \n - Santa Maria Beach Boat Shop (Lodě) \n - Grotti's Car Shop (Sportovní vozidla) \n - Idlewood Bike Shop (Motorky).\n\n Nezapomeňte své nové vozidlo /zaparkovat! Pokud dojde k obnovení vozidla a nezaparkujete ho pomocí příkazu /park, bude smazáno.", 2111.3681640625, -2116.8876953125, 21.02206993103, 2128.1513671875, -2138.896484375, 15.001725196838},
    [4] = {"Dopravní úřad", "Zde na Dopravním úřade můžete dělat mnoho věcí. Hlavním důvodem, proč byste sem mohli přijít, je získání řidičského průkazu, ale vždy můžete získat různé typy licencí a dokonce i zaregistrovat/odregistrovat svá vozidla.\n\nZ DMV si můžete také koupit doklady o transakci DMV, které vám umožní prodávat vozidlo jinému hráči na parkovišti DMV.", 1061.421875, -1752.6943359375, 25.57329750061, 1105.625, -1792.9228515625, 17.421173095703},
    [5] = {"Banka", "Zde je Banka Los Santos. V bance můžete vybírat, vkládat a převádět peníze mezi jinými hráči a frakcemi. Banka je také místem, kde si můžete objednat ATM karty.", 626.2001953125, -1207.552734375, 35.195793151855, 600.30859375, -1239.025390625, 20.625173568726},
    [6] = {"Bankomaty", "Po Los Santos si všimnete mnoha bankomatů.\n\nTyto mohou být využity přetažením karty, kterou jste si objednali v bance, přímo na zařízení. V závislosti na kartě, kterou jste zakoupili v bance, budete moci vybrat určitou částku z bankomatu.\n\nNabízíme tři typy karet k bankomatu: \n - Základní ATM karta ($0 -> $10,000) \n - Prémiová ATM karta ($0 -> $50,000) \n - Ultimate ATM karta (Neomezená)\n\nKaždá ATM karta má své náklady, které můžete zobrazit u NPC v bance.", 1106.2578125, -1792.5869140625, 19.298328399658, 1110.90625, -1790.431640625, 16.59375},
    [7] = {"Krajský úřad", "Zde na Krajském úřadě si můžete vybrat z různých zaměstnání, která vám mohou pomoci dostat se na vlastní nohy finančně. Patří sem:\n- Údržba města\n- Řidič autobusu\n- Řidič taxi\n- Řidič dodávky\n\nDalší začínající práci, na kterou se nemůžete přihlásit na radnici, je rybolov. Pro začátek rybaření potřebujete koupit rybářský prut v obchodě se smíšeným zbožím, loď v obchodě s loděmi a pak vyrazit na moře! Hráči, kteří hledají práci mechanika, by se měli přihlásit k administrátorovi, aby ji nastavili, a měli by mít RP důvod k získání této práce.", 1526.1279296875, -1712.4970703125, 25.736494064331, 1497.982421875, -1738.583984375, 18.620281219482},
    [8] = {"Řidič taxi a autobusu", "Zde je depo na taxi a autobusy. \n\nNajdete zde taxi a autobusy připravené k jízdě (předtím, než budete moci řídit vozidla, je nutné mít dané zaměstnání a přepravovat občany Los Santos!). Mějte na paměti, že tato vozidla by měla být používána v rámci zaměstnání a ne jako osobní doprava.", 1823.2099609375, -1912.7138671875, 30.250659942627, 1789.2900390625, -1910.4990234375, 19.221006393433},
    [9] = {"RSHaul", "Zde je RSHaul \n\nU RSHaul existuje 5 úrovní postupu, začínaje malými dodávkami a postupně se dostáváte k velkým nákladním nákladním autům. Jako řidič RSHaul jste pověřeni dodávkou na místa určená nákladní společností, v závislosti na každé práci dostanete určitou částku. Tyto dodávky jsou provedeny jak na předem napsané lokace, tak do obchodů hráčů, takže vaše dodávka pomáhá zásobovat obchody a má vliv na ekonomiku serveru.", -104.125, -1119.65234375, 2.7560873031616, -79.01953125, -1117.978515625, 1.078125},
    [10] = {"Rybářství", "Chcete být dalším Rayem Scottem? \n\nK rybaření potřebujete pouze prut a loď, pak vyrazte do zálivu! Rybařit můžete začít poté, co máte předměty s /startfishing. Po chvíli uvidíte, že jste chytili rybu. Po navinutí ryby dostanete předmět ryby, který později můžete prodat rybáři Johnovi, který se nachází u obchodu se návnadou v Los Santos u přístavu.", 163.1201171875, -1903.20703125, 19.174238204956, 134.77734375, -1962.0517578125, 15.005571365356},
    [11] = {"Legálni frakce", "Po získání trochy startovní hotovosti jedním z našich mnoha skriptovaných zaměstnání byste mohli začít uvažovat o připojení k legalni frakci.\n\nRekrutaci do právních frakcí obvykle najdete na fórech OwlGaming nebo na webu frakcí ", 1513.9677734375, -1674.328125, 33.480712890625, 1552.08203125, -1675.1279296875, 17.445131301882},
    [12] = {"Nelegální frakce", "Máte chuť vydělat trochu peněz, ale nechcete to dělat legálně?\n\nV takovém případě by vás mohlo zajímat připojení k nelegální frakci. Nelegální frakce jsou zodpovědné za dodávky ulicím s pašovaným zbožím. Každá frakce dodává různé druhy pašovaného zboží. Některé nelegální frakce hrají role na ulicích a některé frakce hrají role za scénou, v závislosti na tom, jak vyvíjíte svou postavu, máte možnost vybrat si, k jaké nelegální frakci se přidáte.", 2180.5078125, -1647.9208984375, 29.288076400757, 2140.115234375, -1625.4150390625, 15.865843772888},
    [13] = {"Závěrečná poznámka", "Roleplaying s frakcemi je tak nekonečné, jaká je vaše představivost, objevujte server a seznamujte se s novými lidmi. Najdete zde spoustu zajímavých scénářů jak legálních, tak nelegálních.", 1981.0166015625, -1349.6162109375, 61.649375915527, 1925.7919921875, -1400.3291015625, 34.439781188965}

}

function runTutorial()
    tutorialWindow = guiCreateWindow(0.78, 0.63, 0.21, 0.35, "", true)
    guiWindowSetMovable(tutorialWindow, false)
    guiWindowSetSizable(tutorialWindow, false)
    showCursor(true)
    fadeCamera(true, 2.5)

    tutorialLabel = guiCreateLabel(0.02, 0.08, 0.95, 0.77, "", true, tutorialWindow)
    guiSetFont(tutorialLabel, "clear-normal")
    guiLabelSetHorizontalAlign(tutorialLabel, "left", true)

    backButton = guiCreateButton(0.02, 0.87, 0.45, 0.10, "Předchozí", true, tutorialWindow)
    nextButton = guiCreateButton(0.52, 0.87, 0.45, 0.10, "Následující", true, tutorialWindow)

    setStage(1)
    addEventHandler("onClientGUIClick", tutorialWindow, buttonFunctionality)
end
addEvent("tutorial:run", true)
addEventHandler("tutorial:run", root, runTutorial)

function setStage(stage)
    if (stage > FINAL_STAGE) then 
        currentStage = -1
        fadeCamera(false)
        guiSetText(tutorialWindow, "MNTK RP Tutorial - Dokončen")
        guiSetText(tutorialLabel, "Dokončili jste tutoriál, co byste chtěli dělat dál?")
        guiSetText(nextButton, "Ukončit tutorial")
    else
        guiSetText(tutorialWindow, "MNTK RPTutorial - " .. TUTORIAL_STAGES[stage][1])
        guiSetText(tutorialLabel, TUTORIAL_STAGES[stage][2])
        setCameraMatrix(TUTORIAL_STAGES[stage][3], TUTORIAL_STAGES[stage][4], TUTORIAL_STAGES[stage][5], TUTORIAL_STAGES[stage][6], TUTORIAL_STAGES[stage][7], TUTORIAL_STAGES[stage][8], 0, 90)
        
        if not guiGetVisible(tutorialWindow) then 
            guiSetVisible(tutorialWindow, true)
        end
    end
end

function buttonFunctionality(button, state)
    if (button == "left") and (source == backButton) then 
        if (currentStage == 1) then 
            return
        elseif (currentStage == -1) then 
            currentStage = FINAL_STAGE
            fadeClientScreen()
            guiSetText(nextButton, "Následující")
            setTimer(setStage, 1000, 1, currentStage)
        else
            currentStage = currentStage - 1
            fadeClientScreen()
            setTimer(setStage, 1000, 1, currentStage)
        end            
    elseif (button == "left") and (source == nextButton) then 
        if (currentStage == -1) then 
            removeEventHandler("onClientGUIClick", tutorialWindow, buttonFunctionality)
            destroyElement(tutorialWindow)   
            triggerServerEvent("accounts:tutorialFinished", resourceRoot)
        else
            currentStage = currentStage + 1
            fadeClientScreen()
            setTimer(setStage, 1000, 1, currentStage)
        end
    end
end

function fadeClientScreen()
    fadeCamera(false)
    setTimer(function()
        fadeCamera(true, 2.5)
    end, 1000, 1)
end
