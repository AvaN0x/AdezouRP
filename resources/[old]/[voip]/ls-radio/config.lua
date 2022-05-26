Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted
Config.enableCmd = false --  /radio command should be active or not (if not you have to carry the item "radio") true / false

Config.messages = {

  ['not_on_radio'] = 'Actuellement hors radio',
  ['on_radio'] = 'Actuellement en radio: <b>',
  ['joined_to_radio'] = 'Tu as rejoint une radio: <b>',
  ['restricted_channel_error'] = 'Tu ne peux pas rejoindre ce chanel crypté!',
  ['you_on_radio'] = 'Tu es déjà en radio: <b>',
  ['you_leave'] = 'Tu as quitté la radio: <b>'

}
