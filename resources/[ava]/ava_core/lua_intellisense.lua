-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- ! WARNING
-- ! THE ONLY PURPOSE OF THIS FILE IS
-- ! TO WORK WITH LUA INTELLISENSE EXTENSIONS (for me on VS CODE)
-- ! WHEN USING EXPORTS
-- ! IF YOU DO NOT NEED THIS FILE, YOU CAN REMOVE IT !
-- !
-- ! THIS FILE IS NOT INCLUDED IN FXMANIFEST.LUA
---Returns AVA shared object
exports.ava_core.GetSharedObject = function()
end

-- #region shared utils
exports.ava_core.Trim = AVA.Utils.Trim
exports.ava_core.TableHasValue = AVA.Utils.TableHasValue
exports.ava_core.TableHasCondition = AVA.Utils.TableHasCondition
exports.ava_core.FormatNumber = AVA.Utils.FormatNumber
exports.ava_core.Vector3ToString = AVA.Utils.Vector3ToString
-- #endregion

-- #region client side
exports.ava_core.KeyboardInput = AVA.KeyboardInput
exports.ava_core.ShowNotification = AVA.ShowNotification
exports.ava_core.ShowConfirmationMessage = AVA.ShowConfirmationMessage
exports.ava_core.ForceHideConfirmationMessage = AVA.ForceHideConfirmationMessage
exports.ava_core.ShowHelpNotification = AVA.ShowHelpNotification
exports.ava_core.ShowFreemodeMessage = AVA.ShowFreemodeMessage
exports.ava_core.NetworkRequestControlOfEntity = AVA.NetworkRequestControlOfEntity
exports.ava_core.RequestModel = AVA.RequestModel
exports.ava_core.RequestAnimDict = AVA.RequestAnimDict
exports.ava_core.TeleportPlayerToCoords = AVA.TeleportPlayerToCoords
exports.ava_core.SpawnObject = AVA.SpawnObject
exports.ava_core.SpawnObjectLocal = AVA.SpawnObjectLocal
exports.ava_core.DeleteObject = AVA.DeleteObject
exports.ava_core.SpawnVehicle = AVA.Vehicles.SpawnVehicle
exports.ava_core.SpawnVehicleLocal = AVA.Vehicles.SpawnVehicleLocal
exports.ava_core.DeleteVehicle = AVA.Vehicles.DeleteVehicle
exports.ava_core.GetVehicleInFront = AVA.Vehicles.GetVehicleInFront
exports.ava_core.GetClosestVehicle = AVA.Vehicles.GetClosestVehicle
exports.ava_core.GetScaleformInstructionalButtons = AVA.Utils.GetScaleformInstructionalButtons
exports.ava_core.DrawText3D = AVA.Utils.DrawText3D
exports.ava_core.DrawBubbleText3D = AVA.Utils.DrawBubbleText3D
exports.ava_core.CancelableGoStraightToCoord = AVA.Utils.CancelableGoStraightToCoord
exports.ava_core.ChooseClosestPlayer = AVA.Utils.ChooseClosestPlayer
exports.ava_core.ChooseClosestVehicle = AVA.Vehicles.ChooseClosestVehicle
exports.ava_core.GetVehicleInFrontOrChooseClosest = AVA.Vehicles.GetVehicleInFrontOrChooseClosest

exports.ava_core.TriggerServerCallback = AVA.TriggerServerCallback

exports.ava_core.getPlayerData = AVA.Player.getData
exports.ava_core.getPlayerCharacterData = AVA.Player.getCharacterData
exports.ava_core.getPlayerSkinData = AVA.Player.getPlayerSkinData

exports.ava_core.IsPlayerInVehicle = AVA.Player.IsInVehicle

exports.ava_core.GeneratePickupCoords = AVA.GeneratePickupCoords

-- #endregion

-- #region server side
exports.ava_core.RegisterServerCallback = AVA.RegisterServerCallback

exports.ava_core.RegisterCommand = AVA.Commands.RegisterCommand

exports.ava_core.GetSourceIdentifiers = AVA.Players.GetSourceIdentifiers
exports.ava_core.GetPlayer = AVA.Players.GetPlayer
exports.ava_core.GetPlayerByCitizenId = AVA.Players.GetPlayerByCitizenId
exports.ava_core.UseItem = AVA.Players.UseItem
exports.ava_core.RegisterUsableItem = AVA.RegisterUsableItem
exports.ava_core.GetItemsData = AVA.GetItemsData
exports.ava_core.GetItemData = AVA.GetItemData
exports.ava_core.GetPlayerInventoryItems = AVA.GetPlayerInventoryItems
exports.ava_core.SaveAllPlayers = AVA.Players.SaveAll
exports.ava_core.GradeExistForJob = AVA.GradeExistForJob
exports.ava_core.GetGradeLabel = AVA.GetGradeLabel
exports.ava_core.GetAllJobGrades = AVA.GetAllJobGrades
exports.ava_core.SetGradeSalary = AVA.SetGradeSalary
exports.ava_core.GetJobAccounts = AVA.GetJobAccounts

exports.ava_core.GetRootingBucket = AVA.RB.GetRootingBucket
exports.ava_core.MovePlayerToRB = AVA.RB.MovePlayerToRB
exports.ava_core.MovePlayerToNamedRB = AVA.RB.MovePlayerToNamedRB

exports.ava_core.DiscordRequest = AVA.Utils.DiscordRequest
exports.ava_core.SendWebhookMessage = AVA.Utils.SendWebhookMessage
exports.ava_core.SendWebhookEmbedMessage = AVA.Utils.SendWebhookEmbedMessage
exports.ava_core.TriggerClientWithAceEvent = AVA.Utils.TriggerClientWithAceEvent

exports.ava_core.GetLicenseMaxPoints = AVA.GetLicenseMaxPoints
-- #endregion
