Config = {}
Translation = {}

Config.Shopkeeper = 416176080 -- hash of the shopkeeper ped
Config.Locale = 'fr' -- 'en', 'sv' or 'custom'

Config.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, name = name of the store (when cops get alarm, blip name etc)}
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {5000, 15000}, cops = 3, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {5000, 15000}, cops = 3, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false}

}

Translation = {
    ['en'] = {
        ['robbed'] = "I was just robbed and ~r~don't ~w~have any money left!",
        ['cashrecieved'] = 'You got:',
        ['currency'] = '$',
        ['scared'] = 'Scared:',
        ['no_cops'] = 'There are ~r~not~w~ enough cops online!',
        ['cop_msg'] = 'We have sent a photo of the robber taken by the CCTV camera!',
        ['set_waypoint'] = 'Set waypoint to the store',
        ['hide_box'] = 'Close this box',
        ['robbery'] = 'Robbery in progress',
        ['walked_too_far'] = 'You walked too far away!'
    },
    ['fr'] = { -- edit this to your language
        ['robbed'] = "J'ai été volé et je ~r~n'ai plus~s~ d'argent !",
        ['cashrecieved'] = 'Tu as eu ',
        ['currency'] = '$',
        ['scared'] = 'Effrayé:',
        ['no_cops'] = 'Il ~r~n\'y a pas~w~ assez de policiers en service!',
        ['cop_msg'] = 'On vous a envoyé une photo du braqueur grâce à la caméra!',
        ['set_waypoint'] = 'Placer un point à la superette',
        ['hide_box'] = 'Ferme cette boite',
        ['robbery'] = 'Braquage en cours',
        ['walked_too_far'] = 'Tu es parti trop loin'
    }
}